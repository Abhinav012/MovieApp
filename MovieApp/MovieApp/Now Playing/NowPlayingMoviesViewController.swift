//
//  NowPlayingMoviesViewController.swift
//  MovieApp
//
//  Created by Thanos on 23/01/20.
//  Copyright (c) 2020 Thanos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import SDWebImage

protocol NowPlayingMoviesDisplayLogic: class
{
  func displaySomething(viewModel: [Movie])
}

class NowPlayingMoviesViewController: UIViewController, NowPlayingMoviesDisplayLogic
{
  var interactor: NowPlayingMoviesBusinessLogic?
  var router: (NSObjectProtocol & NowPlayingMoviesRoutingLogic & NowPlayingMoviesDataPassing)?

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nowPlayingMoviesCollectionView: UICollectionView!
    
    var apiManager = APIManager()
    var databaseManager = DatabaseManager()
    var movies = [Movie]()
    var moviesScrolledCount = 0
    var pageCount = 1
    var pageEndReached = true
    var defaults = UserDefaults.standard
    var movieImages = [UIImage?]()
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
    let interactor = NowPlayingMoviesInteractor()
    let presenter = NowPlayingMoviesPresenter()
    let router = NowPlayingMoviesRouter()
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
    doSomething()
  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let date = Date()
        let calender = Calendar(identifier: .gregorian)
        let dateOfMonth = calender.component(.day, from: date)
        let monthOfCalender = Month(rawValue: calender.component(.month, from: date))
        let weekdayOfMonth = WeekDay(rawValue: calender.component(.weekday, from: date))
        
        setDayAndmonthOfYear(weekday: weekdayOfMonth!, month: monthOfCalender!)
        
        dateLabel.text = "\(day) \(dateOfMonth) \(monthOfYear)"
        
    }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
  
  func doSomething()
  {
    let request = NowPlayingMovies.Something.Request()
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: [Movie])
  {
    movies = viewModel
     print("Movie Count \(self.movies.count)")
    DispatchQueue.main.async {
        self.nowPlayingMoviesCollectionView.reloadData()
    }
  }
}

extension NowPlayingMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        DispatchQueue.global().async {
            if indexPath.row == self.movies.count-2{
                let value: Double = Double((self.moviesScrolledCount+5)/20)
                if floor(value) == value {
                    self.pageCount = self.pageCount + 1
                }
                
                if self.pageCount != 1 && self.pageCount <= self.defaults.value(forKey: "nowPlayingPageCount") as! Int{
    
                    self.interactor?.callAPI(with: self.pageCount, category: .nowPlaying)
                }
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NowPlayingCollectionViewCell
        cell.layer.cornerRadius = 10
        cell.containerView.layer.cornerRadius = 10
        
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 20)
        cell.layer.shadowRadius = 20
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
       
        
//        SDImageCache.shared.queryCacheOperation(forKey: self.movies[indexPath.row].posterPath!) { (image, data, cacheType) in
//            if let image = image{
//                cell.movieImageView.image = image
//            }
//        }
        cell.movieImageView.sd_setImage(with: URL(string: imagDwldBaseURL+self.movies[indexPath.row].posterPath!), completed: nil)
        cell.movieDescription.text = movies[indexPath.row].overview!
        print(movies[indexPath.row].originalTitle!)
        cell.originalTitle.text = movies[indexPath.row].originalTitle!
        cell.title.text = movies[indexPath.row].title!
        cell.releaseDate.text = "Release Date: \(movies[indexPath.row].releaseDate!)"
        cell.voteAverage.text = "\(Float(movies[indexPath.row].voteAverage!))/10.0"
        
        moviesScrolledCount = indexPath.row+1
        
        if indexPath.row == movies.count-1{
            pageEndReached = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width-2*21, height: 396)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 46
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 46
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router?.movie = movies[indexPath.row]
        router?.routeToDetailViewController()
    }
}


