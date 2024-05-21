//
//  NewAndHotViewModel.swift
//  Netflix
//
//  Created by HuyNguyen on 17/05/2024.
//

import Foundation

protocol NewAndHotViewModelDelegate: AnyObject {
    func didFetchMovieDetails(details: MovieDetailResponse)
    func fetchMovieDetailsDidFail(error: Error)
}

class NewAndHotViewModel {
    
    weak var delegate: MovieDetailViewModelDelegate?
    var movieDetails: MovieDetailResponse?
    
    func fetchUpComingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        NetworkManager.shared.fetchMovies(endpoint: "movie/upcoming", completion: completion)
    }
}
