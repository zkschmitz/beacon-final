import Foundation
import ARKit
import RealityKit
import LocationBasedAR


extension ARSessionManager {
    
    func place(_ modelEntity: ModelEntity) {
        //clone
        let clonedEntity = modelEntity.clone(recursive: true)
        
        //enable translation
        clonedEntity.generateCollisionShapes(recursive: true)
//        arView.installGestures([.translation, .rotation], for: clonedEntity)
        
        //create anchor entity and add clone
        let anchorEntity = AnchorEntity(plane: .any)
        anchorEntity.addChild(clonedEntity)
        
        arView.scene.addAnchor(anchorEntity)
        
        self.sceneManager!.anchorEntities.append(anchorEntity)

        
        let matrix = anchorEntity.transformMatrix(relativeTo: nil)
        self.arView.worldTransformToLocation(matrix) { result in
            switch result {
            case .failure(let err): print("err: \(err)")
            case .success(let location):
                print("added model @ LOCATION: \(location)")
                self.arView.add(entity: anchorEntity, with: location)
            }
        }
    }
    
    func delete(anchorData: LocationAnchorData) {
        self.arView.remove(by: anchorData.id)
    }
}
