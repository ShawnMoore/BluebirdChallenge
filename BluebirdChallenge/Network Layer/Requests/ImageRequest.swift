//
//  ImageRequest.swift
//  BluebirdChallenge
//
//  Created by Shawn Moore on 6/22/18.
//  Copyright © 2018 Shawn Moore. All rights reserved.
//

import Foundation

enum ImageRequest: NetworkRequest {
    case retrieveImage(path: String)
    
    var path: String {
        switch self {
        case .retrieveImage(let path):
            return "t/p/w600_and_h900_bestv2/" + path
        }
    }
    
    var identifier: String? {
        switch self {
        case .retrieveImage(let path):
            return "ImageRequest." + path
        }
    }
}
