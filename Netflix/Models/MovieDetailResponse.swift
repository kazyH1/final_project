//
//  MovieDetailResponse.swift
//  Netflix
//
//  Created by Admin on 09/05/2024.
//

import Foundation

struct MovieDetailResponse: Codable {
    let id: Int
    let title: String
    let tagline: String
    let videos: Results
}

struct Results: Codable {
    let results:[Video]
}

struct Video: Codable {
    let name: String
    let key: String
    let type: String
}

