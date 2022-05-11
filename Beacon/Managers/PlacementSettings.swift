import SwiftUI
import RealityKit
import Combine
import ARKit

struct ModelAnchor {
    var model: Model
    var anchor: ARAnchor?
}

class PlacementSettings: NSObject, ObservableObject {
    @EnvironmentObject var modelsViewModel: ModelsViewModel
    
    @Published var showWarningMessage = false
    @Published var showBrowse: Bool = false
    
    static let shared = PlacementSettings()
    func selectVoiceModelSize(modelVoice: String, size: Int) {
        if modelVoice == "bigduck" {
            let model = Beacon.Model(name: "duck", category: .animal, scaleCompensation: Float(size/100))
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
        if modelVoice == "biggiraffe" {
            let model = Beacon.Model(name: "giraffe", category: .animal, scaleCompensation: Float(size/100))
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
        if modelVoice == "bigelephant" {
            let model = Beacon.Model(name: "elephant", category: .animal, scaleCompensation: Float(size/100))
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
        if modelVoice == "smallduck" {
            let model = Beacon.Model(name: "duck", category: .animal, scaleCompensation: Float(size/100))
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
        if modelVoice == "smallgiraffe" {
            let model = Beacon.Model(name: "giraffe", category: .animal, scaleCompensation: Float(size/100))
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
        if modelVoice == "smallelephant" {
            let model = Beacon.Model(name: "elephant", category: .animal, scaleCompensation: Float(size/100))
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
        if modelVoice == "bigPooEmoji" {
            let model = Beacon.Model(name: "pooEmoji", category: .object, scaleCompensation: Float(size/100))
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
        if modelVoice == "bigflag" {
            let model = Beacon.Model(name: "flag", category: .object, scaleCompensation: Float(size/100))
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
        if modelVoice == "bigrobot" {
            let model = Beacon.Model(name: "robot", category: .object, scaleCompensation: Float(size/100))
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
        if modelVoice == "bigcamera" {
            let model = Beacon.Model(name: "camera", category: .object, scaleCompensation: Float(size/100))
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
        if modelVoice == "smallflag" {
            let model = Beacon.Model(name: "flag", category: .object, scaleCompensation: Float(size/100))
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
        if modelVoice == "smallrobot" {
            let model = Beacon.Model(name: "robot", category: .object, scaleCompensation: Float(size/100))
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
        if modelVoice == "smallcamera" {
            let model = Beacon.Model(name: "camera", category: .object, scaleCompensation: Float(size/100))
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
        if modelVoice == "smallPooEmoji" {
            let model = Beacon.Model(name: "pooEmoji", category: .object, scaleCompensation: Float(size/100))
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
        if modelVoice == "biglocationbeacon" {
            let model = Beacon.Model(name: "locationBeacon", category: .beacon, scaleCompensation: Float(size/100))
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
        if modelVoice == "bigstarbeacon" {
            let model = Beacon.Model(name: "starBeacon", category: .beacon, scaleCompensation: Float(size/100))
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
        if modelVoice == "biginformationbeacon" {
            let model = Beacon.Model(name: "informationBeacon", category: .beacon, scaleCompensation: Float(size/100))
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
        if modelVoice == "bigcollectiblebeacon" {
            let model = Beacon.Model(name: "collectibleBeacon", category: .beacon, scaleCompensation: Float(size/100))
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
        if modelVoice == "smalllocationbeacon" {
            let model = Beacon.Model(name: "locationBeacon", category: .beacon, scaleCompensation: Float(size/100))
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
        if modelVoice == "smallstarbeacon" {
            let model = Beacon.Model(name: "starBeacon", category: .beacon, scaleCompensation: Float(size/100))
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
        if modelVoice == "smallinformationbeacon" {
            let model = Beacon.Model(name: "informationBeacon", category: .beacon, scaleCompensation: Float(size/100))
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
        if modelVoice == "smallcollectiblebeacon" {
            let model = Beacon.Model(name: "collectibleBeacon", category: .beacon, scaleCompensation: Float(size/100))
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
    }
    
    func selectVoiceModel(modelVoice: String) {
        if modelVoice == "duck" {
            let model = Beacon.Model(name: "duck", category: .animal, scaleCompensation: 1000/100)
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
        if modelVoice == "elephant" {
            let model = Beacon.Model(name: "elephant", category: .animal, scaleCompensation: 1000/100)
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
        if modelVoice == "giraffe" {
            let model = Beacon.Model(name: "giraffe", category: .animal, scaleCompensation: 1000/100)
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                    print(model)
                }
            }
        }
        if modelVoice == "flag" {
            let model = Beacon.Model(name: "flag", category: .object, scaleCompensation: 1000/100)
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                }
            }
        }
        if modelVoice == "robot" {
            let model = Beacon.Model(name: "robot", category: .object, scaleCompensation: 1000/100)
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                }
            }
        }
        if modelVoice == "camera" {
            let model = Beacon.Model(name: "camera", category: .object, scaleCompensation: 1000/100)
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                }
            }
        }
        if modelVoice == "pooEmoji" {
            let model = Beacon.Model(name: "pooEmoji", category: .object, scaleCompensation: 1000/100)
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                }
            }
        }
        if modelVoice == "locationBeacon" {
            let model = Beacon.Model(name: "locationBeacon", category: .beacon, scaleCompensation: 1000/100)
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                }
            }
        }
        if modelVoice == "collectibleBeacon" {
            let model = Beacon.Model(name: "collectibleBeacon", category: .beacon, scaleCompensation: 1000/100)
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                }
            }
        };if modelVoice == "informationBeacon" {
            let model = Beacon.Model(name: "informationBeacon", category: .beacon, scaleCompensation: 1000/100)
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    print(modelVoice, "was selected")
                    self.selectedModel = model
                }
            }
        }
        else if modelVoice == "starBeacon" {
            let model = Beacon.Model(name: "starBeacon", category: .beacon, scaleCompensation: 50/100)
            model.asyncLoadModelEntity{ completed, error in
                if completed {
                    self.selectedModel = model
                    print(modelVoice, "was selected")
                }
            }
        }
    }
    
    func browseCommand(_ cmd: String) {
        if cmd == "show browse" {
            showBrowse = true
            print("checkpoint 3333333333")
        }
        if cmd == "hide browse" {
            showBrowse = false
            print("checkpoint 3333333333")
        }
    }
    
    //when user selects in browse view, this is set
    @Published var selectedModel: Model? {
        willSet(newValue) {
            print("Setting selectedModel to \(String(describing: newValue?.name))")
        }
    }
    
    //when user taps confirm in in PlacementView, the value of selectModel is assigned to confirmedModel
    @Published var confirmedModel: Model? {
        willSet(newValue) {
            guard let model = newValue else {
                print("Cleaning confirmedModel")
                return
            }
            print("setting confirmedModel to \(model.name)")

            self.recentlyPlaced.append(model)
        }
    }
    
    //maintain a record of placed objects in scene
    @Published var recentlyPlaced: [Model] = []
    
    @Published var collectedBeacons: Int = 0
    
    //this property retains the cancellable object for our scene subscriber
    var sceneObserver: Cancellable?
    
}


