import RealityKit
import ARKit
import FocusEntity
import LocationBasedAR
import AlanSDK
import UIKit
import SwiftUI

class CustomARView: LBARView { //sub class
    var focusEntity: FocusEntity?
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        self.focusEntity = FocusEntity(on: self, focus: .plane)
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FocusEntity {
    var publicLastPosition: float4x4? {
        switch state {
        case .initializing: return nil
        case .tracking(let raycastResult, _): return raycastResult.worldTransform
        }
    }
}

//Setting up voice assistant button
class ViewController: UIViewController {
    
   override func viewDidLoad() {
     super.viewDidLoad()
   }
 }


