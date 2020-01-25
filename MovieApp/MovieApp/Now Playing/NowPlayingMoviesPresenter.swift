//
//  NowPlayingMoviesPresenter.swift
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

protocol NowPlayingMoviesPresentationLogic
{
  func presentSomething(response: NowPlayingMovies.Something.Response)
}

class NowPlayingMoviesPresenter: NowPlayingMoviesPresentationLogic
{
  weak var viewController: NowPlayingMoviesDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: NowPlayingMovies.Something.Response)
  {
    let viewModel = DatabaseManager.nowPlayingMovies
    viewController?.displaySomething(viewModel: viewModel)
  }
}
