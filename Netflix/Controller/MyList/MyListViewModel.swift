//
//  MyListViewModel.swift
//
//
//

import Foundation
protocol MyListViewModelDelegate: AnyObject {
    func didFetchMovieDetails(details: MovieDetailResponse)
    func fetchMovieDetailsDidFail(error: Error)
}

class MyListViewModel {
    
    weak var delegate: MovieDetailViewModelDelegate?
    var movieDetails: MovieDetailResponse?
    
    func fetchMyListMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        NetworkManager.shared.fetchMovies(endpoint: "movie/upcoming", completion: completion)
    }
}
