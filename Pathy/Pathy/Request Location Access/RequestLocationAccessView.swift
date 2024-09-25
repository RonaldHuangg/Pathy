//
//  RequestLocationAccessView.swift
//  Pathy
//
//  Created by Ronald Huang on 9/11/24.
//

import SwiftUI

struct RequestLocationAccessView: View {
    @ObservedObject var locationManager: LocationManager
    
    var body: some View {
        Spacer()
        
        Text("Location Access")
            .foregroundColor(Color("Dark"))
            .font(.system(size: 35, weight: .bold))
        
        Image("dogwalk")
            .resizable()
            .scaledToFit()
            .frame(width:370, height: 370)
            
        
        Text("Pathy uses your current location to record the path you take during a walk,run, or ride")
            .foregroundColor(.secondary)
            .padding()
            .multilineTextAlignment(.center)
        
        
            Spacer()
        
        Button {
            locationManager.requestLocationAccess()
        } label: {
            Text("Allow Access")
                .padding()
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(width: 420)
        .padding(.horizontal, -32)
        .background(Color.blue)
        .clipShape(Capsule())
        .padding()

        
    }
}
    
#Preview {
    RequestLocationAccessView(locationManager: LocationManager())
}
    
