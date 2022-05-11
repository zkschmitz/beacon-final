import SwiftUI

struct CollectionView: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @EnvironmentObject var arSessionManager: ARSessionManager
    
    var body: some View {
        HStack(alignment: .center){
            ZStack{
                Color.blue
                VStack{
                    Text(String(self.placementSettings.collectedBeacons))
                        .font(.system(size: 25))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .padding(10)
            }
            .frame(width: 64, height: 64)
            .cornerRadius(60.0)
            .transition(.scale)
            .padding(.trailing, 35)
            ZStack{
                Color.black.opacity(0.25)
                VStack{
                    Text("Nearby Beacons")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    Text("\(self.arSessionManager.nearbyBeacons.count)")
                        .font(.system(size: 25))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .padding(10)
            }
            .frame(width: 130, height: 60)
            .cornerRadius(8)
            .transition(.scale)
        }
        
    }
}
