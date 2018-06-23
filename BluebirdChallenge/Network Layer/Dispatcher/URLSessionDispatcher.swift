//
//  URLSessionDispatcher.swift
//  BluebirdChallenge
//
//  Created by Shawn Moore on 6/23/18.
//  Copyright © 2018 Shawn Moore. All rights reserved.
//

import Foundation

class URLSessionDispatcher: NetworkDispatcher {
    // MARK: - Singleton
    static let shared = URLSessionDispatcher()
    
    // MARK: - Properties
    fileprivate var currentRequests: [String: URLSessionDataTask] = [:]
    fileprivate let session: URLSession
    
    let backgroundQueue: DispatchQueue = {
        let bundleIdentifier = Bundle.main.bundleIdentifier
        let defaultIdentifer = "me.shawnmoore.bluebirdChallenge"
        let identifier = (bundleIdentifier ?? defaultIdentifer) + "." + UUID().uuidString
        
        return DispatchQueue(label: identifier, attributes: .concurrent)
    }()
    
    // MARK: - Initialization
    init(timeoutInterval: TimeInterval = 60.0) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInterval
        
        self.session = URLSession(configuration: configuration)
    }
    
    // MARK: - Execution
    func execute(_ request: NetworkRequest, in environment: NetworkEnvironment, completionQueue: DispatchQueue, completionHandler: @escaping (URLRequest?, Data?, URLResponse?, Error?) -> Void) {
        backgroundQueue.async {
            if environment.requiresAuthentication && !self.isAuthenticated {
                completionQueue.async {
                    completionHandler(nil, nil, nil, NetworkingError.noAuthentication)
                }
                
                return
            }
            
            if let identifier = request.identifier, let task = self.currentRequests[identifier], task.state == .running {
                completionQueue.async {
                    completionHandler(nil, nil, nil, NetworkingError.duplicateTask)
                }
                
                return
            }
            
            guard var urlRequest = environment.urlRequest(from: request) else {
                completionQueue.async {
                    completionHandler(nil, nil, nil, NetworkingError.invalidURL)
                    
                    if let identifier = request.identifier {
                        self.currentRequests[identifier] = nil
                    }
                }
                
                return
            }
            
            let setHeaderValuefunction = { (field: String, value: String) in
                urlRequest.setValue(value, forHTTPHeaderField: field)
            }
            
            environment.headers.forEach(setHeaderValuefunction)
            request.headers.forEach(setHeaderValuefunction)
            
            let task = self.session.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    completionQueue.async {
                        completionHandler(urlRequest, data, response, error)
                        
                        if let identifier = request.identifier {
                            self.currentRequests[identifier] = nil
                        }
                    }
                    
                    return
                }
                
                guard let urlResponse = response as? HTTPURLResponse else {
                    completionQueue.async {
                        completionHandler(urlRequest, data, response, NetworkingError.invalidResponse)
                        
                        if let identifier = request.identifier {
                            self.currentRequests[identifier] = nil
                        }
                    }
                    
                    return
                }
                
                guard (200...299).contains(urlResponse.statusCode) else {
                    completionQueue.async {
                        completionHandler(urlRequest, data, urlResponse, NetworkingError.unacceptableStatusCode(urlResponse.statusCode))
                        
                        if let identifier = request.identifier {
                            self.currentRequests[identifier] = nil
                        }
                    }
                    
                    return
                }
                
                completionQueue.async {
                    completionHandler(urlRequest, data, urlResponse, error)
                    
                    if let identifier = request.identifier {
                        self.currentRequests[identifier] = nil
                    }
                }
            }
            
            if let identifier = request.identifier {
                self.currentRequests[identifier] = task
            }
            
            task.resume()
        }
    }
}
