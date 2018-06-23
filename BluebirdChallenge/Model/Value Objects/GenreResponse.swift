//
//  GenreResponse.swift
//  BluebirdChallenge
//
//  Created by Shawn Moore on 6/23/18.
//  Copyright © 2018 Shawn Moore. All rights reserved.
//

import Foundation

struct GenreListResponse: Codable {
    var genres: [GenreResponse]
}

struct GenreResponse: Codable {
    var id: Int
    var name: String
}
