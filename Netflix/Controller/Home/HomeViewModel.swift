//
//  HomeViewModel.swift
//  Netflix
//
//  Created by Admin on 29/04/2024.
//

import Foundation

enum APIError: Error {
    case failedToGetData
}

struct Constants {
    static let APIKey = "880d36b683ef35890750f3f86f479f9b"
    static let baseURL = "https://api.themoviedb.org"
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
}


class HomeViewModel {
    static let shared = HomeViewModel()
    
    private init() {}
    
    private func getMovies(for endpoint: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
           Task {
               do {
                   let movies: TrendingMoviesResponse = try await NetworkManager.shared.fetchData(from: endpoint)
                   completion(.success(movies.results))
               } catch {
                   completion(.failure(error))
               }
           }
       }
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        getMovies(for: "trending/movie/day", completion: completion)
    }
    
    func getTrendingTvs(completion: @escaping (Result<[Movie], Error>) -> Void) {
        getMovies(for: "trending/tv/day", completion: completion)
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        getMovies(for: "movie/upcoming", completion: completion)
    }
    
    func getPopular(completion: @escaping (Result<[Movie], Error>) -> Void) {
        getMovies(for: "movie/popular", completion: completion)
    }
    
    func getTopRated(completion: @escaping (Result<[Movie], Error>) -> Void) {
        getMovies(for: "movie/top_rated", completion: completion)
    }
}
