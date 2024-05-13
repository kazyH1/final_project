//
//  VideoInfo.swift
//  Netflix
//
//
//

import Foundation
import AVFoundation

struct VideoInfo: Codable {
    let items: [Item]
}
// MARK: - Item
struct Item: Codable {
    let snippet: Snippet
    let contentDetails: ContentDetails
}

// MARK: - ContentDetails
struct ContentDetails: Codable {
    let duration: String
}

// MARK: - Snippet
struct Snippet: Codable {
    let description: String
}
