//
//  MovieTableViewCell.swift
//  BluebirdChallenge
//
//  Created by Shawn Moore on 6/23/18.
//  Copyright © 2018 Shawn Moore. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var overviewLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        posterImageView?.image = nil
        titleLabel?.text = nil
        overviewLabel?.text = nil
    }

    func configure(from movie: MovieResponse?) -> Self? {
        guard let movie = movie else {
            return nil
        }
        
        titleLabel?.text = movie.title
        overviewLabel?.text = movie.overview
        
        return self
    }
}
