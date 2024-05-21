//
//  WatchingViewModel.swift
//  Netflix
//
//  Created by HuyNguyen on 14/05/2024.
//

import Foundation
protocol WatchingMovieViewModelDelegate: AnyObject {
    func didFetchMovieDetails(details: MovieDetailResponse)
    func fetchMovieDetailsDidFail(error: Error)
}

class WatchingMovieViewModel {

    weak var delegate: WatchingMovieViewModelDelegate?
    
}
