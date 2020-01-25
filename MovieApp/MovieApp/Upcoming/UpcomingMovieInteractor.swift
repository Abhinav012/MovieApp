//
//  UpcomingMovieInteractor.swift
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

protocol UpcomingMovieBusinessLogic
{
  func doSomething(request: UpcomingMovie.Something.Request)
  func callAPI(with page: Int, category: MovieCategory)
}

protocol UpcomingMovieDataStore
{
  //var name: String { get set }
}

class UpcomingMovieInteractor: UpcomingMovieBusinessLogic, UpcomingMovieDataStore
{
  var presenter: UpcomingMoviePresentationLogic?
  var worker: UpcomingMovieWorker?
  //var name: String = ""
  
  // MARK: Do something
  
    func doSomething(request: UpcomingMovie.Something.Request)
    {
        worker = UpcomingMovieWorker()
        worker?.doSomeWork()
        
        let defaults = UserDefaults.standard
        
        if !(defaults.bool(forKey: "didFetchUpcomingMoviesForFirstTime")){
            defaults.set(true, forKey: "didFetchUpcomingMoviesForFirstTime")
            worker?.downloadUpcomingMovies(lang: "en-US", page: 1, category: .upcoming, completion2: {
                success in
                if success{
                    let response = UpcomingMovie.Something.Response()
                    self.presenter?.presentSomething(response: response)
                }
               
            })
        }else{
            worker?.fetchMovies(category: .upcoming, fetchedMovies: {
                success in
                
                if success{
                    let response = UpcomingMovie.Something.Response()
                    self.presenter?.presentSomething(response: response)
                }
            })
        }
        
        
        
        
        
        
    }
    
    func callAPI(with page: Int, category: MovieCategory){
        worker?.downloadUpcomingMoviesWithoutLag(lang: "en-US", page: page, category: category, completion2: {
            success in
            
            if success{
                let response = UpcomingMovie.Something.Response()
                self.presenter?.presentSomething(response: response)
            }
            
        })
        
    }
}