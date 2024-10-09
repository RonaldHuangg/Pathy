//
//  RouteDetailsViewModel.swift
//  Pathy
//
//  Created by Ronald Huang on 10/9/24.
//

import Foundation
import CoreLocation

struct RouteDetailsCheckpoint {
    let time: String
    let streetNumber: String
    let streetName: String
}

@MainActor
class RouteDetailsViewModel: ObservableObject {
    let route: Route
    private let geocoder = CLGeocoder()
    @Published var start: RouteDetailsCheckpoint?
    @Published var end: RouteDetailsCheckpoint?
    
    init(route: Route) {
        self.route = route
    }
    
    func fetchCheckpoints() {
        // TODO: Calculate beginning and end checkpoints from self.route
        guard let startPoint = route.routePoints.first, let endPoint = route.routePoints.last else {
            print("Failed to get startPoint or endPoint")
            return
                }
        
        
        buildCheckpoint(for: startPoint) { [weak self] checkpoint in
            DispatchQueue.main.async {
                self?.start = checkpoint
            }
        }
        
        // Delays the Request for startPoint and endPoint to deal with rate limits
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.buildCheckpoint(for: endPoint) { [weak self] checkpoint in
                DispatchQueue.main.async {
                    self?.end = checkpoint
                }
            }
        }
            
            buildCheckpoint(for: endPoint) { [weak self] checkpoint in
                       DispatchQueue.main.async {
                           self?.end = checkpoint
                       }
                   }
    }
    
        private func buildCheckpoint(for point: RoutePoint, completion: @escaping (RouteDetailsCheckpoint?) -> Void) {
            // TODO: Use CoreLocation's reverse geocoding API to find the address
            // - call completion with a value if successful, call completion with nil if anything goes wrong
            let location = CLLocation(latitude: point.latitude, longitude: point.longitude)
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                guard error == nil, let placemark = placemarks?.first else {
                    completion(nil)
                    return
                }
                
                let streetNumber = placemark.subThoroughfare ?? ""
                let streetName = placemark.thoroughfare ?? ""
                
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                let time = formatter.string(from: point.timestamp)
                
                let checkpoint = RouteDetailsCheckpoint(time: time, streetNumber: streetNumber, streetName: streetName)
                completion(checkpoint)
            }
        }
    }
