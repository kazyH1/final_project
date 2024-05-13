//
//  NetworkMaker.swift
//  Netflix
//
//  Created by Admin on 08/05/2024.
//

import Foundation

enum APIError: Error {
    case failedToGetData
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData<T: Decodable>(from endpoint: String) async throws -> T {
        guard let url = URL(string: "\(Constants.baseURL)/3/\(endpoint)?api_key=\(Constants.APIKey)") else {
            throw APIError.failedToGetData
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw error
        }
    }
    
    func fetchMovies(endpoint: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        Task {
            do {
                let movies: MoviesResponse = try await fetchData(from: endpoint)
                completion(.success(movies.results))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
