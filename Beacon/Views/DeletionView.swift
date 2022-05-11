import AlanSDK
import SwiftUI


struct DeletionView: View {
    @EnvironmentObject var sceneManager: SceneManager
    @EnvironmentObject var modelDeletionManager: ModelDeletionManager
    @EnvironmentObject var placementSettings: PlacementSettings
    @EnvironmentObject var arSessionManager: ARSessionManager
    
    var body: some View {
        HStack{
            Spacer()
            DeletionButton(systemIconName: "xmark.circle.fill") {
                print("Cancel deletion button pressed")
                self.modelDeletionManager.entitySelectedForDeletion = nil
            }
            .padding(.trailing, 30)
            DeletionButton(systemIconName: "cart.fill.badge.plus") {
                print("confirm delete button pressed")
                guard let anchor = self.modelDeletionManager.entitySelectedForDeletion?.anchor else { return }
                
                self.placementSettings.collectedBeacons += 1
                
                let anchoringIdentifier = anchor.anchorIdentifier
                if let index = self.sceneManager.anchorEntities.firstIndex(where: { $0.anchorIdentifier == anchoringIdentifier }) {
                    print("deleting anchorEntity with id: \(String(describing: anchoringIdentifier))")
                    self.sceneManager.anchorEntities.remove(at: index)
                }
                if let identifier = anchoringIdentifier {
                    if let anchorDataToDelete = self.arSessionManager.arView.getAnchor(by: identifier, lookupEntities: true) {
                        self.arSessionManager.delete(anchorData: anchorDataToDelete)
                    }
                }
                
                anchor.removeFromParent()
                self.modelDeletionManager.entitySelectedForDeletion = nil
                
                self.arSessionManager.nearbyBeacons = self.arSessionManager.arView.anchorDistances
                    .filter({ $0.value <= self.arSessionManager.arView.maximumVisibleAnchorDistance })
                    .compactMap({ $0.key })
                    .compactMap({ id in self.arSessionManager.arView.getAnchors().first(where: {$0.id == id })})
                
            }
            .padding(.trailing, 60)
            Spacer()
        }
        .padding(.bottom, 30)
    }
}

struct DeletionButton: View{
    let systemIconName: String
    let action: () -> Void
    var body: some View{
        Button(action: {
            self.action()
        }) {
            Image(systemName: systemIconName)
                .font(.system(size: 50, weight: .light, design: .default))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 75, height: 75)
    }
}
