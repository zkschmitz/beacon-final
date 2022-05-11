import Foundation
import ARKit
import RealityKit
import LocationBasedAR


extension ARSessionManager {
    
    internal func initGestures() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
        arView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer){
        let location = recognizer.location(in: arView)
        if let entity = arView.entity(at: location) as? ModelEntity {
            self.deletionManager!.entitySelectedForDeletion = entity
        }
    }
}

