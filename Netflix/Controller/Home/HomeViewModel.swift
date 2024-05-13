//
//  HomeViewModel.swift
//  Netflix
//
//  Created by Admin on 29/04/2024.
//

import Foundation
import FirebaseAuth

class HomeViewModel {

    var logoutAction: (() -> Void)?
    var trendingMoviePosterPathHandler: ((Result<String, Error>) -> Void)?
    
    func getMovies(for category: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        switch category {
        case "trending/movie/day":
            NetworkManager.shared.fetchMovies(endpoint: category, completion: completion)
        case "trending/tv/day":
            NetworkManager.shared.fetchMovies(endpoint: category, completion: completion)
        case "movie/upcoming":
            NetworkManager.shared.fetchMovies(endpoint: category, completion: completion)
        case "movie/popular":
            NetworkManager.shared.fetchMovies(endpoint: category, completion: completion)
        case "movie/top_rated":
            NetworkManager.shared.fetchMovies(endpoint: category, completion: completion)
        default:
            completion(.failure(APIError.failedToGetData))
        }
    }
    
    func fetchTrendingMoviePosterPath(completion: @escaping (Result<[Movie], Error>) -> Void) {
        getMovies(for:  "trending/movie/day") { result in
            switch result {
            case .success(let movies):
                guard !movies.isEmpty else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                let randomIndex = Int.random(in: 0..<movies.count)
                let randomMovie = movies[randomIndex]
                completion(.success([randomMovie]))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func logOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch {
            print("Đăng xuất không thành công: \(error.localizedDescription)")
        }
    }
}

