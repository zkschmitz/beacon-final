import AlanSDK
import SwiftUI



struct BrowseView: View{
//    @Binding var showBrowse: Bool
    @EnvironmentObject var placementSettings: PlacementSettings
    
    var body: some View {
        NavigationView{
            ScrollView(showsIndicators: false){
                //gridview
                RecentsGrid()
                ModelsByCategoryGrid()
            }
            .navigationBarTitle(Text("Beacons"), displayMode: .large)
            .navigationBarItems(trailing:
                Button(action: {
                placementSettings.showBrowse.toggle()
                }) {
                    Text("Done").bold()
            })
        }
    }
    func actionOfButton() {
        placementSettings.showBrowse.toggle()
        print("Control Visibility Toggle Button pressed.")
    }
}

struct RecentsGrid: View {
    @EnvironmentObject var placementSettings: PlacementSettings
//    @Binding var showBrowse: Bool
    
    var body: some View {
        if !self.placementSettings.recentlyPlaced.isEmpty {
            HorizontalGrid(title: "Recents", items: getRecentsUniqueOrdered())
        }
    }
    func getRecentsUniqueOrdered() -> [Model] {
        var recentsUniqueOrderedArray: [Model] = []
        var modelNameSet: Set<String> = []
        
        for model in self.placementSettings.recentlyPlaced.reversed() {
            if !modelNameSet.contains(model.name) {
                recentsUniqueOrderedArray.append(model)
                modelNameSet.insert(model.name)
            }
        }
        
        return recentsUniqueOrderedArray
    }
    
}

struct ModelsByCategoryGrid: View {
    @EnvironmentObject var modelsViewModel: ModelsViewModel
//    @Binding var showBrowse: Bool
    @EnvironmentObject var placementSettings: PlacementSettings
        
    var body: some View {
        VStack {
            ForEach(ModelCategory.allCases, id: \.self) { category in
                
                if let modelsByCategory = self.modelsViewModel.get(category: category) {
                    HorizontalGrid(title: category.label, items: modelsByCategory)
                }
            }
        }
    }
}

struct HorizontalGrid: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @EnvironmentObject var modelsViewModel: ModelsViewModel
//    @Binding var showBrowse: Bool
    var title: String
    var items: [Model]
    
    private let gridItemLayout = [GridItem(.fixed(150))]
    
//    func selectVoiceModel(modelVoice: String) {
//        if modelVoice == "turtle" {
//            let model = Beacon.Model(name: "turtle", category: .animal, scaleCompensation: 10/100)
//            model.asyncLoadModelEntity{ completed, error in
//                if completed {
//                    print("SELF")
//                    self.placementSettings.selectedModel = model
//                    print(model)
//                }
//            }
//        }
//        if modelVoice == "flag" {
//            let model = Beacon.Model(name: "flag", category: .object, scaleCompensation: 10/100)
//            model.asyncLoadModelEntity{ completed, error in
//                if completed {
//                    print("SELF")
//                    self.placementSettings.selectedModel = model
//                    print(model)
//                }
//            }
//        }
//        else if modelVoice == "starBeacon" {
//            let model = Beacon.Model(name: "starBeacon", category: .beacon, scaleCompensation: 50/100)
//            model.asyncLoadModelEntity{ completed, error in
//                if completed {
//                    print("SELF")
//                    self.placementSettings.selectedModel = model
//                    print(model)
//                }
//            }
//        }
//    }

    var body: some View{
        VStack(alignment: .leading){
            Separator()
            
            Text(title)
                .font(.title2).bold()
                .padding(.leading, 22)
                .padding(.top, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows:gridItemLayout, spacing: 30) {
                    ForEach(0..<items.count) { index in
                        
                        let model = items[index]
                        
                        ItemButton(model: model){
                            print("-----------------------------------")
                            print(model)
                            model.asyncLoadModelEntity{ completed, error in
                                if completed {
                                    print("SELF")
                                    self.placementSettings.selectedModel = model
                                    print(model)
                                }
                            }
                            print("browseview: select \(model.name) for placement")
                            self.placementSettings.showBrowse = false
                        }
                    }
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 10)
            }
        }
    }
}


struct ItemButton: View {
    let model: Model
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            self.action()
        }) {
            Image(uiImage: self.model.thumbnail)
                .resizable()
                .frame(height: 150)
                .aspectRatio(1/1, contentMode: .fit)
                .background(Color(UIColor.secondarySystemFill))
                .cornerRadius(8.0)
        }
    }
}

struct Separator: View{
    var body: some View {
        Divider()
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        
    }
}
