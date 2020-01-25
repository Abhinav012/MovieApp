//
//  LandingScenePresenter.swift
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

protocol LandingScenePresentationLogic
{
  func presentSomething(response: LandingScene.Something.Response)
}

class LandingScenePresenter: LandingScenePresentationLogic
{
  weak var viewController: LandingSceneDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: LandingScene.Something.Response)
  {
    let viewModel = LandingScene.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}