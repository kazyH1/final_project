//
//  SearchViewModel.swift
//  Netflix
//
//  Created by Admin on 29/04/2024.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject {
    func didFetchMovieDetails(details: MovieDetailResponse)
    func fetchMovieDetailsDidFail(error: Error)
}

class SearchViewModel {
    
    weak var delegate: MovieDetailViewModelDelegate?
    var movieDetails: MovieDetailResponse?
    
    func fetchSearchMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        NetworkManager.shared.fetchMovies(endpoint: "discover/movie", completion: completion)
    }
    
    func search(with query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        NetworkManager.shared.fetchMovies(endpoint: "search/movie&query=\(query)", completion: completion)
    }
}
