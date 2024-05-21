//
//  MovieDetailViewModel.swift
//  Netflix
//
//  Created by Admin on 08/05/2024.
//

import Foundation

protocol MovieDetailViewModelDelegate: AnyObject {
    func didFetchMovieDetails(details: MovieDetailResponse)
    func fetchMovieDetailsDidFail(error: Error)
}

class MovieDetailViewModel {
    
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
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                //print("Data Str: \(String(describing: String(data: data, encoding: .utf8)))")
                let movieDetails = try decoder.decode(MovieDetailResponse.self, from: data)
                
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


