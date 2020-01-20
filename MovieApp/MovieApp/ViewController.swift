//
//  ViewController.swift
//  MovieApp
//
//  Created by Thanos on 13/01/20.
//  Copyright © 2020 Thanos. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var nowPlayingMoviesCollectionView: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    var apiManager = APIManager()
    var databaseManager = DatabaseManager()
    var movies = [Movie]()
    var moviesScrolledCount = 0
    var pageCount = 1
    var pageEndReached = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        DispatchQueue.global().sync {
            self.apiManager.fetchMovieDetails(lang: "en-US", page: 1, category: .nowPlaying)
            
            DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                let manager = DatabaseManager()
                manager.fetchMovieDetails(category: .nowPlaying)
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                
                self.movies = DatabaseManager.nowPlayingMovies
                print("Movie Count \(self.movies.count)")
                self.nowPlayingMoviesCollectionView.reloadData()
            }
        }
        
        
        
        
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

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }
    
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NowPlayingCollectionViewCell
        cell.layer.cornerRadius = 10
        cell.containerView.layer.cornerRadius = 10
//        cell.layer.shadowColor = UIColor.lightGray.cgColor
//        cell.layer.shadowRadius = 0
//        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
//        cell.layer.shadowOpacity = 1
//
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 20)
        cell.layer.shadowRadius = 20
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        //cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        cell.movieImageView.sd_setImage(with: URL(string: imagDwldBaseURL+movies[indexPath.row].posterPath!), completed: nil)
        cell.movieDescription.text = movies[indexPath.row].overview!
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
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        vc.movie = movies[indexPath.row]
        vc.movieCategory = .nowPlaying
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension ViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + 5*396 >= (scrollView.contentSize.height - scrollView.frame.size.height) && pageEndReached) {
            pageEndReached = false
            let value: Double = Double((moviesScrolledCount+5)/20)
            if floor(value) == value {
                pageCount = pageCount + 1
            }
            
            if pageCount != 1 {
                self.apiManager.fetchMovieDetails(lang: "en-US", page: self.pageCount, category: .nowPlaying)
                
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                    
                    self.databaseManager.fetchMovieDetails(category: .nowPlaying)
                    self.movies = DatabaseManager.nowPlayingMovies
                    print("Movie Count \(self.movies.count)")
                    self.nowPlayingMoviesCollectionView.reloadData()
                })
            }
            

        }

    }
}
