import SwiftUI
import CoreLocation
import LocationBasedAR


class LocationBasedManager: NSObject, ObservableObject {
    
    private let locationManager = LocationManager()
    
    @Published var permissionDenied = false
    @Published var accuracyDenied = false
    
    // lifecycle callbacks
    var onStart: (() -> Void)?
    var onStop: (() -> Void)?
    
    var onLocationChanged: ((CLLocation) -> Void)?
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
    }
    
    func start() {
        self.locationManager.requestAuthorization()
        self.locationManager.start()
    }
    
    func stop() {
        self.locationManager.stop()
    }
}

extension LocationBasedManager: LocationManagerDelegate {
    func locationManagerDidUpdateLocation(_ location: CLLocation) {
        self.onLocationChanged?(location)
    }
    
    func locationManagerDidUpdateHeading(_ heading: CLLocationDirection, accuracy: CLLocationDirectionAccuracy) {
        
    }
    
    func locationManagerDidStartServices() {
        self.onStart?()
    }
    
    func locationManagerDidStopServices() {
        self.onStop?()
    }
    
    func locationManagerDidChangeAccuracyAuthorization(_ accuracy: CLAccuracyAuthorization) {
        switch accuracy {
        case .fullAccuracy: self.accuracyDenied = false
        case .reducedAccuracy: self.accuracyDenied = true
        @unknown default: ()
        }
    }
    
    func locationManagerDidReceiveRejection() {
        self.permissionDenied.toggle()
    }
}

extension LocationBasedManager: LocationDataProvider {
    public func getCurrentLocation() -> CLLocation? {
        return self.locationManager.getCurrentLocation()
    }
}
