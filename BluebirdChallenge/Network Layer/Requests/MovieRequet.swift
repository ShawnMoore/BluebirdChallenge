//
//  MovieRequet.swift
//  BluebirdChallenge
//
//  Created by Shawn Moore on 6/22/18.
//  Copyright © 2018 Shawn Moore. All rights reserved.
//

import Foundation

enum MovieRequest: NetworkRequest {
    case search(query: String, page: Int)
    case genre
    
    var version: String? {
        return "3"
    }
    
    var path: String {
        let initial: String
        
        switch self {
        case .search(_):
            initial = "search"
        default:
            initial = "genre"
        }
        
        return initial + "/movie"
    }
    
    var queryItems: [URLQueryItem] {
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: "8b18aa7476c4157d2b675b90d6049c9d")
        
        switch self {
        case .search(let query, let page):
            return [ URLQueryItem(name: "query", value: query),
                     apiKeyQueryItem,
                     URLQueryItem(name: "page", value: String(page))
                   ]
        case .genre:
            return [ apiKeyQueryItem ]
        }
    }
}
