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
    var moviesScrolledCount = -1
    var pageEndReached = false
    var totalPageCount = 0
    var searchText = ""
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var searchMoviesLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTableView.keyboardDismissMode = .interactive
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        moviesScrolledCount = indexPath.row+1
        
        if indexPath.row == searchedMovies.count-1{
            pageEndReached = true
        }
        
        if didSelectedMovie{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchedMoviesDetailCell", for: indexPath) as! SearchedResultTableViewCell
        let movie = searchedMovies[indexPath.row]
            
            if let _ = movie.originalTitle, let _ = movie.popularity, let _ = movie.releaseDate, let _ = movie.voteCount{
                cell.originalTitle.text = movie.originalTitle!
                cell.popularity.text = "popularity: \(movie.popularity!)"
                cell.releaseDate.text = "Release Date: \(movie.releaseDate!)"
                cell.voteCount.text = "vote count: \(movie.voteCount!)"
        }
            if let _ = movie.posterPath {
                cell.posterImageView.sd_setImage(with: URL(string: imagDwldBaseURL+movie.posterPath!), completed: nil)
            }
            
            if let _ = movie.backdropPath{
                cell.backDropPathImageView.sd_setImage(with: URL(string: imagDwldBaseURL+movie.backdropPath!), completed: nil)
            }
        
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
    
    func fetchSearchData(searchText: String, pageCount: Int){
        let text = searchText.replacingOccurrences(of: " ", with: "+")
        
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=60af9fe8e3245c53ad9c4c0af82d56d6&language=en-US&page=\(pageCount)&query=\(text)")!
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
                        self.totalPageCount = movieDetails.totalPages!
                        if let searchedMovies = movieDetails.results{
                            if pageCount == 1 {
                            self.searchedMovies = searchedMovies
                            }
                            else{
                                for movie in searchedMovies{
                                    print("Movie backdrop: \(movie.backdropPath)")
                                    self.searchedMovies.append(movie)
                                }
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
    }
}

extension SearchViewController: UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        didSelectedMovie = false
        
        if searchText == ""{
            searchBar.showsCancelButton = false
        }
        else{
            searchBar.showsCancelButton = true
        }
        
        
        if searchText.count >= 3{
            
            searchMoviesLabel.isHidden = true
            self.pageCount = 1
            self.searchText = searchText
            fetchSearchData(searchText: searchText, pageCount: self.pageCount)
            
        }else{
            
            searchMoviesLabel.isHidden = false
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        searchBar.text = ""
        self.searchedMovies = [Movie]()
         searchMoviesLabel.isHidden = false
        DispatchQueue.main.async {
            self.searchTableView.separatorStyle = .none
            self.searchTableView.reloadData()
        }
    }
}

extension SearchViewController: UIScrollViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        
        if (scrollView.contentOffset.y + 10*44 >= (scrollView.contentSize.height - scrollView.frame.size.height) && pageEndReached) {
            pageEndReached = false
            let value: Double = Double((moviesScrolledCount+10)/20)
            if floor(value) == value {
                pageCount = Int((moviesScrolledCount+10)/20) + 1
            }
            
            if pageCount <= totalPageCount && pageCount != 1{
                   fetchSearchData(searchText: self.searchText, pageCount: pageCount)
            }
            
            
        }
        
    }
}
