import AlanSDK
import SwiftUI
import UIKit

struct ContentView: View {
    
    @EnvironmentObject var locationManager: LocationBasedManager
    @EnvironmentObject var mapViewModel: MapViewModel
    @EnvironmentObject var modelsViewModel: ModelsViewModel
    
    @EnvironmentObject var placementSettings: PlacementSettings
    @EnvironmentObject var modelDeletionManager: ModelDeletionManager
    @EnvironmentObject var arSessionManager: ARSessionManager
    @EnvironmentObject var sceneManager: SceneManager
    
    @State private var selectedControlMode: Int = 0
    //    @State private var isMapVisible: Bool = false
    //    @State private var showBrowse: Bool = false
    
    
    
    
    var body: some View {
        ZStack(alignment: .top){
            ZStack(alignment: .bottom) {
                if(mapViewModel.isMapVisible){
                    MapContainer()
                        .onAppear(perform: {
                            
                            let anchors = arSessionManager.arView.getAnchors().compactMap { $0.anchor }
                            mapViewModel.addAnchors(anchors)
                            
                            mapViewModel.focusOnUserLocation()
                        })
                }
                else{
                    ARViewContainer()
                        .onAppear(perform: {
                            arSessionManager.deletionManager = modelDeletionManager
                            arSessionManager.modelsViewModel = modelsViewModel
                            arSessionManager.placementSettings = placementSettings
                            arSessionManager.sceneManager = sceneManager
                        })
                }
                
                if self.placementSettings.selectedModel != nil {
                    PlacementView()
                } else if self.modelDeletionManager.entitySelectedForDeletion != nil {
                    DeletionView()
                }
                else {
                    ControlView(selectedControlMode: $selectedControlMode)
                }
            }
            if self.placementSettings.showWarningMessage {
                DisplayMessage(message: "Beacons can only be placed on flat surfaces")
                    .onAppear(perform: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                            self.placementSettings.showWarningMessage = false
                        })
                    })
            }
            if(!mapViewModel.isMapVisible){
                VStack{
                    CollectionView()
                    Spacer()
                }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    alignment: .topLeading
                )
                .padding(30)
                .padding(.top, 20)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: {
            
            //            arSessionManager.addCallback = mapViewModel.addAnchors(_:)
            //            arSessionManager.removeCallback = mapViewModel.removeAnchors(_:)
            
            locationManager.start()
            
            locationManager.onLocationChanged = arSessionManager.receive(location:)
            arSessionManager.configure(locationManager)
            
            UIApplication.shared.addAlan()
        })
        .onDisappear(perform: {
            locationManager.stop()
        })
    }
}

struct DisplayMessage: View {
    let message: String
    
    var body: some View {
        ZStack{
            Color.black.opacity(0.25)
            VStack{
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size:35))
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                Text(message)
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .padding(10)
        }
        .frame(width: 200, height: 120)
        .cornerRadius(8.0)
        .transition(.scale)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PlacementSettings())
            .environmentObject(SceneManager())
            .environmentObject(ModelsViewModel())
            .environmentObject(ModelDeletionManager())
    }
}
