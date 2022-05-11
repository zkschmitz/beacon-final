import AlanSDK
import SwiftUI
import CoreLocation
import LocationBasedAR

struct MapContainer: View {
    
    @EnvironmentObject var locationManager: LocationBasedManager
    @EnvironmentObject var mapViewModel: MapViewModel
    //    @EnvironmentObject var arSessionManager: ARSessionManager
    
    var body: some View {
        ZStack {
            MapView()
                .environmentObject(mapViewModel)
                .ignoresSafeArea(.all, edges: .all)
            
            if self.mapViewModel.isMapVisible{
                VStack {
                    HStack {
                        VStack {
                            SystemIconButton(systemIconName: mapViewModel.locationButtonIcon, action: {
                                mapViewModel.changeTrackingMode()
                            }).buttonStyle(MapButtonStyle())
                        }
                        Spacer()
                        
                    }
                    Spacer()
                }
                .padding(.top, 45)
                .padding(.horizontal,20)
            }
        }
        .alert(isPresented: $locationManager.permissionDenied, content: {
            .openSettingsAlert(title: "Persmission Denied", message: "Enable Location Tracking in Settings")
        })
        .alert(isPresented: $locationManager.accuracyDenied, content: {
            .openSettingsAlert(title: "Persmission Denied", message: "Enable Full Accuracy Tracking in Settings")
        })
    }
}

struct MapContainer_Previews: PreviewProvider {
    static var previews: some View {
        MapContainer()
    }
}

struct MapButtonStyle: ButtonStyle {
    var backgroundColor: Color = Color(UIColor.systemBackground)
    var foregroundColor: Color = Color(UIColor.systemBlue)
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(backgroundColor.opacity(0.9))
            .foregroundColor(foregroundColor)
            .clipShape(Circle())
            .compositingGroup()
            .opacity(configuration.isPressed ? 0.75 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct SystemIconButton: View {
    
    let systemIconName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: { self.action() }) {
            Image(systemName: systemIconName)
                .font(.title)
                .padding()
                .frame(width: 50, height: 50)
        }
    }
}
