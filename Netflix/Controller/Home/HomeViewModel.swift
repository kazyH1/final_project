//
//  HomeViewModel.swift
//  Netflix
//
//  Created by Admin on 29/04/2024.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class HomeViewModel {
    
    private let networkManager: NetworkManager
    private let database = Database.database().reference()
    var logoutAction: (() -> Void)?
    var trendingMoviePosterPathHandler: ((Result<String, Error>) -> Void)?
    
    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func getMovies(for category: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        switch category {
        case "trending/movie/day":
            networkManager.fetchMovies(endpoint: category, completion: completion)
        case "trending/tv/day":
            networkManager.fetchMovies(endpoint: category, completion: completion)
        case "movie/upcoming":
            networkManager.fetchMovies(endpoint: category, completion: completion)
        case "movie/popular":
            networkManager.fetchMovies(endpoint: category, completion: completion)
        case "movie/top_rated":
            networkManager.fetchMovies(endpoint: category, completion: completion)
        default:
            completion(.failure(APIError.failedToGetData))
        }
    }
    
    func fetchTrendingMoviePosterPath(completion: @escaping (Result<String, Error>) -> Void) {
        getMovies(for: "trending/movie/day") { result in
            switch result {
            case .success(let movies):
                guard !movies.isEmpty else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                let randomIndex = Int.random(in: 0..<movies.count)
                let randomMovie = movies[randomIndex]
                guard let posterPath = randomMovie.poster_path else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                completion(.success(posterPath))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    private func getRandomTrendingMovieIndex(movies: [Movie]) -> Int {
        return Int.random(in: 0..<movies.count)
    }

    func logOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            if (firebaseAuth.currentUser?.uid) != nil {
                database.child("users").child("uid1").child("loggedIn").setValue(false)
            }
        } catch {
            print("Đăng xuất không thành công: \(error.localizedDescription)")
        }
    }
}

