//
//  Movie.swift
//  iOSMovieApp
//
//  Created by GUILLAUME DINYS MONVOISIN on 20/5/19.
//  Copyright © 2019 GUILLAUME DINYS MONVOISIN. All rights reserved.
//

import Foundation

struct MovieList: Codable {
    let page, totalResults, totalPages: Int
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
    let voteCount, id: Int
    let video: Bool
    let voteAverage: Double
    let title: String
    let popularity: Double
    let posterPath: String
    let originalLanguage: OriginalLanguage
    let originalTitle: String
    let genreIDS: [Int]
    let backdropPath: String
    let adult: Bool
    let overview, releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case voteCount = "vote_count"
        case id, video
        case voteAverage = "vote_average"
        case title, popularity
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
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
        voteCount = try container.decode(Int.self, forKey: .voteCount)
        id = try container.decode(Int.self, forKey: .id)
        video = try container.decode(Bool.self, forKey: .video)
        voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        title = try container.decode(String.self, forKey: .title)
        popularity = try container.decode(Double.self, forKey: .popularity)
        posterPath = try container.decode(String.self, forKey: .posterPath)
        originalLanguage = try container.decode(OriginalLanguage.self, forKey: .originalLanguage)
        originalTitle = try container.decode(String.self, forKey: .originalTitle)
        genreIDS = try container.decode([Int].self, forKey: .genreIDS)
        backdropPath = try container.decode(String.self, forKey: .backdropPath)
        adult = try container.decode(Bool.self, forKey: .adult)
        overview = try container.decode(String.self, forKey: .overview)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        
        backdropImageURLMedium = URL(string: MoviesController.imgBaseString + "w500" + backdropPath)
        backdropImageURLHigh = URL(string: MoviesController.imgBaseString + "original" + backdropPath)
        backdropImageURLLow = URL(string: MoviesController.imgBaseString + "w45" + backdropPath)
        
        posterImageURLMedium = URL(string: MoviesController.imgBaseString + "w500" + posterPath)
        posterImageURLHigh = URL(string: MoviesController.imgBaseString + "original" + posterPath)
        posterImageURLLow = URL(string: MoviesController.imgBaseString + "w45" + posterPath)
    }
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case ja = "ja"
    case pt = "pt"
    case zh = "zh"
}
