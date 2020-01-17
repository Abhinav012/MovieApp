//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Thanos on 16/01/20.
//  Copyright © 2020 Thanos. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    var apiManager = APIManager()
    var searchedMovies = [Movie]()
    var didSelectedMovie: Bool = false
    var didDisplayedDetailedResults: Bool = false
    var pageCount = 1
    var moviesScrolledCount = 0
    var pageEndReached = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        moviesScrolledCount = indexPath.row
        
        if indexPath.row == searchedMovies.count-1{
            pageEndReached = true
        }
        
        if didSelectedMovie{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchedMoviesDetailCell", for: indexPath) as! SearchedResultTableViewCell
        let movie = searchedMovies[indexPath.row]
            
            if let _ = movie.posterPath, let _ = movie.backdropPath{
                cell.backDropPathImageView.sd_setImage(with: URL(string: imagDwldBaseURL+movie.backdropPath!), completed: nil)
                cell.posterImageView.sd_setImage(with: URL(string: imagDwldBaseURL+movie.posterPath!), completed: nil)
        }
        cell.originalTitle.text = movie.originalTitle!
        cell.popularity.text = "popularity: \(movie.popularity!)"
        cell.releaseDate.text = "Release Date: \(movie.releaseDate!)"
        cell.voteCount.text = "vote count: \(movie.voteCount!)"
        didDisplayedDetailedResults = true
            
        return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath)
        cell.textLabel?.text = searchedMovies[indexPath.row].title
        
        didDisplayedDetailedResults = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if didDisplayedDetailedResults{
            let vc = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
            
            vc.movie = searchedMovies[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            didSelectedMovie = true
            
            let movie = searchedMovies[0]
            searchedMovies[0] = searchedMovies[indexPath.row]
            searchedMovies[indexPath.row] = movie
            searchBar.resignFirstResponder()
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        
    }
}

extension SearchViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        didSelectedMovie = false
        
        if searchText.count >= 3{
            
            let text = searchText.replacingOccurrences(of: " ", with: "+")
            
            let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=60af9fe8e3245c53ad9c4c0af82d56d6&language=en-US&page=1&query=\(text)")!
            let urlRequest = URLRequest(url: url)
            let session = URLSession.shared
            let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                }else{
                    if let data = data{
                        do{
                            let decoder = JSONDecoder()
                            let movieDetails = try decoder.decode(MovieResults.self, from: data)
                            
                            if let searchedMovies = movieDetails.results{
                                self.searchedMovies = searchedMovies
                                
                                for movie in searchedMovies{
                                    print("Movie backdrop: \(movie.backdropPath)")
                                    
                                }
                                
                                DispatchQueue.main.async {
                                    self.searchTableView.separatorStyle = .singleLine
                                    self.searchTableView.reloadData()
                                }
                                
                            }
                            
                        }catch(let error){
                            print(error.localizedDescription)
                        }
                        
                    }
                }
            }
            
            dataTask.resume()
        }else{
            
            self.searchedMovies = [Movie]()
            DispatchQueue.main.async {
                self.searchTableView.separatorStyle = .none
                self.searchTableView.reloadData()
            }
        }
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
