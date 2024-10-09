//
//  RouteInProgressCardView.swift
//  Pathy
//
//  Created by Ronald Huang on 9/19/24.
//

import SwiftUI

struct RouteInProgressCardView: View {
    @ObservedObject var vm: RouteInProgressViewModel
    let startStopSaveAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            if vm.routeState != .notStarted {
                metadata
            }
            
            startStopButton
        }
        .padding(vm.routeState != .notStarted ? 16 : 0)
        .background(Material.regularMaterial, in: RoundedRectangle(cornerRadius: 32))
    }
    
    @ViewBuilder
    private var metadata: some View {
        VStack(spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                
                VStack(alignment: .leading) {
                    HStack(alignment: .firstTextBaseline) {
                        
                        
                        Text(vm.formattedDistance)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .fontDesign(.rounded)
                            .monospacedDigit()
                            

                        
                        Text("mi")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .fontDesign(.rounded)
                            
                    }
                    
                    
                    
                    
                    
                    Text("Distance")
                        .font(.body)
                        .foregroundColor(.secondary)
                        
                    
                }
                        
                        
                        Spacer()
                
                VStack(alignment: .leading) {
                    HStack {
                        timeElapsed
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .fontDesign(.rounded)
                            .monospacedDigit()
                        
                    }
                    Text("Duration")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                    
                
                    
                
                    
                
            }
        }
    }
    
    @ViewBuilder
    private var timeElapsed: some View {
        Group {
            switch vm.routeState {
            case .notStarted:
                EmptyView()
            case .inProgress(let startTime):
                Text(startTime, style: .timer)
            case .ended(let startTime, let endTime):
                Text(vm.formatDuration(startTime: startTime, endTime: endTime))
            }
        }
        .monospacedDigit()
        .transition(.scale(0, anchor: .trailing).combined(with: .opacity))
    }
    
    @ViewBuilder
    private var startStopButton: some View {
        Button {
            startStopSaveAction()
        } label: {
            let buttonBackground: Color = {
                switch vm.routeState {
                case .notStarted: return .green
                case.inProgress: return .red
                case .ended: return .blue
                }
            }()
            
            let buttonLabel: String = {
                switch vm.routeState {
                case .notStarted: return "Start"
                case .inProgress: return "Stop"
                case .ended: return "Save"
                }
            }()

            
            Text(buttonLabel)
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(buttonBackground, in:.rect(cornerRadius:16))
                .foregroundColor(.white)
                .padding(1)
        }
    }
}

#Preview {
    Group {
        RouteInProgressCardView(vm: RouteInProgressViewModel(), startStopSaveAction: {})
    }
}
