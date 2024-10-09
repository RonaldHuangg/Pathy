//
//  RoutesService.swift
//  Pathy
//
//  Created by Ronald Huang on 10/8/24.
//

import Foundation

struct RoutesService {
    static let baseURL = "https://learning.appteamcarolina.com/pathy/routes"
    
    
    static func fetchAllRoutes() async throws -> [Route] {
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            }
            let routes = try decoder.decode([Route].self, from: data)
            return routes
        } catch let error {
            print("Error fetching routes: \(error.localizedDescription)")
            throw error
        }
    }
    
    
    
    
    static func create(route newRoute: NewRoute) async throws {
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            request.httpBody = try encoder.encode(newRoute)
        } catch {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("Error creating route: \(errorMessage)")
            throw URLError(.badServerResponse, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
        
        print("Route created successfully: \(String(data: data, encoding: .utf8) ?? "No response body")")
    }
        
        static func delete(route: Route) async throws {
            // TODO: Make a DELETE request to https://learning.appteamcarolina.com/pathy/routes/\(route_id) (see API docs in Notion)
            // - You should use URL, URLRequest, and URLSession
            // - This method will be very simple and few lines of code
            
            guard let url = URL(string: "\(baseURL)/\(route.id)") else {
                throw URLError(.badURL)
            }
            var request = URLRequest(url: url)
                    request.httpMethod = "DELETE"
            let (_, response) = try await URLSession.shared.data(for: request)
        }
    }
