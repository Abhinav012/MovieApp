//
//  UpcomingMoviesViewController.swift
//  MovieApp
//
//  Created by Thanos on 13/01/20.
//  Copyright © 2020 Thanos. All rights reserved.
//

import UIKit

class UpcomingMoviesViewController: UIViewController {

    var movies = [Movie]()
    var apiManager = APIManager()
    var databaseManager = DatabaseManager()
    var moviesScrolledCount = 0
    var pageEndReached: Bool = false
    var pageCount = 1
    
    
    @IBOutlet weak var upcomingTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
  
        DispatchQueue.global().sync {
             self.apiManager.fetchMovieDetails(lang: "en-US", page: 1, category: .upcoming)
            DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                DatabaseManager.manager.fetchMovieDetails(category: .upcoming)
            })
            
            
            DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                self.movies = DatabaseManager.upcomingMovies
                self.upcomingTableView.reloadData()
            })
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
  
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UpcomingMoviesViewController: UITableViewDelegate, UITableViewDataSource{
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
        vc.movieCategory = .upcoming
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UpcomingMoviesViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + 10*92 >= (scrollView.contentSize.height - scrollView.frame.size.height) && pageEndReached) {
            pageEndReached = false
            let value: Double = Double((moviesScrolledCount+10)/20)
            if floor(value) == value {
                pageCount = Int((moviesScrolledCount+10)/20) + 1
            }
            
            if pageCount != 1{
                print("Page Count: \(pageCount)")
            self.apiManager.fetchMovieDetails(lang: "en-US", page: pageCount, category: .upcoming)
                
                DispatchQueue.global().sync {
                    DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                        DatabaseManager.manager.fetchMovieDetails(category: .upcoming)
                    })
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                        self.movies = DatabaseManager.upcomingMovies
                        self.upcomingTableView.reloadData()
                    })
                }
            }
          
            
        }
        
    }
}
