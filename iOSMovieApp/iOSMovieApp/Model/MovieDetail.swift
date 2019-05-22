//
//  MovieDetail.swift
//  iOSMovieApp
//
//  Created by GUILLAUME DINYS MONVOISIN on 22/5/19.
//  Copyright © 2019 GUILLAUME DINYS MONVOISIN. All rights reserved.
//

import Foundation

// MARK: - Movie
struct MovieDetail: Codable {
    let adult: Bool?
    let backdropPath: String?
    let budget: Int?
    let genres: [Genre]?
    let homepage: String?
    let id: Int?
    let imdbID: String?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let releaseDate: String?
    let revenue, runtime: Int?
    let spokenLanguages: [SpokenLanguage]?
    let status, tagline, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let videos: Videos?
    let credits: Credits?
    let recommendations: Recommendations?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case videos, credits, recommendations
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(posterPath, forKey: .posterPath)
    }
}

// MARK: - Credits
struct Credits: Codable {
    let cast: [Cast]
    let crew: [Crew]
}

// MARK: - Cast
struct Cast: Codable {
    let castID: Int
    let character, creditID: String
    let gender, id: Int
    let name: String
    let order: Int
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case gender, id, name, order
        case profilePath = "profile_path"
    }
}

// MARK: - Crew
struct Crew: Codable {
    let creditID, department: String
    let gender, id: Int
    let job, name: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case creditID = "credit_id"
        case department, gender, id, job, name
        case profilePath = "profile_path"
    }
}

// MARK: - Recommendations
struct Recommendations: Codable {
    let page: Int
    let results: [RecommendationsResult]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - RecommendationsResult
struct RecommendationsResult: Codable {
    let id: Int
    let video: Bool
    let voteCount: Int
    let voteAverage: Double
    let title, releaseDate: String
    let originalTitle: String
    let genreIDS: [Int]
    let backdropPath: String
    let adult: Bool
    let overview, posterPath: String
    let popularity: Double
    
    enum CodingKeys: String, CodingKey {
        case id, video
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case title
        case releaseDate = "release_date"
        case originalTitle = "original_title"
        case genreIDS = "genre_ids"
        case backdropPath = "backdrop_path"
        case adult, overview
        case posterPath = "poster_path"
        case popularity
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int
    let logoPath: String?
    let name, originCountry: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}

// MARK: - Videos
struct Videos: Codable {
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let id: String
    let key, name: String
    let site: Site
    let size: Int
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case key, name, site, size, type
    }
}

enum Site: String, Codable {
    case youTube = "YouTube"
}
