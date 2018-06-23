//
//  NetworkDispatcher.swift
//  BluebirdChallenge
//
//  Created by Shawn Moore on 6/22/18.
//  Copyright © 2018 Shawn Moore. All rights reserved.
//

import Foundation

// MARK: - NetworkDispatcher

protocol NetworkDispatcher {
    
    /// The dispatch queue to execute additional requests on
    var backgroundQueue: DispatchQueue { get }
    
    /// Boolean flag to determine if user is authenticated in the system. Defaults to true
    var isAuthenticated: Bool { get }
    
    /// Executes a task that retrieves the contents of a URL based on the request and environment object, and calls a handler upon completion with the raw returned data.
    func execute(_ request: NetworkRequest, in environment: NetworkEnvironment, completionQueue: DispatchQueue, completionHandler: @escaping (URLRequest?, Data?, URLResponse?, Error?) -> Void)
}

// MARK: - Default Properties

extension NetworkDispatcher {
    var isAuthenticated: Bool {
        return true
    }
}

// MARK: - Additional execution methods

extension NetworkDispatcher {
    /// Executes a task that retrieves the contents of a URL based on the request and environment object, and calls a handler upon completion with a Foundation object from returned data.
    func executeJSON(_ request: NetworkRequest, in environment: NetworkEnvironment, writingOptions: JSONSerialization.ReadingOptions = .allowFragments, completionQueue: DispatchQueue = .main, completionHandler: @escaping (URLRequest?, Any?, URLResponse?, Error?) -> Void)  {
        self.execute(request, in: environment, completionQueue: backgroundQueue) { (request, data, response, error) in
            if let error = error {
                completionQueue.async {
                    completionHandler(request, nil, nil, error)
                }
                
                return
            }
            
            guard let data = data else {
                completionQueue.async {
                    completionHandler(nil, nil, nil, NetworkingError.missingData)
                }
                
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: writingOptions)
            
            completionQueue.async {
                completionHandler(request, json, response, error)
            }
        }
    }
    
    /// Executes a task that retrieves the contents of a URL based on the request and environment object, and calls a handler upon completion with a Codable object from returned data.
    func executeCodable<T>(_ request: NetworkRequest, decoder: JSONDecoder, in environment: NetworkEnvironment, completionQueue: DispatchQueue = .main, completionHandler: @escaping (URLRequest?, T?, URLResponse?, Error?) -> Void) where T: Decodable {
        self.execute(request, in: environment, completionQueue: backgroundQueue) { (request, data, response, error) in
            if let error = error {
                completionQueue.async {
                    completionHandler(request, nil, nil, error)
                }
                
                return
            }
            
            guard let data = data else {
                completionQueue.async {
                    completionHandler(nil, nil, nil, NetworkingError.missingData)
                }
                
                return
            }
            
            let object = try? decoder.decode(T.self, from: data)
            
            completionQueue.async {
                completionHandler(request, object, response, error)
            }
        }
    }
}
