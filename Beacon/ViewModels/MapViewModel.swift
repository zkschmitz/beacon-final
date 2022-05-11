import SwiftUI
import MapKit
import CoreLocation
import LocationBasedAR


class MapViewModel: NSObject, ObservableObject {
    
    @Published var isMapVisible: Bool = false
    @Published var mapView = MKMapView()
    @Published var userTrackingMode: MKUserTrackingMode = .none
    
    static let shared = MapViewModel()
    // selected location
    @Published var selectedLocation: MapLocation? = nil
    
    // Chosen anchor
    // Added anchors
    @Published var anchors: [LBAnchor] = []
    // Overlays
    
    override init() {
        super.init()
        setupGestures()
    }
    
    func mapCommand(_ cmd: String) {
        if cmd == "show map" {
            isMapVisible = true
            print("checkpoint 3333333333")
        }
        if cmd == "hide map" {
            isMapVisible = false
            print("checkpoint 3333333333")
        }
    }
    
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        mapView.addGestureRecognizer(tap)
    }
    
    var locationButtonIcon: String {
        switch userTrackingMode {
        case .none: return "location"
        case .follow: return "location.fill"
        case .followWithHeading: return "location.north.line.fill"
        default: return "location"
        }
    }
    
    func focusOnUserLocation() {
        if CLLocationManager.locationServicesEnabled() {
            DispatchQueue.main.async {
                self.userTrackingMode = .follow
            }
        }
    }
    
    func focusOnUserNavigation() {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    self.userTrackingMode = .followWithHeading
                }
            }
        }

    
    func changeTrackingMode() {
        switch userTrackingMode {
        case .none: userTrackingMode = .follow
        case .follow: userTrackingMode = .followWithHeading
        case .followWithHeading: userTrackingMode = .none
        default: userTrackingMode = .none
        }
        
        mapView.userTrackingMode = userTrackingMode
    }
    
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        
        // get the tap location
        let tapLocation = recognizer.location(in: mapView)
        
        // convert tap location to real world location
        let coordinate = mapView.convert(tapLocation, toCoordinateFrom: mapView)
        
        // handle addition at specified coordinates
        self.selectedLocation = MapLocation(coordinate: coordinate)
    }
    
    // show anchors on map
    func addAnchors(_ anchors: [LBAnchor]) {
        let incoming = anchors.filter({ !self.anchors.contains($0) })
        self.anchors.append(contentsOf: incoming)
        
        let indicators = self.mapView.overlays.compactMap({ $0 as? AnchorIndicator })
        self.mapView.addOverlays(
            incoming
                .compactMap({ AnchorIndicator(center: $0.coordinate, color: $0.locationEstimation.color)})
                .filter({ !indicators.contains($0) })
        )
    }
    // remove anchors from map
    func removeAnchors(_ anchors: [LBAnchor]) {
        let indicators = self.mapView.overlays.compactMap({ $0 as? AnchorIndicator })
        anchors.forEach { anchor in
            if let index = self.anchors.firstIndex(of: anchor) {
                self.anchors.remove(at: index)
            }
            if let overlay = indicators.first(where: {
                $0.coordinate.latitude == anchor.coordinate.latitude
                    && $0.coordinate.longitude == anchor.coordinate.longitude
                    && $0.color == anchor.locationEstimation.color
            }) {
                DispatchQueue.main.async {
                    self.mapView.removeOverlay(overlay)
                }
            }
        }
    }
}


extension CLLocationCoordinate2D {
    var description: String {
        "lat: \(latitude.format(f: ".8")); lon: \(longitude.format(f: ".8"))"
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}


struct MapLocation: Identifiable {
    let coordinate: CLLocationCoordinate2D
    
    var id: String {
        coordinate.description
    }
    
    var text: String {
        coordinate.description
    }
}
