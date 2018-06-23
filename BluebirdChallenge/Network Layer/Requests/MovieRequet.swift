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
        return "search/movie​"
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .search(let query):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "api-key", value: "2a61185ef6a27f400fd92820ad9e8537")
            ]
        }
    }
}
