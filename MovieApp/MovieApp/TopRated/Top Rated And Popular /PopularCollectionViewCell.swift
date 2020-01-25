//
//  PopularCollectionViewCell.swift
//  MovieApp
//
//  Created by Thanos on 14/01/20.
//  Copyright © 2020 Thanos. All rights reserved.
//

import UIKit

class PopularCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movie1ImageView: UIImageView!
    @IBOutlet weak var movie1Title: UILabel!
    @IBOutlet weak var movie1ReleaseDate: UILabel!
    @IBOutlet weak var movie1VoteCount: UILabel!
    @IBOutlet weak var movie1Popularity: UILabel!
 
    @IBOutlet weak var movie2ImageView: UIImageView!
    @IBOutlet weak var movie2Title: UILabel!
    @IBOutlet weak var movie2ReleaseDate: UILabel!
    @IBOutlet weak var movie2VoteCount: UILabel!
    @IBOutlet weak var movie2Popularity: UILabel!
    
    override func awakeFromNib() {
        movie1ImageView.layer.cornerRadius = 15
        movie2ImageView.layer.cornerRadius = 15
    }
}
