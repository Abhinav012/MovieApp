//
//  TopRatedTrendingTableViewCell.swift
//  MovieApp
//
//  Created by Thanos on 14/01/20.
//  Copyright © 2020 Thanos. All rights reserved.
//

import UIKit

class TopRatedTrendingTableViewCell: UITableViewCell {

    @IBOutlet weak var trendingMovieCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
