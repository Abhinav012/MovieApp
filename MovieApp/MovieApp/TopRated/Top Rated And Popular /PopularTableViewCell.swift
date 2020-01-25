//
//  PopularTableViewCell.swift
//  MovieApp
//
//  Created by Thanos on 14/01/20.
//  Copyright © 2020 Thanos. All rights reserved.
//

import UIKit

class PopularTableViewCell: UITableViewCell {

    @IBOutlet weak var popularLabel: UILabel!
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var voteCount: UILabel!
    @IBOutlet weak var popularity: UILabel!
    
    @IBOutlet weak var movieTitleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var movieImageViewTopContraint: NSLayoutConstraint!
    
    @IBOutlet weak var popularCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
