//
//  MovieDBEnvironment.swift
//  BluebirdChallenge
//
//  Created by Shawn Moore on 6/22/18.
//  Copyright © 2018 Shawn Moore. All rights reserved.
//

import Foundation

enum MovieDBEnvironment: NetworkEnvironment {
    case movieSearch
    case imageSearch
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        switch self {
        case .movieSearch:
            return "api.themoviedb.org"
        case .imageSearch:
            return "image.tmdb.org"
        }
    }
}
