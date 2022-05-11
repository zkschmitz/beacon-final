import SwiftUI
import ARKit
import RealityKit
import Combine
import LocationBasedAR
import Vision

class ARSessionManager: NSObject, ObservableObject {
    
    // MARK: - ARView Properties
    @Published var selectedAnchor: LocationAnchorData? = nil
    @Published var arView: CustomARView = CustomARView(frame: .zero)
    @Published var nearbyBeacons = []
    
    static let shared = ARSessionManager()
    
    var addCallback: (([LBAnchor]) -> Void)?
    var removeCallback: (([LBAnchor]) -> Void)?
    
    var deletionManager: ModelDeletionManager?
    var modelsViewModel: ModelsViewModel?
    var placementSettings: PlacementSettings?
    var sceneManager: SceneManager?
    
    var currentBuffer: CVPixelBuffer?
    let visionQueue = DispatchQueue(label: "arFeedOutput")
    var handPoseRequest = VNDetectHumanHandPoseRequest()
    var frameCounter = 0
    var handPosePredictionInterval = 5
    var prevClassification = ""
    var consecutiveClassifications = 0
    
    var _handPoseClassification: HandPoseClassification!
    var handPoseClassification: HandPoseClassification! {
        get {
            if let model = _handPoseClassification { return model }
            _handPoseClassification = {
                do {
                    let configuration = MLModelConfiguration()
                    return try HandPoseClassification(configuration: configuration)
                } catch {
                    fatalError("Couldn't create HandPoseClassification due to: \(error)")
                }
            }()
            return _handPoseClassification
        }
    }
    
    override init() {
        super.init()
        self.arView.session.delegate = self
        self.arView.delegate = self
        self.arView.locationUpdateFilter = 0.5
        self.initGestures()
        self.startSession()
        
        handPoseRequest.maximumHandCount = 1
        
    }
    
    // MARK: - Session Lifecycle Management
    
    public func startSession() {
        self.run(defaultConfig)
    }
    
    public func stopSession() {
        // ...
        self.arView.session.pause()
    }
    
    public func resetSession() {
        self.arView.removeAll()
        if let config = arView.session.configuration as? ARWorldTrackingConfiguration {
            config.planeDetection = [.horizontal]
            self.run(config, options: [.removeExistingAnchors, .resetTracking])
        } else {
            self.run(defaultConfig, options: [.removeExistingAnchors, .resetTracking])
        }
    }
    
    private var defaultConfig: ARWorldTrackingConfiguration {
        let config = LBARView.defaultConfiguration()
        config.planeDetection = [.horizontal]
        return config
    }
    
    func configure(_ locationProvider: LocationDataProvider) {
        self.arView.locationProvider = locationProvider
        self.arView.startLocationUpdateTimer()
    }
    
    func receive(location update: CLLocation?) {
        if let newLocation = update {
            self.arView.updateLocation(newLocation)
        }
    }
    
    // MARK: - Private Methods & Properties
    
    private func run(_ configuration: ARWorldTrackingConfiguration, options: ARSession.RunOptions = []) {
        self.arView.session.run(configuration, options: options)
    }
    
}
