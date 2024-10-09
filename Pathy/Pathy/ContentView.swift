//
//  ContentView.swift
//  Pathy
//
//  Created by Ronald Huang on 9/11/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        Group {
            if locationManager.hasLocationAccess {
                RouteListView()
                    .environmentObject(locationManager)
            } else {
                RequestLocationAccessView(locationManager: LocationManager())
                    .environmentObject(locationManager)
                    
            }
        }

    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
