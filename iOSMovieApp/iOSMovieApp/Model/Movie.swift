//
//  Movie.swift
//  iOSMovieApp
//
//  Created by GUILLAUME DINYS MONVOISIN on 20/5/19.
//  Copyright © 2019 GUILLAUME DINYS MONVOISIN. All rights reserved.
//

import Foundation

struct MovieList: Codable {
    let page, totalResults, totalPages: Int?
    let results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Result
struct Movie: Codable {
    let voteCount: Int?
    let id: Int
    let video: Bool?
    let voteAverage: Double?
    let title: String
    let popularity: Double?
    let posterPath: String?
    let originalTitle: String?
    let genreIDS: [Int]?
    let backdropPath: String?
    let adult: Bool?
    let overview, releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case voteCount = "vote_count"
        case id, video
        case voteAverage = "vote_average"
        case title, popularity
        case posterPath = "poster_path"
        case originalTitle = "original_title"
        case genreIDS = "genre_ids"
        case backdropPath = "backdrop_path"
        case adult, overview
        case releaseDate = "release_date"
    }
    
    var backdropImageURLMedium: URL?
    var backdropImageURLHigh: URL?
    var backdropImageURLLow: URL?
    
    
    var posterImageURLMedium: URL?
    var posterImageURLHigh: URL?
    var posterImageURLLow: URL?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
        id = try container.decode(Int.self, forKey: .id)
        video = try container.decodeIfPresent(Bool.self, forKey: .video)
        voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        title = try container.decode(String.self, forKey: .title)
        popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        genreIDS = try container.decodeIfPresent([Int].self, forKey: .genreIDS)
        backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        adult = try container.decodeIfPresent(Bool.self, forKey: .adult)
        overview = try container.decodeIfPresent(String.self, forKey: .overview)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        
        if let bdPath = backdropPath{
            backdropImageURLMedium = URL(string: MoviesController.imgBaseString + "w500" + bdPath)
            backdropImageURLHigh = URL(string: MoviesController.imgBaseString + "original" + bdPath)
            backdropImageURLLow = URL(string: MoviesController.imgBaseString + "w45" + bdPath)
        }
        
        if let postPath = posterPath{
            posterImageURLMedium = URL(string: MoviesController.imgBaseString + "w500" + postPath)
            posterImageURLHigh = URL(string: MoviesController.imgBaseString + "original" + postPath)
            posterImageURLLow = URL(string: MoviesController.imgBaseString + "w45" + postPath)
        }
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(posterPath, forKey: .posterPath)
    }
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case ja = "ja"
    case pt = "pt"
    case zh = "zh"
}
