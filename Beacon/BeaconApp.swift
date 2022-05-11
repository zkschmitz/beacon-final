import SwiftUI

@main
struct BeaconApp: App {
    @StateObject var placementSettings = PlacementSettings.shared
    @StateObject var sceneManager = SceneManager()
    @StateObject var modelsViewModel = ModelsViewModel()
    @StateObject var modelDeletionManager = ModelDeletionManager()
    @StateObject var locationManager = LocationBasedManager()
    @StateObject var mapViewModel = MapViewModel.shared
    @StateObject var arSessionManager = ARSessionManager.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                ContentView()
                    .environmentObject(placementSettings)
                    .environmentObject(sceneManager)
                    .environmentObject(modelsViewModel)
                    .environmentObject(modelDeletionManager)
                    .environmentObject(locationManager)
                    .environmentObject(mapViewModel)
                    .environmentObject(arSessionManager)
            }
        }
    }
}


