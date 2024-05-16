//
//  Movies.swift
//  Netflix
//
//  Created by Admin on 07/05/2024.
//

import Foundation

struct MoviesResponse: Codable {
    let results: [Movie]
    
}

struct Movie: Codable {
    let id: Int?
    let key: String?
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
    
    public static func saveMyListMovie(movies: [Movie]){
            let moviesData = try! JSONEncoder().encode(movies)
            UserDefaults.standard.set(moviesData, forKey: "mylist")
        }

        public static func getMyListMovie() -> [Movie]?{
            let moviesData = UserDefaults.standard.data(forKey: "mylist")
            let movies = try! JSONDecoder().decode([Movie].self, from: moviesData!)
            return movies
        }
    
}




