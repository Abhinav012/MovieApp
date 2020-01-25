//
//  UpcomingMovieViewController.swift
//  MovieApp
//
//  Created by Thanos on 24/01/20.
//  Copyright (c) 2020 Thanos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import SDWebImage

protocol UpcomingMovieDisplayLogic: class
{
  func displaySomething(viewModel: [Movie])
}

class UpcomingMovieViewController: UIViewController, UpcomingMovieDisplayLogic
{
  var interactor: UpcomingMovieBusinessLogic?
  var router: (NSObjectProtocol & UpcomingMovieRoutingLogic & UpcomingMovieDataPassing)?

    var movies = [Movie]()
    var apiManager = APIManager()
    var databaseManager = DatabaseManager()
    var moviesScrolledCount = 0
    var pageEndReached: Bool = false
    var pageCount = 1
    var defaults = UserDefaults.standard
    
    @IBOutlet weak var upcomingTableView: UITableView!
    // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = UpcomingMovieInteractor()
    let presenter = UpcomingMoviePresenter()
    let router = UpcomingMovieRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    upcomingTableView.register(UINib(nibName: "MoviesTableViewCell", bundle: nil), forCellReuseIdentifier: "moviesTableViewCell")
    doSomething()
  }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
  
  func doSomething()
  {
    let request = UpcomingMovie.Something.Request()
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: [Movie])
  {
    movies = viewModel
    DispatchQueue.main.async {
        self.upcomingTableView.reloadData()
    }
  }
}
extension UpcomingMovieViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviesTableViewCell", for: indexPath) as! MoviesTableViewCell
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
        
        router?.movie = movies[indexPath.row]
        router?.routeToDetailViewController()

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.global().sync {
            
            if indexPath.row == movies.count-11{
                pageEndReached = false
                let value: Double = Double((moviesScrolledCount+10)/20)
                if floor(value) == value {
                    pageCount = pageCount + 1
                }
                
                if pageCount != 1 && pageCount <= defaults.value(forKey: "upcomingPageCount") as! Int{
                    print("Page Count: \(pageCount)")
                    self.interactor?.callAPI(with: self.pageCount, category: .upcoming)

                }
            }
        }
    }
}

