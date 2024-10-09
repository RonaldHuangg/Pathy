//
//  RouteDetailsView.swift
//  Pathy
//
//  Created by Ronald Huang on 10/9/24.
//

import SwiftUI

struct RouteDetailsView: View {
    @StateObject var vm: RouteDetailsViewModel
    
    init(route: Route) {
            // This is the rather funky syntax needed to initialize a
            // StateObject with parameters. Don't change this. Google
            // "SwiftUI StateObject with parameters" if you're curious
        self._vm = StateObject(wrappedValue: RouteDetailsViewModel(route: route))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // TODO: Implement view
                HStack {
                    Image(systemName: vm.route.type.systemImageName)
                        .resizable()
                        .scaledToFit()
                    
                        .frame(width: 50, height: 50)
                        .background(
                            Circle()
                                .fill(.regularMaterial)
                                .frame(width: 65, height: 65)
                        )
                        .padding(.top)
                        .padding()
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text(vm.route.type.displayName)
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        }
                        .padding(.top)
                        
                        HStack {
                            Text(vm.route.userName)
                                .font(.callout)
                                .fontWeight(.regular)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                }
                
                
                RouteMapView(coordinates: vm.route.coordinates)
                    .allowsHitTesting(true)
                    .frame(height: 200)
                    .frame(width: 370)
                    .cornerRadius(8)
                
                Grid {
                    GridRow {
                        GridView(title: "Duration", value: vm.route.formattedDuration)
                        GridView(title: "Avg Speed", value: vm.route.formattedAverageSpeed)
                    }
                    GridRow {
                        GridView(title: "Total Distance", value: "\(vm.route.formattedDistance) mi")
                        GridView(title: "Net Distance", value: vm.route.formattedNetDistance)
                    }
                }
                .padding()
                
                
                
                
                
                
                
                
                
                VStack(alignment: .leading, spacing: 8) {
                    if let start = vm.start {
                        
                        HStack {
                            Text("Start")
                                .fontWeight(.regular)
                                .padding(.horizontal)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("\(start.streetNumber) \(start.streetName)")
                                .padding(.horizontal)
                                .foregroundColor(.primary)
                            Spacer()
                            Text(vm.route.formattedStartTime)
                                .padding(.horizontal)
                                .foregroundColor(.secondary)
                        }
                        
                    }
                    
                    
                    if let end = vm.end {
                        HStack {
                            Text("End")
                                .fontWeight(.regular)
                                .padding(.horizontal)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("\(end.streetNumber) \(end.streetName)")
                                .padding(.horizontal)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            Text(vm.route.formattedEndTime)
                                .padding(.horizontal)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .padding(.horizontal) // change this
            
            
        }
        // navigation bar modifiers
        .onAppear {
            vm.fetchCheckpoints()
        }
        .navigationTitle(vm.route.formattedDate)
                .navigationBarTitleDisplayMode(.inline)
    }
}

struct GridView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .padding()
        .frame(width: 180, height: 80)
        .background(.regularMaterial)
        .cornerRadius(12)
    }
}



#Preview {
    NavigationStack {
        Text("yo")
            .navigationDestination(isPresented: .constant(true)) {
                RouteDetailsView(route: .bikeExample)
            }
    }
}
