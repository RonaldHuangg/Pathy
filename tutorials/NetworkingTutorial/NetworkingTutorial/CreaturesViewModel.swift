//
//  CreaturesViewModel.swift
//  NetworkingTutorial
//
//  Created by Ronald Huang on 9/18/24.
//

import Foundation

class CreaturesViewModel: ObservableObject {
    
    private struct Returned: Codable {
        var count: Int
        var next: String
        var results: [Result]
    }
    
     struct Result: Codable, Hashable {
        var name: String
        var url: String
    }
    
    
    @Published var urlString = "https://pokeapi.co/api/v2/pokemon/"
    @Published var count = 0
    @Published var creaturesArray: [Result] = []
    
    
    func getData() async {
        print( "We are accessing the url \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("Error: Could not create a URL from \(urlString)")
            return
        }
        
        do {
            let(data, _) = try await URLSession.shared.data(from: url)
            
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("Error: Could not decode return JSON data")
                return
            }
            self.count = returned.count
            self.urlString = returned.next
            self.creaturesArray = returned.results
        } catch {
            print("Error: Could not user URL at \(urlString) to get data and response")
        }
    }
}
