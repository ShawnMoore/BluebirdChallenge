//
//  NetworkRequest.swift
//  BluebirdChallenge
//
//  Created by Shawn Moore on 6/22/18.
//  Copyright © 2018 Shawn Moore. All rights reserved.
//
//  Documentation similar to URLComponents
//

import Foundation

// MARK: - NetworkRequest

protocol NetworkRequest {
    
    // The path subcomponent.
    var path: String { get }
    
    // MARK: Optional Properties
    
    /// A common path subcomponent that a group of requests share. Defaults to empty string.
    var basePath: String { get }
    
    /// Optional version of the network request to append to the path. Defaults to nil.
    var version: String? { get }
    
    /// The HTTP request method. Defaults to .get
    var method: URLRequest.Method { get }
    
    /// An array of query items for the request in the order in which they appear in the original query string. Defaults to empty array.
    var queryItems: [URLQueryItem] { get }
    
    /// A dictionary containing all the parameters sent as the message body of the request. Defaults to nil.
    /// - Warning: Paramaters are required to be JSONEncodable.
    var bodyParameters: [String: Any]? { get }
    
    /// A dictionary containing all the individual HTTP header fields of the request. Defaults to empty dictionary.
    var headers: [String: String] { get }
    
    /// An optional unique identifier of the request. If provided, duplicate requests are prevented. Defaults to nil.
    var identifier: String? { get }
}

// MARK: - Default Properties

extension NetworkRequest {
    var basePath: String {
        return ""
    }
    
    var version: String? {
        return nil
    }
    
    var method: URLRequest.Method {
        return .get
    }
    
    var queryItems: [URLQueryItem] {
        return []
    }
    
    var bodyParameters: [String: Any]? {
        return nil
    }
    
    var headers: [String: String] {
        return [:]
    }
    
    var identifier: String? {
        return nil
    }
}

// MARK: - Network Execution Helpers

extension NetworkRequest {
    func execute(in environment: NetworkEnvironment, with dispatcher: NetworkDispatcher, requireAuthentication: Bool = false, completionQueue: DispatchQueue = .main, completionHandler: @escaping (URLRequest?, Data?, URLResponse?, Error?) -> Void) {
        dispatcher.execute(self, in: environment, completionQueue: completionQueue, completionHandler: completionHandler)
    }
    
    func executeJSON(in environment: NetworkEnvironment, with dispatcher: NetworkDispatcher, requireAuthentication: Bool = false, writingOptions: JSONSerialization.ReadingOptions = .allowFragments, completionQueue: DispatchQueue = .main, completionHandler: @escaping (URLRequest?, Any?, URLResponse?, Error?) -> Void) {
        dispatcher.executeJSON(self, in: environment, writingOptions: writingOptions, completionQueue: completionQueue, completionHandler: completionHandler)
    }
    
    func executeCodable<T>(in environment: NetworkEnvironment, with dispatcher: NetworkDispatcher, requireAuthentication: Bool = false, decoder: JSONDecoder, completionQueue: DispatchQueue = .main, completionHandler: @escaping (URLRequest?, T?, URLResponse?, Error?) -> Void) where T: Decodable {
        dispatcher.executeCodable(self, decoder: decoder, in: environment, completionHandler: completionHandler)
    }
}
