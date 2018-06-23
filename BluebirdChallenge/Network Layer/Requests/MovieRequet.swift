//
//  MovieRequet.swift
//  BluebirdChallenge
//
//  Created by Shawn Moore on 6/22/18.
//  Copyright © 2018 Shawn Moore. All rights reserved.
//

import Foundation

enum MovieRequest: NetworkRequest {
    case search(query: String)
    
    var version: String? {
        return "3"
    }
    
    var path: String {
        return "search/movie"
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .search(let query):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "api_key", value: "8b18aa7476c4157d2b675b90d6049c9d")
            ]
        }
    }
}
