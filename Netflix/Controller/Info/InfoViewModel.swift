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
    
    func fetchMovieDetails(movieId: Int, completion: @escaping (Bool) -> Void) {
        let urlString = "\(Constants.baseURL)/3/movie/\(movieId)?api_key=\(Constants.APIKey)&append_to_response=videos,credits,recommendations"
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching movie details: \(error)")
                completion(false)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(false)
                return
            }

            // Log raw JSON data for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON Response: \(jsonString)")
            }

            do {
                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movieDetails = try decoder.decode(MovieDetailResponse.self, from: data)
                print(movieDetails)
                self.movieDetails = movieDetails
                completion(true)
            } catch {
                print("Error decoding movie details: \(error)")
                completion(false)
            }
        }

        task.resume()
    }

}
