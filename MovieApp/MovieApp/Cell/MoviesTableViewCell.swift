//
//  MoviesTableViewCell.swift
//  MovieApp
//
//  Created by Thanos on 23/01/20.
//  Copyright © 2020 Thanos. All rights reserved.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    @IBOutlet weak var voteCount: UILabel!
    @IBOutlet weak var popularity: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        movieImageView.layer.cornerRadius = 15
        movieImageView.clipsToBounds = true
        separatorInset = UIEdgeInsets(top: 0, left: 102, bottom: 0, right: 24)
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
