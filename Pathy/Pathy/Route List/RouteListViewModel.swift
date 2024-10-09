//
//  RouteListViewModel.swift
//  Pathy
//
//  Created by Ronald Huang on 10/3/24.
//

import Foundation

enum RouteListLoadingState {
    case idle
    case loading
    case success(routes: [Route])
    case error(message: String)
}

@MainActor
class RouteListViewModel: ObservableObject {
    @Published var state: RouteListLoadingState = .idle
    
    func fetchAllRoutes() async {
        do {
            // TODO: Set state to loading
            state = .loading
            // TODO: Make a request to RoutesService.fetchAllRoutes()
            let routes = try await RoutesService.fetchAllRoutes()
            // TODO: Sort resulting array based on startTime (descending/newest first)
            let sortedRoutes = routes.sorted(by: { $0.startTime > $1.startTime })
            // TODO: Update state to success
            state = .success(routes: sortedRoutes)
        } catch let error {
            // TODO: Handle the error
            state = .error(message: error.localizedDescription)
        }
    }
    
    func delete(route: Route) async {
        do {
            // TODO: Set state to loading
            state = .loading
            // TODO: Make a request to RoutesService.delete(route:)
            try await RoutesService.delete(route: route)
            // TODO: Call self.fetchAllRoutes() to get the most recent list (post deletion)
            await fetchAllRoutes()
        } catch let error  {
            // TODO: Handle the error
            state = .error(message: error.localizedDescription)
        }
    }
}
