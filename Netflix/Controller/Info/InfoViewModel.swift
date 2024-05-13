//
//  MyListViewModel.swift
//  Netflix
//
//  Created by Admin on 13/05/2024.
//

import Foundation
protocol InfoViewModelDelegate: AnyObject {
    func didFetchMovieDetails(details: MovieDetailResponse)
    func fetchMovieDetailsDidFail(error: Error)
}

class InfoViewModel {
    
    weak var delegate: MovieDetailViewModelDelegate?
    var movieDetails: MovieDetailResponse?
    
    func fetchMyListMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        NetworkManager.shared.fetchMovies(endpoint: "trending/all/day", completion: completion)
    }
}
