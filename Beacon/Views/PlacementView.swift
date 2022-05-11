import SwiftUI
import AlanSDK

struct PlacementView: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @EnvironmentObject var arSessionManager: ARSessionManager
    
    static let shared = PlacementView()
    
    func voicePlacement() {
        print("Confirm placement button pressed")
        if(ARSessionManager.shared.arView.focusEntity!.onPlane){
            PlacementSettings.shared.showWarningMessage = false
            PlacementSettings.shared.confirmedModel = PlacementSettings.shared.selectedModel
            PlacementSettings.shared.selectedModel = nil
        }
        else{
            print("Entity not on plane, place on the ground")
            self.placementSettings.showWarningMessage = true
        }
    }
    
    var body: some View{
        HStack {
            
            PlacementButton(systemIconName: "xmark.circle.fill") {
                print("Cancel Placement Button Pressed.")
                self.placementSettings.selectedModel = nil
            }
            .padding(.leading, 30)
            Spacer()
            PlacementButton(systemIconName: "checkmark.circle.fill") {
                print("Confirm placement button pressed")
//                voicePlacement()
                if(self.arSessionManager.arView.focusEntity!.onPlane){
                    self.placementSettings.showWarningMessage = false
                    self.placementSettings.confirmedModel = self.placementSettings.selectedModel
                    self.placementSettings.selectedModel = nil
                }
                else{
                    print("Entity not on plane, place on the ground")
                    self.placementSettings.showWarningMessage = true
                }
            }
            .padding(.trailing, 30)
            Spacer()
        }
        .padding(.bottom, 40)
    }
}

struct PlacementButton: View{
    @EnvironmentObject var placementSettings: PlacementSettings
    @EnvironmentObject var arSessionManager: ARSessionManager
    
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
        .frame(width: 80, height: 80)
    }
    
    

}
