//
//  MovieDetailViewController.swift
//  BluebirdChallenge
//
//  Created by Shawn Moore on 6/23/18.
//  Copyright © 2018 Shawn Moore. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView?
    @IBOutlet weak var posterImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var overviewLabel: UILabel?
    @IBOutlet weak var dateOpenedLabel: UILabel?
    @IBOutlet weak var popularityLabel: UILabel?
    
    var movie: MovieResponse? {
        didSet {
            setupView(with: movie)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView(with: movie)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView(with movie: MovieResponse?) {
        guard let movie = movie else {
            return
        }
        
        titleLabel?.text = movie.title
        overviewLabel?.text = movie.overview
        dateOpenedLabel?.text = DateFormatter.Utility.dayOnlyFormatter.string(from: movie.releaseDate)
        popularityLabel?.text = String(movie.popularity)
        
        if let posterPath = movie.posterPath {
            ImageRequest.retrieveImage(path: posterPath).execute(in: MovieDBEnvironment.imageSearch, with: URLSessionDispatcher.shared) { [weak self] (_, data, _, _) in
                guard let data = data, let strongSelf = self else {
                    return
                }
                
                if let image = UIImage(data: data) {
                    strongSelf.backgroundImageView?.image = image
                    strongSelf.posterImageView?.image = image
                }
            }
        } else {
            backgroundImageView?.isHidden = true
        }
    }

}
