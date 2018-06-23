//
//  URLRequestExtensions.swift
//  BluebirdChallenge
//
//  Created by Shawn Moore on 6/22/18.
//  Copyright © 2018 Shawn Moore. All rights reserved.
//

import Foundation

// MARK: - URLRequest.Method
extension URLRequest {
    /// The type representing the standard HTTP request methods.
    enum Method: String {
        case get
        case put
        case post
        case delete
        
        var textValue: URLRequest.Method.RawValue {
            return self.rawValue.uppercased()
        }
    }
}

// MARK: URLRequest.Method Convenience Methods
extension URLRequest {
    /// The HTTP request method.
    var method: Method? {
        get {
            guard let method = self.httpMethod else { return nil }
            
            return Method(rawValue: method)
        }
        set {
            self.httpMethod = newValue?.textValue
        }
    }
    
    
    /// Creates and initializes a URL request with the given URL, HTTP request method, and cache policy.
    ///
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - method: The HTTP method for the request.
    ///   - cachePolicy: The cache policy for the request. Defaults to .useProtocolCachePolicy
    ///   - timeoutInterval: The timeout interval for the request. See the commentary for the timeoutInterval for more information on timeout intervals. Defaults to 60.0
    init?(url: URL?, method: Method, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy, timeoutInterval: TimeInterval = 60) {
        guard let url = url else {
            return nil
        }
        
        self.init(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        self.method = method
    }
}
