import Foundation
import RealityKit
import ARKit
import LocationBasedAR

class ScenePersistenceHelper {
    class func saveScene(for arView: CustomARView, at persistenceUrl: URL){
        print("save scene to local file system")
        // 1. get current world map
        arView.session.getCurrentWorldMap {
            worldMap, error in
            
            // 2. safely unwrap
            guard let map = worldMap else {
                print("persistence error: unable to get world map: \(error!.localizedDescription)")
                return
            }
            
            do {
                let sceneData = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                try sceneData.write(to: persistenceUrl, options: [.atomic])
            } catch {
                print("persistence error: Cannot save to local file system: \(error.localizedDescription)")
            }
        }
    }
    class func loadScene(for arView: CustomARView, with scenePersistenceData: Data){
        print("load scene from local file system")
        
        let worldMap: ARWorldMap = {
            do {
                guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: scenePersistenceData) else {
                    fatalError("Persisting Error: no ARWorldMap in archive")
                }
                return worldMap
            } catch {
                fatalError("persistence error: unable to unarchive arworldmap from scenepersistencedata: \(error.localizedDescription)")
            }
        }()
        
        let newConfig = LBARView.defaultConfiguration()
        newConfig.planeDetection = [.horizontal]
        newConfig.initialWorldMap = worldMap
        arView.session.run(newConfig, options: [.resetTracking, .removeExistingAnchors])
    }
}
