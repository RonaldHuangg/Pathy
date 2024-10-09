//
//  SearchView.swift
//  Pathy
//
//  Created by Ronald Huang on 9/11/24.
//

import SwiftUI

struct RouteInProgressView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var vm = RouteInProgressViewModel()
    @EnvironmentObject var locationManager: LocationManager
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            RouteMapView(coordinates: vm.coordinates)
                .ignoresSafeArea()
            
            RouteInProgressCardView(vm: vm, startStopSaveAction: startStopSaveAction)
                .padding(.horizontal, 16)
        }
        .onChange(of: locationManager.userLocation, initial: true) { oldValue, newValue in
            withAnimation(.bouncy) {
                if let newLocation = newValue {
                    vm.addLocationToRoute(location: newLocation)
                }
            }
        }
        .overlay(alignment: .center) {
            RouteInProgressLoadingStateView(state: vm.loadingState)
        }
        .overlay(alignment: .topLeading) {
            Menu {
                Picker("Route Type", selection: $vm.routeType) {
                    ForEach(RouteType.allCases, id: \.rawValue) { type in
                        Label(type.rawValue.capitalized, systemImage: type.systemImageName)
                            .tag(type)
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: vm.routeType.systemImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Image(systemName: "chevron.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 8, height: 8)
                }
                .padding(10)
                .background(.ultraThickMaterial, in: .rect(cornerRadius: 8))
            }
            .padding(.leading, 16)
        }
        .overlay(alignment: .topTrailing) {
            Button {
                cancel()
            } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .fontWeight(.semibold)
                        .padding(12)
                        .background(.ultraThickMaterial, in: .circle)
            }
            .padding(.trailing, 16)
        }
    }
    
    private func startStopSaveAction() {
        withAnimation(.bouncy) {
            switch vm.routeState {
            case .notStarted:
                locationManager.startFetchingCurrentLocation()
                vm.startCollectingRoute()
                
            case .inProgress(let startTime):
                locationManager.stopFetchingCurrentLocation()
                vm.stopCollectingRoute(routeStartTime: startTime)
                
            case .ended(let startTime, let endTime):
                Task {
                    // TODO: Call vm.saveRoute
                    await vm.saveRoute(startTime: startTime, endTime: endTime)
                    if case .success = vm.loadingState {
                        // TODO: Call dismiss from the environment if request was successful
                        dismiss()
                    }
                }
            }
        }
    }
    
    func cancel() {
            // TODO: Tell location manager to stop location updates
            // TODO: Call dismiss from the enviroment (you'll need to add that at the very top of this struct)
        locationManager.stopFetchingCurrentLocation()
        dismiss()
    }
}

#Preview {
    RouteInProgressView()
            .environmentObject(LocationManager())
}
