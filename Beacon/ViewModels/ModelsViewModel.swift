import Foundation

class ModelsViewModel: ObservableObject {
    @Published var models: [Model] = []
    
    init() {
        //animals
        let duck = Model(name: "duck", category: .animal, scaleCompensation: 1000/100)
        let elephant = Model(name: "elephant", category: .animal, scaleCompensation: 1000/100)
        let giraffe = Model(name: "giraffe", category: .animal, scaleCompensation: 1000/100)
        self.models += [elephant,duck, giraffe]
        //objects
        let flag = Model(name: "flag", category: .object, scaleCompensation: 500/100)
        let robot = Model(name: "robot", category: .object, scaleCompensation: 1000/100)
        let camera = Model(name: "camera", category: .object, scaleCompensation: 1000/100)
        let pooEmoji = Model(name: "pooEmoji", category: .object, scaleCompensation: 1500/100)
        
        self.models += [flag, robot, camera, pooEmoji]
        //beacons
        let starBeacon = Model(name: "starBeacon", category: .beacon, scaleCompensation: 50/100)
        let informationBeacon = Model(name: "informationBeacon", category: .beacon, scaleCompensation: 100/100)
        let collectibleBeacon = Model(name: "collectibleBeacon", category: .beacon, scaleCompensation: 100/100)
        let locationBeacon = Model(name: "locationBeacon", category: .beacon, scaleCompensation: 100/100)
        self.models += [starBeacon, informationBeacon, locationBeacon, collectibleBeacon]
    }
    
    func get(category: ModelCategory) -> [Model] {
        return models.filter( {$0.category == category})
    }
    
    func clearModelEntitiesFromMemory() {
        for model in models {
            model.modelEntity = nil
        }
    }
    
}
