//
//  Movie.swift
//  MovieApp
//
//  Created by Thanos on 13/01/20.
//  Copyright © 2020 Thanos. All rights reserved.
//

import Foundation

struct MovieResults: Codable{
    var results: [Movie]?
    var page: Int?
    var totalResults: Int?
    var dates : Dates?
    var totalPages: Int?
    
    
    private enum CodingKeys: String, CodingKey{
        case results = "results"
        case page = "page"
        case totalResults = "total_results"
        case dates = "dates"
        case totalPages = "total_pages"
    }
}


struct Movie: Codable{
    
    var popularity: Double?
    var voteCount: Int?
    var video: Bool?
    var posterPath: String?
    var id: Int?
    var adult: Bool?
    var backdropPath: String?
    var originalLanguage: String?
    var originalTitle: String?
    var genericId:[Int]?
    var title: String?
    var voteAverage:Double?
    var overview: String?
    var releaseDate:String?
    
    private enum CodingKeys: String, CodingKey{
        case popularity = "popularity"
        case voteCount = "vote_count"
        case video = "video"
        case posterPath = "poster_path"
        case id = "id"
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genericId = "genre_ids"
        case title = "title"
        case voteAverage = "vote_average"
        case overview = "overview"
        case releaseDate = "release_date"
    }
}

struct Dates: Codable{
    var maximum: String?
    var minimum: String?
    
    private enum CodingKeys: String, CodingKey{
        case maximum = "maximum"
        case minimum = "minimum"
    }
}
