//
//  MovieDetailResponse.swift
//  Netflix
//
//  Created by Admin on 09/05/2024.
//

import Foundation

struct MovieDetailResponse: Codable {
    let id: Int?
    let title: String?
    let tagline: String?
    let overview: String?
    let videos: Results
    let key: String?
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let backdrop_path: String?
    let vote_count: Int?
    let release_date: String?
    let vote_average: Double?
    let genres: [MovieGenre]?
    let credits: CastResponse?
    let recommendations: Recommendation?
    
     var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w300\(poster_path ?? "")")!
    }
    
     var backdropURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdrop_path ?? "")")!
    }
    
    var releaseDate: String {
        return DateTimeConvert.shared.convertDateFormat(inputDate: release_date ?? "2024-05-21", toFormat: Constants.MMMMDDYYYY)
    }
    
    var rating: Double {
        return round((vote_average ?? 0)/2)
    }
    
    var movieCast: [MovieCast] {
        return credits?.cast ?? []
    }
}

struct Results: Codable {
    let results:[Video]
}

struct Video: Codable {
    let id: String
    let key: String
    let name: String
    let site: String
    let size: Int
    let type: String
    var youtubeURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
    var backdropURL: URL {
        return URL(string: "https://img.youtube.com/vi/\(key)/hqdefault.jpg")!
    }
}

