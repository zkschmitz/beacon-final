import Foundation
import ARKit
import RealityKit
import LocationBasedAR

private let anchorNamePrefix = "model-"

extension ARSessionManager: LBARViewDelegate {
    
    func view(_ view: LBARView, didAdd anchors: [LBAnchor]) {
        print("\(#file) -- ARSessionManager/LBARViewDelegate -- didAdd \(anchors.debugDescription)")
        self.addCallback?(anchors)
        self.nearbyBeacons = self.arView.anchorDistances
            .filter({ $0.value <= self.arView.maximumVisibleAnchorDistance })
            .compactMap({ $0.key })
            .compactMap({ id in self.arView.getAnchors().first(where: {$0.id == id })})
    }
    
    func view(_ view: LBARView, didUpdate anchors: [LBAnchor]) {
        self.addCallback?(anchors)
    }
    
    func view(_ view: LBARView, didRemove anchors: [LBAnchor]) {
        print("\(#file) -- ARSessionManager/LBARViewDelegate -- didRemove \(anchors.debugDescription)")
        self.removeCallback?(anchors)
    }
}

extension ARSessionManager: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Do not enqueue other buffers for processing while another Vision task is still running.
        // The camera stream has only a finite amount of buffers available; holding too many buffers for analysis would starve the camera.
        //        guard self.currentBuffer == nil, case .normal = frame.camera.trackingState else {
        //            return
        //        }
        frameCounter += 1
        // Retain the image buffer for Vision processing.
        self.currentBuffer = frame.capturedImage
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: currentBuffer!, orientation: .up, options: [:])
        do {
            // Release the pixel buffer when done, allowing the next buffer to be processed.
            try requestHandler.perform([self.handPoseRequest])

            guard let handPoses = handPoseRequest.results, !handPoses.isEmpty else {
                return
            }

            let handObservation = handPoses.first

            if frameCounter % handPosePredictionInterval == 2 {
                guard let keypointsMultiArray = try? handObservation!.keypointsMultiArray()
                else { fatalError() }
                let handPosePrediction = try handPoseClassification.prediction(poses: keypointsMultiArray)
                let confidence = handPosePrediction.labelProbabilities[handPosePrediction.label]!
                if confidence > 0.92 {
                    if prevClassification == handPosePrediction.label{
                        self.consecutiveClassifications += 1
                    } else {
                        self.consecutiveClassifications = 0
                    }
                    print(handPosePrediction.label, prevClassification, consecutiveClassifications)

//                    if handPosePrediction.label == "Index Finger Point" && self.placementSettings!.selectedModel != nil {
//                        let modelAnchor = ModelAnchor(model: self.placementSettings!.selectedModel!, anchor: nil)
//                        self.placementSettings.confirmedModel = self.placementSettings.selectedModel
//                        self.placementSettings!.selectedModel = nil
//                    }
                    if handPosePrediction.label == "Vertical Closed Fist"{
                        if let model = self.modelsViewModel!.get(category: .beacon).first {
                            model.asyncLoadModelEntity{ completed, error in
                                if completed {
//                                    let modelAnchor = ModelAnchor(model: model, anchor: nil)
//                                    self.placementSettings!.modelsConfirmedForPlacement.append(modelAnchor)
                                    self.placementSettings!.confirmedModel = model
                                }
                            }
                            print("placing star beacon into the scene")
                        }
                        consecutiveClassifications = 0
                    }
                    prevClassification = handPosePrediction.label
                }
            }
        } catch {
            print("Error: Vision request failed with error \"\(error)\"")
        }
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        // ...
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        // ...
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        // ...
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        print("AR Session error: \(error)")
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .limited(let reason):
            switch reason {
//            case .initializing: print("Notification.ARTracking.initializing")
//            case .excessiveMotion: print("Notification.ARTracking.tooFast")
//            case .insufficientFeatures: print("Notification.ARTracking.lowFeatures")
//            case .relocalizing: print("Notification.ARTracking.relocalizing")
            @unknown default:
                break
            }
        case .normal: print("Notification.ARTracking.tracking")
        default: break
        }
    }
}
