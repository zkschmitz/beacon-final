import AlanSDK
import SwiftUI

enum ControlModes: String, CaseIterable {
    case browse
    case scene
}

struct ControlView: View {
    @Binding var selectedControlMode: Int
    //    @Binding var isMapVisible: Bool
    //    @Binding var showBrowse: Bool
    @EnvironmentObject var placementSettings: PlacementSettings
    
    @EnvironmentObject var mapViewModel: MapViewModel
    
    var body: some View {
        VStack {
            ControlVisibilityToggleButton()
            Spacer()
            if !mapViewModel.isMapVisible {
                //                ControlModePicker(selectedControlMode: $selectedControlMode)
                //                ControlButtonBar(showBrowse: placementSettings.showBrowse, selectedControlMode: selectedControlMode)
                ControlButtonBar( selectedControlMode: selectedControlMode)
            }
        }
    }
}

struct ControlVisibilityToggleButton: View {
    //    @Binding var isMapVisible: Bool
    @EnvironmentObject var placementSettings: PlacementSettings
    @EnvironmentObject var modelDeletionManager: ModelDeletionManager
    @EnvironmentObject var arSessionManager: ARSessionManager
    @EnvironmentObject var sceneManager: SceneManager
    @EnvironmentObject var modelsViewModel: ModelsViewModel
    @EnvironmentObject var mapViewModel: MapViewModel
    
    var body: some View{
        HStack {
            Spacer()
            
            ZStack{
                
                Button(action: {
                    print("Control Visibility Toggle Button pressed.")
                    self.mapViewModel.isMapVisible.toggle()
                }) {
                    if !self.mapViewModel.isMapVisible {
                        MapContainer()
                            .clipShape(Circle())
                            .frame(width: 75, height: 75)
                            .onAppear(perform: {
                                let anchors = arSessionManager.arView.getAnchors().compactMap { $0.anchor }
                                mapViewModel.addAnchors(anchors)
                                
                                self.mapViewModel.focusOnUserNavigation()
                            })
                    } else {
                        ARViewContainer()
                            .clipShape(Circle())
                            .frame(width: 75, height: 75)
                            .onAppear(perform: {
                                arSessionManager.deletionManager = modelDeletionManager
                                arSessionManager.modelsViewModel = modelsViewModel
                                arSessionManager.placementSettings = placementSettings
                                arSessionManager.sceneManager = sceneManager
                            })
                    }
                }
                
            }
        }
        .padding(.top, 45)
        .padding(.trailing, 20)
    }
    func actionOfButton() {
        mapViewModel.isMapVisible.toggle()
        print("Control Visibility Toggle Button pressed.")
    }
}

struct ControlModePicker: View {
    @Binding var selectedControlMode: Int
    let controlModes = ControlModes.allCases
    
    init(selectedControlMode: Binding<Int>){
        self._selectedControlMode = selectedControlMode
        
        UISegmentedControl.appearance().selectedSegmentTintColor = .clear
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(displayP3Red: 1.0, green: 0.827, blue: 0, alpha: 1)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        UISegmentedControl.appearance().backgroundColor = UIColor(Color.black.opacity(0.25))
    }
    
    var body: some View {
        Picker(selection: $selectedControlMode, label: Text("Select a Control Mode")) {
            ForEach(0..<controlModes.count){ index in
                Text(self.controlModes[index].rawValue.uppercased()).tag(index)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .frame(maxWidth: 400)
        .padding(.horizontal, 10)
    }
}

struct ControlButtonBar: View {
    //    @Binding var showBrowse: Bool
    var selectedControlMode: Int
    
    @EnvironmentObject var placementSettings: PlacementSettings
    
    var body: some View {
        HStack {
            if selectedControlMode == 1 {
                SceneButtons()
            }
            else {
                BrowseButtons()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(40)
        //        .background(Color.black.opacity(0.25))
    }
}

struct BrowseButtons: View{
    @EnvironmentObject var placementSettings: PlacementSettings
    //    @Binding var showBrowse: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            
            //MostRecentlyPlaced
            MostRecentlyPlacedButton().hidden(self.placementSettings.recentlyPlaced.isEmpty )
                .padding(.bottom, 10)
            
            //Browse
            AddButton(systemIconName: "plus.viewfinder") {
                print("Browse button pressed.")
                placementSettings.showBrowse.toggle()
            }.sheet(isPresented: $placementSettings.showBrowse, content: {
                //Browse View
                BrowseView()
                //                    .environmentObject(placementSettings)
            })
            
            //Settings
            //            ControlButton(systemIconName: "slider.horizontal.3") {
            //                print("Settings button pressed.")
            //            }
            
        }
    }
}

struct SceneButtons: View{
    @EnvironmentObject var sceneManager: SceneManager
    
    var body: some View{
        ControlButton(systemIconName: "icloud.and.arrow.up"){
            print("save scene button pressed")
            self.sceneManager.shouldSaveSceneToFileSystem = true
        }
        .hidden(!self.sceneManager.isPersistenceAvailable)
        Spacer()
        ControlButton(systemIconName: "icloud.and.arrow.down"){
            print("load scene button pressed")
            self.sceneManager.shouldLoadSceneFromFileSystem = true
        }
        .hidden(self.sceneManager.scenePersistenceData == nil)
        Spacer()
        ControlButton(systemIconName: "cart.fill.badge.plus"){
            print("clear scene button pressed")
            for anchorEntity in self.sceneManager.anchorEntities {
                print("Removing anchorentity with id: \(String(describing: anchorEntity.anchorIdentifier))")
                anchorEntity.removeFromParent()
            }
        }
    }
}

struct ControlButton: View {
    let systemIconName: String
    let action: () -> Void
    
    var body: some View {
        
        Button(action: {
            self.action()
        }) {
            Image(systemName: systemIconName)
            //                .font(.system(size:35))
                .foregroundColor(.white)
        }
        .frame(width: 60, height: 60)
        //        .background(
        //            LinearGradient(gradient: Gradient(colors: [Color("LightBlue-2"), Color("DarkBlue-2")]), startPoint: .leading, endPoint: .trailing)
        //            )
        .background(Color.blue)
        .cornerRadius(60)
    }
}

struct AddButton: View {
    let systemIconName: String
    let action: () -> Void
    
    var body: some View {
        
        Button(action: {
            self.action()
        }) {
            Image(systemName: systemIconName)
                .font(.system(size:35))
                .foregroundColor(.white)
        }
        .frame(width: 60, height: 60)
        .background(Color.blue)
        .cornerRadius(60)
    }
}

struct MostRecentlyPlacedButton: View{
    @EnvironmentObject var placementSettings: PlacementSettings
    
    
    var body: some View {
        Button(action: {
            print("most recently placed button pressed")
            self.placementSettings.selectedModel = self.placementSettings.recentlyPlaced.last
        }) {
            if let mostRecentlyPlacedModel = self.placementSettings.recentlyPlaced.last {
                Image(uiImage: mostRecentlyPlacedModel.thumbnail)
                    .resizable()
                    .frame(width: 60)
                    .aspectRatio(1/1, contentMode: .fit)
            } else {
                Image(systemName: "clock.fill")
                    .font(.system(size: 35))
                    .foregroundColor(.white)
                    .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(width: 60, height: 60)
        .background(Color.white)
        .cornerRadius(60.0)
        
    }
}
