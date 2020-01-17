//
//  TopRatedCollectionViewCell.swift
//  MovieApp
//
//  Created by Thanos on 14/01/20.
//  Copyright © 2020 Thanos. All rights reserved.
//

import UIKit

class TopRatedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var voteCount: UILabel!
    @IBOutlet weak var popularity: UILabel!
    @IBOutlet weak var voteAvg: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var seeAllButton: UIButton!
    
    override func awakeFromNib() {
        moviePosterImageView.layer.cornerRadius = 5
    }
}
