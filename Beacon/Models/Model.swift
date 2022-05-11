import SwiftUI
import RealityKit
import Combine



enum ModelCategory: CaseIterable {
    case animal
    case object
    case beacon
    
    var label: String{
        get{
            switch self {
            case .animal:
                return "Animals"
            case .object:
                return "Objects"
            case .beacon:
                return "Beacons"
            }
        }
    }
}

class Model: ObservableObject {
    var name: String
    var category: ModelCategory
    var thumbnail: UIImage
    var modelEntity: ModelEntity?
    var scaleCompensation: Float
    
    private var cancellable: AnyCancellable?
    
    init(name: String, category: ModelCategory, scaleCompensation: Float = 1.0) {
        self.name = name
        self.category = category
        self.thumbnail = UIImage(named: name) ?? UIImage(systemName: "photo")!
        self.scaleCompensation = scaleCompensation
    }
    func asyncLoadModelEntity(handler: @escaping (_ completed: Bool, _ error: Error?) -> Void){
        let filename = self.name + ".usdz"
        
        self.cancellable = ModelEntity.loadModelAsync(named: filename)
            .sink(receiveCompletion: { loadCompletion in
                
                switch loadCompletion {
                case .failure(let error): print("Unable to load entity for \(filename).Error: \(error.localizedDescription)")
                    handler(false, error)
                case .finished:
                    break
                }
                
            }, receiveValue: { modelEntity in
                
                self.modelEntity = modelEntity
                self.modelEntity?.scale *= self.scaleCompensation
                
                handler(true, nil)
                
                print("modelEntity for \(self.name) has been loaded")
            })
    }
}

