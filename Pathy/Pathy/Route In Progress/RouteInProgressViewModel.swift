//
//  SearchViewModel.swift
//  Pathy
//
//  Created by Ronald Huang on 9/11/24.
//

import CoreLocation
import Foundation

enum RouteInProgressLoadingState {
    case idle
    case loading
    case success
    case error(message: String)
}

@MainActor
class RouteInProgressViewModel: ObservableObject {
    @Published var routeState: RouteState = .notStarted
    @Published var locations: [CLLocation] = []
    @Published var routeType: RouteType = .walk
    @Published var loadingState: RouteInProgressLoadingState = .idle
    
    
    
    func addLocationToRoute(location: CLLocation) {
        locations.append(location)
    }

    func startCollectingRoute() {
        let startTime = Date()
        routeState = .inProgress(startTime: startTime)
    }

    func stopCollectingRoute(routeStartTime: Date) {
        let endTime = Date()
        routeState = .ended(startTime: routeStartTime, endTime: endTime)
    }

    var coordinates: [CLLocationCoordinate2D] {
        return locations.map { $0.coordinate }
    }

    var distance: Double {
        guard var previousLocation = locations.first else { return 0 }
        var distanceMeters: Double = 0

        for location in locations.dropFirst() {
            distanceMeters += location.distance(from: previousLocation)
            previousLocation = location
        }

        let distanceMeasurement = Measurement(value: distanceMeters, unit: UnitLength.meters)
        return distanceMeasurement.converted(to: .miles).value
    }

    var formattedDistance: String {
        String(format: "%.2f", distance)
    }

    func formatDuration(startTime: Date, endTime: Date) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: startTime, to: endTime)!
    }
    
    @MainActor
    func saveRoute(startTime: Date, endTime: Date) async {
        // TODO: Update loading state
        // TODO: Use the map function to convert locations to be of type [RoutePoint]
        // TODO: Instantiate a NewRoute using the local and instance variables
        // - You should use your name for userName
        
        self.loadingState = .loading
        let routePoints: [RoutePoint] = self.locations.map { location in
            RoutePoint(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                timestamp: location.timestamp
            )
        }
        
        
        let newRoute = NewRoute(
            userName: "Ronald Huang",
            distance: self.distance,
            startTime: startTime,
            endTime: endTime,
            type: self.routeType,
            routePoints: routePoints
        
        )
        do {
            // TODO: Call service method
            try await RoutesService.create(route: newRoute)
            self.loadingState = .success
        } catch let error {
            // TODO: Handle the error appropriately
            self.loadingState = .error(message: error.localizedDescription)
        }
    }

    
}
