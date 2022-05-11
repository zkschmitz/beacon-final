import SwiftUI
import RealityKit

class ModelDeletionManager: ObservableObject {
    @Published var entitySelectedForDeletion: ModelEntity? = nil {
        willSet(newValue){
            if self.entitySelectedForDeletion == nil, let newlySelectedModelEntity = newValue {
                // selected for deletion and no prior model was selected
                print("selecting a new model for deletion, with no prior selection")
                
                let component = ModelDebugOptionsComponent(visualizationMode: .lightingDiffuse)
                newlySelectedModelEntity.modelDebugOptions = component
            } else if let previouslySelectedModelEntity = self.entitySelectedForDeletion, let newlySelectedModelEntity = newValue {
                // selected new entity for deletion had a prior selection
                print("Selecting new entityselectionfordeletion, had a prior selection")
                
                previouslySelectedModelEntity.modelDebugOptions = nil
                
                let component = ModelDebugOptionsComponent(visualizationMode: .lightingDiffuse)
                newlySelectedModelEntity.modelDebugOptions = component
            } else if newValue == nil {
                //Clearing entity modelselectedfordeletion
                print("Clearling entitySelectedForDeletion")
                self.entitySelectedForDeletion?.modelDebugOptions = nil
            }
        }
    }
}
