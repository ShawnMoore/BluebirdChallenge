//
//  MovieResponse.swift
//  BluebirdChallenge
//
//  Created by Shawn Moore on 6/23/18.
//  Copyright © 2018 Shawn Moore. All rights reserved.
//

import Foundation

struct MovieResponse: Codable {
    var id: Int
    var title: String
    var originalTitle: String
    var originalLanguage: String
    var posterPath: String?
    var adultMovie: Bool = false
    var overview: String
    var releaseDate: Date
    var genreIDs: [Int]
    var backdropPath: String?
    var video: Bool = true
    var popularity: Double
    var voteCount: Int
    var voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case adultMovie = "adult"
        case overview
        case releaseDate = "release_date"
        case genreIDs = "genre_ids"
        case id
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case title
        case backdropPath = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
    }
}
