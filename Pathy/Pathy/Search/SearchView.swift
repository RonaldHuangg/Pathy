//
//  SearchView.swift
//  Pathy
//
//  Created by Ronald Huang on 9/11/24.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var locationManager: LocationManager
    var body: some View {
        Button{
            locationManager.startFetchingCurrentLocation()
        } label: {
            Text("Start Tracking Path")
                .padding()
                .foregroundColor(Color(.systemBlue))
        }
        
        if let location = locationManager.userLocation {
            Text("\(location.coordinate.latitude), \(location.coordinate.longitude)")
        }
    }
}

#Preview {
    SearchView(locationManager: LocationManager())
}
