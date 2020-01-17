//
//  TopRatedViewController.swift
//  MovieApp
//
//  Created by Thanos on 14/01/20.
//  Copyright © 2020 Thanos. All rights reserved.
//

import UIKit

class TopRatedViewController: UIViewController {

    var topRatedMovies = [Movie]()
    var popularMovies = [Movie]()
    var apiManager = APIManager()
    var databaseManager = DatabaseManager()
    
    @IBOutlet weak var topRatedMoviesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
         DispatchQueue.global().sync {
        self.apiManager.fetchMovieDetails(lang: "en-US", page: 1, category: .popular)
            
            DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                let manager = DatabaseManager()
                manager.fetchMovieDetails(category: .popular)
            })
            
            
            DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                self.topRatedMovies = DatabaseManager.topRatedMovies
                self.popularMovies = DatabaseManager.popularMovies
                self.topRatedMoviesTableView.reloadData()
            })
            
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
    }

}

extension TopRatedViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularMovies.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row != 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "popularMoviesCell", for: indexPath) as! PopularTableViewCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 102, bottom: 0, right: 32)
            let movie = popularMovies[indexPath.row-1]
            cell.movieImageView.layer.cornerRadius = 15
            cell.movieImageView.sd_setImage(with: URL(string: imagDwldBaseURL + movie.posterPath!), completed: nil)
            cell.movieTitle.text = movie.originalTitle!
            cell.popularity.text = "popularity: \(movie.popularity!)"
            cell.releaseDate.text = "Release Date: \(movie.releaseDate!)"
            cell.voteCount.text = "vote count: \(movie.voteCount!)"
            
            if indexPath.row != 1{
                cell.movieImageViewTopContraint.constant = 10
                cell.movieTitleTopConstraint.constant = 23
                cell.popularLabel.isHidden = true
            }
            else{
                cell.movieImageViewTopContraint.constant = 59
                cell.movieTitleTopConstraint.constant = 72
                cell.popularLabel.isHidden = false
            }
            
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "trendingCell", for: indexPath) as! TopRatedTrendingTableViewCell
        cell.trendingMovieCollectionView.reloadData()
        cell.separatorInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0{
            let vc = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
            
            vc.movie = popularMovies[indexPath.row-1]
            vc.movieCategory = .popular
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 300
        }
        if indexPath.row == 1{
            return 127
        }
        return 80
    }
}

extension TopRatedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 0{
            return topRatedMovies.count
        }
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topRatedCollectionViewCell", for: indexPath) as! TopRatedCollectionViewCell
        let movie = topRatedMovies[indexPath.row]
        cell.moviePosterImageView.sd_setImage(with: URL(string: imagDwldBaseURL+movie.posterPath!), completed: nil)
        cell.movieDescription.text = movie.overview!
        cell.popularity.text = "popularity: \(movie.popularity!)%"
        cell.title.text = movie.title!
        cell.voteAvg.text = "vote average: \(Float(movie.voteAverage!))"
        cell.voteCount.text = "Vote Count: \(movie.voteCount!)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
     
        vc.movie = topRatedMovies[indexPath.row]
        vc.movieCategory = .topRated
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        
        return CGSize(width: self.view.frame.width-2*32, height: 270)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
