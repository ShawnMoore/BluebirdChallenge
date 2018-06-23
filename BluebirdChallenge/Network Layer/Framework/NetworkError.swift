//
//  NetworkError.swift
//  BluebirdChallenge
//
//  Created by Shawn Moore on 6/22/18.
//  Copyright © 2018 Shawn Moore. All rights reserved.
//

import Foundation

enum NetworkingError: LocalizedError {
    case noAuthentication
    case duplicateTask
    case invalidURL
    case invalidResponse
    case unacceptableStatusCode(Int)
    case missingData
    case missingJSON
}
