//
//  LocationManager.swift
//  Pathy
//
//  Created by Ronald Huang on 9/11/24.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    @Published var userLocation: CLLocation?
    @Published var hasLocationAccess: Bool = false
    static let shared = LocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func requestLocationAccess() {
        manager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .notDetermined:
                hasLocationAccess = false
                print("DEBUG: NotDetermined")
            case .restricted:
                hasLocationAccess = false
                print("DEBUG: Restricted")
            case .denied:
                hasLocationAccess = false
                print("DEBUG: Denied")
            case .authorizedAlways:
                hasLocationAccess = true
                print("DEBUG: AuthorizedAlways")
            case .authorizedWhenInUse:
                hasLocationAccess = true
                print("DEBUG: AuthorizedWhenInUse")
            case .authorized:
                hasLocationAccess = true
                print("DEBUG: Authorized")
            @unknown default:
                hasLocationAccess = false
                print("DEBUG: Unknown location")
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
        
    }
    
    func startFetchingCurrentLocation() {
            manager.startUpdatingLocation()
        }
}
