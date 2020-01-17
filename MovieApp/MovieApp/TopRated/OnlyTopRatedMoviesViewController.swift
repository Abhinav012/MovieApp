//
//  OnlyTopRatedMoviesViewController.swift
//  MovieApp
//
//  Created by Thanos on 17/01/20.
//  Copyright © 2020 Thanos. All rights reserved.
//

import UIKit

class Only_TopRatedMoviesViewController: UIViewController {

    var movies = [Movie]()
    var apiManager = APIManager()
    var databaseManager = DatabaseManager()
    var moviesScrolledCount = 0
    var pageEndReached: Bool = false
    var pageCount = 1
    var pageMatch = 1
    
    
    @IBOutlet weak var topRatedTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        pageMatch = pageCount
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    
}

extension Only_TopRatedMoviesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UMtableViewCell", for: indexPath) as! UpcomingMoviesTableViewCell
        if let _ =  movies[indexPath.row].posterPath {
            cell.movieImageView.sd_setImage(with: URL(string: imagDwldBaseURL+movies[indexPath.row].posterPath! ), completed: nil)
            
        }
        
        cell.movieTitle.text = movies[indexPath.row].originalTitle
        cell.popularity.text = "\(movies[indexPath.row].popularity!)"
        cell.releaseDate.text = "Release Date: \(movies[indexPath.row].releaseDate!)"
        cell.voteCount.text = "vote count: \(movies[indexPath.row].voteCount!)"
        moviesScrolledCount = indexPath.row+1
        
        if indexPath.row-1 == movies.count-10{
            pageEndReached = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        vc.movie = movies[indexPath.row]
        vc.movieCategory = .topRated
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension Only_TopRatedMoviesViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + 10*92 >= (scrollView.contentSize.height - scrollView.frame.size.height) && pageEndReached) {
            pageEndReached = false
            let value: Double = Double((moviesScrolledCount+10)/20)
            if floor(value) == value {
                pageCount = pageCount + 1
            }
            
            if pageCount != pageMatch{
                print("Page Count: \(pageCount)")
                self.apiManager.fetchMovieDetails(lang: "en-US", page: pageCount, category: .topRated)
                
                DispatchQueue.global().sync {
                    DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                        DatabaseManager.manager.fetchMovieDetails(category: .topRated)
                    })
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                        self.movies = DatabaseManager.topRatedMovies
                        self.topRatedTableView.reloadData()
                    })
                }
            }
            
            
        }
        
    }
}
