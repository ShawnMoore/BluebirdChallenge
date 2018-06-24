//
//  MovieSearchViewController.swift
//  BluebirdChallenge
//
//  Created by Shawn Moore on 6/23/18.
//  Copyright © 2018 Shawn Moore. All rights reserved.
//

import UIKit

class MovieSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView?
    
    fileprivate let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Movies..."
        return controller
    }()
    
    fileprivate var viewModel: MovieListViewModel?
    fileprivate var recentSearches: [SearchItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
        
        self.tableView?.prefetchDataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension MovieSearchViewController: UITableViewDelegate & UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel, !viewModel.movies.isEmpty else {
            return recentSearches.count
        }
        
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movie = viewModel?.movies[indexPath.row] else {
            return UITableViewCell()
        }

        if let posterPath =  movie.posterPath {
            let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell
            
            ImageRequest.retrieveImage(path: posterPath).execute(in: MovieDBEnvironment.imageSearch, with: URLSessionDispatcher.shared) { (_, data, _, _) in
                guard let data = data else {
                    return
                }
                
                cell?.posterImageView?.image = UIImage(data: data)
            }
            
            return cell?.configure(from: movie) ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "movieWithoutPosterCell", for: indexPath) as? MovieTableViewCell
            
            return cell?.configure(from: movie) ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "Section Header") as? TextTableViewCell
        
        if let viewModel = viewModel, !viewModel.movies.isEmpty {
            header?.contentLabel?.text = "Movies"
        } else {
            header?.contentLabel?.text = "Past Searches"
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let viewModel = viewModel, !viewModel.retrievedAllPages else {
            return UIView()
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "loadingCell")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 141.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel, !viewModel.retrievedAllPages, !viewModel.movies.isEmpty, indexPath.row + 1 >= viewModel.movies.count else {
            return
        }
        
        viewModel.retrieveNextPage()
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension MovieSearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let posterPathes = indexPaths.compactMap({ viewModel?.movies[safe: $0.row]?.posterPath })
        
        for path in posterPathes {
            // Execute request to cache image data
            ImageRequest.retrieveImage(path: path).execute(in: MovieDBEnvironment.imageSearch, with: URLSessionDispatcher.shared, completionHandler: { _,_,_,_  in })
        }
    }
}

// MARK: - UISearchResultsUpdating
extension MovieSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.isActive, let text = searchController.searchBar.text, !text.isEmpty else {
            viewModel = nil
            tableView?.reloadData()
            return
        }
        
        self.viewModel = MovieListViewModel(with: text)
        self.viewModel?.delegate = self
    }
}

// MARK: - MovieListViewModelDelegate
extension MovieSearchViewController: MovieListViewModelDelegate {
    func load(error: Error) {
        let alert = UIAlertController(title: "Oh No", message: "An error occured!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func hasUpdatedMovieList() {
        tableView?.reloadData()
    }
}
