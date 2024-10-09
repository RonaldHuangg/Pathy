//
//  RouteListView.swift
//  Pathy
//
//  Created by Ronald Huang on 10/3/24.
//

import SwiftUI

struct RouteListView: View {
    @StateObject private var vm = RouteListViewModel()
    @State private var showingRouteInProgressScreen = false
    
    var body: some View {
        NavigationStack {
            List {
                // TODO: Switch over vm.state and show the correct view
                // - Idle: idleView
                // - Loading: loadingView
                // - Success: routesView(routes:)
                // - Error: ErrorView(message:)
                
                switch vm.state {
                case .idle:
                    idleView
                case .loading:
                    loadingView
                case .success(let routes):
                    routesView(routes: routes)
                case .error(let message):
                    errorView(message: message)
                }
            }
            // TODO: Set the navigation title
            .navigationTitle("Routes")
            .navigationBarTitleDisplayMode(.inline)
            // TODO: Use .listRowSpacing(...) to add space between the list rows
            .listRowSpacing(16)
            .toolbar {
                // TODO: Place the button in the navigation bar to toggle showingRouteInProgressScreen
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingRouteInProgressScreen = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .fullScreenCover(isPresented: $showingRouteInProgressScreen) {
                    // TODO: Call vm.fetchAllRoutes
                    // - Context: This is the onDismiss closure passed to fullScreenCover. It's
                    //   called when the sheet is dismissed
                    Task {
                        await vm.fetchAllRoutes()
                    }
                    } content: {
                        // TODO: Show RouteInProgressView as the fullScreenCover's content
                        RouteInProgressView()
                    }
                    .refreshable {
                        // TODO: Call vm.fetchAllRoutes
                        // - Hint: Do you need a Task block here? 🤔
                        await vm.fetchAllRoutes()
                    }
                    .task {
                        // TODO: Call vm.fetchAllRoutes
                        // - Hint: Do you need a Task block here? 🤔
                        await vm.fetchAllRoutes()
                        
                    }
                }
            }
        
            
            @ViewBuilder
            private var idleView: some View {
                ContentUnavailableView("Pull down to make a request", systemImage: "map.circle")
            }
            
            @ViewBuilder
            private var loadingView: some View {
                ContentUnavailableView("Loading...", systemImage: "arrow.triangle.2.circlepath")
            }
            
            @ViewBuilder
            private func routesView(routes: [Route]) -> some View {
                if routes.isEmpty {
                    ContentUnavailableView("There are no routes to display", systemImage: "mappin.slash.circle")
                } else {
                    // TODO: Display a RouteListItemView for every route
                    // TODO: Use .listRowInsets(...) inside your ForEach to set the insets correctly (see Figma to figure out correct value. hint: look for multiple of 4)
                    // TODO: Use .swipeActions(...) inside your ForEach to implement swipe to delete
                    
                    ForEach(routes) { route in
                        ZStack {
                            RouteListItemView(route: route)
                            NavigationLink(destination: RouteDetailsView(route: route)) {
                                                EmptyView()
                                            }
                            .opacity(0)
                        }
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .swipeActions {
                                Button(role: .destructive) {
                                    Task {
                                        // TODO: Call vm.delete(route:)
                                        await vm.delete(route: route)
                                    }
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(.red)
                            }
                        
                    }
                }
            }
                
                @ViewBuilder
                private func errorView(message: String) -> some View {
                    ContentUnavailableView(message, systemImage: "exclamationmark.circle")
                }
            }
        




#Preview {
    RouteListView()
}
