//
//  RouteListItemView.swift
//  Pathy
//
//  Created by Ronald Huang on 10/3/24.
//

import SwiftUI

struct RouteListItemView: View {
    let route: Route
    
    var body: some View {
        // TODO: Change the ZStack to the correct HStacks and VStacks to arrange these view
        // TODO: Apply modifiers to these views to correctly style them
        VStack {
            RouteMapView(coordinates: route.coordinates)
              .allowsHitTesting(false)
              .frame(height: 200)
              .frame(width: 330)
              .cornerRadius(12)
            
            HStack {
                Image(systemName: route.type.systemImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .background(
                        Circle()
                            .fill(.regularMaterial)
                            .frame(width:40, height:40)
                    )
                     
                
                VStack {
                    
                    HStack {
                        Text(route.userName)
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        Spacer()
                        Text("\(route.formattedDistance) mi")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                    }
                
                    HStack {
                        Text(route.formattedDate)
                            .font(.callout)
                            .fontWeight(.regular)
                            .foregroundColor(.secondary)
                            
                        Spacer()
                        Text(route.formattedDuration)
                            .font(.callout)
                            .fontWeight(.regular)
                            .foregroundColor(.secondary)
                    }
                    
                }
            }
        }
    }
}

#Preview {
    List {
        // TODO: Uncomment this to use Previews
         RouteListItemView(route: .walkExample)
    }
}
