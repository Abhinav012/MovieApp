//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Thanos on 13/01/20.
//  Copyright © 2020 Thanos. All rights reserved.
//

import UIKit
import SDWebImage

class MovieDetailViewController: UIViewController {

    var movie: Movie?
    var movieCategory = MovieCategory(rawValue: "none")
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var voteCount: UILabel!
    @IBOutlet weak var moviePopularity: UILabel!
    @IBOutlet weak var movieLanguage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        movieTitle.text = movie?.originalTitle!
        voteCount.text = "vote count: \((movie?.voteCount)!)"
        movieDescription.text = movie?.overview!
        moviePopularity.text = "Popularity: \((movie?.popularity)!)%"
        movieLanguage.text = "Language: \((movie?.originalLanguage)!)"
        movieImageView.sd_setImage(with: URL(string: imagDwldBaseURL+(movie?.posterPath)!), completed: nil)
        
        switch movieCategory{
        case .nowPlaying?:
              category.text = "Now Playing"
        case .popular?:
              category.text = "Popular"
        case .topRated?:
            category.text = "Top Rated"
        case .upcoming?:
            category.text = "Up Coming"
        case .none:
            print("none")
            category.text = ""
            break
        }
    }
    
    func setupUI(){
        closeButton.layer.cornerRadius = closeButton.frame.width/2
        
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    

}
