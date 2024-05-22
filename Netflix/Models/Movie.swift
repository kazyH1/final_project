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

public struct Recommendation: Codable {
    let page: Int
    let total_results: Int?
    let total_pages: Int?
    let results: [Movie]
}

public struct MovieGenre: Codable {
    let name: String
}

public struct CastResponse: Codable {
    let cast: [MovieCast]
}

public struct MovieCast: Codable {
    let name: String
    let character: String
    let profile_path: String?
    var profileURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w300\(profile_path ?? "")")!
    }
}

struct Movie: Codable {
    let id: Int?
    let key: String?
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let backdrop_path: String?
    let overview: String?
    let vote_count: Int?
    let release_date: String?
    let vote_average: Double?
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w300\(poster_path ?? "")")!
    }
    
    var backdropURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdrop_path ?? "")")!
    }
    
    
    static func saveMyListMovie(movies: [Movie]){
        let moviesData = try! JSONEncoder().encode(movies)
        UserDefaults.standard.set(moviesData, forKey: "mylist")
    }
    
    static func getMyListMovie() -> [Movie]?{
        let moviesData = UserDefaults.standard.data(forKey: "mylist")
        if(moviesData == nil){
            return []
        } else {
            let movies = try! JSONDecoder().decode([Movie].self, from: moviesData!)
            return movies
        }
    }
}
