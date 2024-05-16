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
    
    func fetchData<T: Decodable>(from endpoint: String, from query: String?) async throws -> T {
        var querySearch = "";
        if query != nil {
            querySearch = "&query=\(query ?? "")"
        }
        guard let url = URL(string: "\(Constants.baseURL)/3/\(endpoint)?api_key=\(Constants.APIKey)\(querySearch)") else {
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
                let movies: MoviesResponse = try await fetchData(from: endpoint, from: "")
                completion(.success(movies.results))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func searchMovies(endpoint: String, query: String?, completion: @escaping (Result<[Movie], Error>) -> Void) {
        Task {
            do {
                let movies: MoviesResponse = try await fetchData(from: endpoint, from: query)
                completion(.success(movies.results))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

