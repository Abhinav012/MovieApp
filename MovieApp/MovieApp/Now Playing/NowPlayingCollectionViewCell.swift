//
//  NowPlayingCollectionViewCell.swift
//  MovieApp
//
//  Created by Thanos on 14/01/20.
//  Copyright © 2020 Thanos. All rights reserved.
//

import UIKit

class NowPlayingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var originalTitle: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var voteAverage: UILabel!
    
    @IBOutlet weak var movieImageButton: UIButton!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
}
