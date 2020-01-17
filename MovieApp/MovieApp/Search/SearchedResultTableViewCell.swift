//
//  SearchedResultTableViewCell.swift
//  MovieApp
//
//  Created by Thanos on 16/01/20.
//  Copyright © 2020 Thanos. All rights reserved.
//

import UIKit

class SearchedResultTableViewCell: UITableViewCell {

    @IBOutlet weak var backDropPathImageView: UIImageView!
    @IBOutlet weak var originalTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var voteCount: UILabel!
    @IBOutlet weak var popularity: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backDropPathImageView.layer.cornerRadius = 15
        posterImageView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
