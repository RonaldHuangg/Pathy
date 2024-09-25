//
//  ContentView.swift
//  NetworkingTutorial
//
//  Created by Ronald Huang on 9/17/24.
//


import SwiftUI
import SwiftData

struct ContentView: View {
    
       
        @StateObject var creaturesVM = CreaturesViewModel()
        var body: some View {
            NavigationStack {
                List(creaturesVM.creaturesArray, id: \.self) {
                    creature in
                    Text(creature.name)
                        .font(.title2)
                }
                
                .listStyle(.plain)
                .navigationTitle("Pokemon")
            }
            .task {
                await creaturesVM.getData()
            }
        }
    }


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
