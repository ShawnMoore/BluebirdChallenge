//
//  MovieListResponse.swift
//  BluebirdChallenge
//
//  Created by Shawn Moore on 6/23/18.
//  Copyright © 2018 Shawn Moore. All rights reserved.
//

import Foundation

struct MovieListRespone: Codable {
    var currentPage: Int
    var totalPages: Int
    var resultCount: Int
    var movies: [MovieResponse]
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "page"
        case movies = "results"
        case resultCount = "total_results"
        case totalPages = "total_pages"
    }
}
