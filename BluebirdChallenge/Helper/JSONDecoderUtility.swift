//
//  JSONDecoderUtility.swift
//  BluebirdChallenge
//
//  Created by Shawn Moore on 6/23/18.
//  Copyright © 2018 Shawn Moore. All rights reserved.
//

import Foundation

extension JSONDecoder {
    struct Utility { 
        static let dayOnlyDecoder: JSONDecoder = {
            let decoder = JSONDecoder()
            
            decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                let text = try decoder.singleValueContainer().decode(String.self)
                return DateFormatter.Utility.dayOnlyFormatter.date(from: text) ?? Date()
            })
            
            return decoder
        }()
    }
}
