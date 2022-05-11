import AlanSDK
import Foundation
import SwiftUI
import RealityKit
import ARKit


private let anchorNamePrefix = "model-"

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var placementSettings: PlacementSettings
    @EnvironmentObject var sceneManager: SceneManager
    @EnvironmentObject var modelsViewModel: ModelsViewModel
    @EnvironmentObject var modelDeletionManager: ModelDeletionManager
    @EnvironmentObject var arSessionManager: ARSessionManager
    
    func makeUIView(context: Context) -> CustomARView{
        
        let arView = arSessionManager.arView
        
        self.placementSettings.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self, { (event) in
            self.updateScene(for: arView)
            self.updatePersistenceAvailability(for: arView)
            self.handlePersistence(for: arView)
        })
        
        return arView
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {}
    
    //TODO: look up argument labels
    
    private func updateScene(for arView: CustomARView) {
        
        //only display logic for focus entity
        arView.focusEntity?.isEnabled = self.placementSettings.selectedModel != nil
        
        if let confirmedModel = self.placementSettings.confirmedModel, let modelEntity = confirmedModel.modelEntity {
            self.arSessionManager.place(modelEntity)
            self.placementSettings.confirmedModel = nil
        }
         
    }
    
    
    private func getTransformForPlacement(in arView: ARView) -> simd_float4x4? {
        guard let query = arView.makeRaycastQuery(from: arView.center, allowing: .estimatedPlane, alignment: .any) else {
            return nil
        }
        guard let raycastResult = arView.session.raycast(query).first else { return nil }
        return raycastResult.worldTransform
    }
    
}

// MARK: - Persistence

class SceneManager: ObservableObject {
    @Published var isPersistenceAvailable: Bool = false
    @Published var anchorEntities: [AnchorEntity] = [] // keeps track of acnhor entities in the scene
    
    var shouldSaveSceneToFileSystem: Bool = false
    var shouldLoadSceneFromFileSystem: Bool = false
    
    lazy var persistenceUrl: URL = {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("arf.persistence")
        } catch {
            fatalError("Unable to get persistenceUrl: \(error.localizedDescription)")
        }
    }()
    
    var scenePersistenceData: Data? {
        return try? Data(contentsOf: persistenceUrl)
    }
}

extension ARViewContainer {
    private func updatePersistenceAvailability(for arView: ARView) {
        guard let currentFrame = arView.session.currentFrame else {
//            print("ARFrame not avaialble")
            return
        }
        switch currentFrame.worldMappingStatus {
        case.mapped, .extending:
            self.sceneManager.isPersistenceAvailable = !self.sceneManager.anchorEntities.isEmpty
        default:
            self.sceneManager.isPersistenceAvailable = false
        }
        
    }
    
    private func handlePersistence(for arView: CustomARView){
        if self.sceneManager.shouldSaveSceneToFileSystem {
            ScenePersistenceHelper.saveScene(for: arView, at: self.sceneManager.persistenceUrl)
            
            self.sceneManager.shouldSaveSceneToFileSystem = false
        } else if self.sceneManager.shouldLoadSceneFromFileSystem{
            
            guard let scenePersistenceData = self.sceneManager.scenePersistenceData else {
                print("unable to retrieve scenePersistenceData. Cancelled loadSCene operation")
                self.sceneManager.shouldLoadSceneFromFileSystem = false
                return
            }
            
            self.modelsViewModel.clearModelEntitiesFromMemory()
            self.sceneManager.anchorEntities.removeAll(keepingCapacity: true)
            
            ScenePersistenceHelper.loadScene(for: arView, with: scenePersistenceData)
            
            self.sceneManager.shouldLoadSceneFromFileSystem = false
        }
    }
    
}
