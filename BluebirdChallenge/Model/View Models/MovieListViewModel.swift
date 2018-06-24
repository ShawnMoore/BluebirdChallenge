//
//  MovieListViewModel.swift
//  BluebirdChallenge
//
//  Created by Shawn Moore on 6/23/18.
//  Copyright © 2018 Shawn Moore. All rights reserved.
//

import Foundation

// MARK: - MovieListViewModelDelegate
protocol MovieListViewModelDelegate: AnyObject {
    func load(error: Error)
    func hasUpdatedMovieList()
}

// MARK: - MovieListViewModel
class MovieListViewModel {
    // MARK: - Properties
    fileprivate(set) let query: String
    
    fileprivate(set) var totalPages: Int = 0
    fileprivate(set) var totalMovies: Int = 0
    fileprivate(set) var movies: [MovieResponse] = []
    fileprivate(set) var retrievedPages: Set<Int> = []
    
    weak var delegate: MovieListViewModelDelegate?
    
    // MARK: - Computed Properties
    var retrievedAllPages: Bool {
        return retrievedPages.count == totalPages
    }
    
    // MARK: - Initializer
    init(with query: String, in environment: NetworkEnvironment = MovieDBEnvironment.movieSearch, with dispatcher: NetworkDispatcher = URLSessionDispatcher.shared) {
        self.query = query
        
        MovieRequest.search(query: query).executeCodable(in: environment, with: dispatcher, decoder: JSONDecoder.Utility.dayOnlyDecoder) { [weak self] (request: URLRequest?, list: MovieListRespone?, response: URLResponse?, error: Error?) in
            
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                strongSelf.delegate?.load(error: error!)
                return
            }
            
            guard let list = list else {
                strongSelf.delegate?.load(error: NetworkingError.missingData)
                return
            }
            
            strongSelf.initData(from: list)
            strongSelf.delegate?.hasUpdatedMovieList()
        }
    }
    
    // MARK: - Public API Functions
}

// MARK: - Fileprivate Helper Functions
fileprivate extension MovieListViewModel {
    func initData(from list: MovieListRespone) {
        self.totalPages = list.totalPages
        self.totalMovies = list.resultCount
        self.movies = list.movies
        self.retrievedPages.insert(list.currentPage)
    }
}
