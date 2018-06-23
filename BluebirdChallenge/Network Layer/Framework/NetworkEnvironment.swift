//
//  NetworkEnvironment.swift
//  BluebirdChallenge
//
//  Created by Shawn Moore on 6/22/18.
//  Copyright © 2018 Shawn Moore. All rights reserved.
//
//  Documentation similar to URLComponents
//

import Foundation

// MARK: - NetworkEnvironment

protocol NetworkEnvironment {
    /// The scheme subcomponent of the URL.
    var scheme: String { get }
    
    /// The host subcomponent.
    var host: String { get }
    
    /// A dictionary containing general HTTP header fields for the network environment. Defaults to empty dictionary.
    var headers: [String: String] { get set }
    
    /// Boolean flag declaring if the environment requires authentication.
    var requiresAuthentication: Bool { get }
}

// MARK: - URL Creation

extension NetworkEnvironment {
    func urlComponents(from request: NetworkRequest) -> URLComponents {
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        
        var path: String
        if !request.basePath.isEmpty {
            path = "/" + request.basePath
        } else {
            path = ""
        }
        
        if let version = request.version {
            path += "/" + version
        }
        
        components.path = path + "/" + request.path
        
        components.queryItems = request.queryItems
        
        return components
    }
    
    func urlRequest(from request: NetworkRequest) -> URLRequest? {
        var urlRequest = URLRequest(url: self.urlComponents(from: request).url, method: request.method)
        
        if let bodyParameters = request.bodyParameters, let data = try? JSONSerialization.data(withJSONObject: bodyParameters) {
            urlRequest?.httpBody = data
        }
        
        return urlRequest
    }
}
