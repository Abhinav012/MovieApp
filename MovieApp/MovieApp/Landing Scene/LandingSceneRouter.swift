//
//  LandingSceneRouter.swift
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

@objc protocol LandingSceneRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
    func routeToRootViewController()
}

protocol LandingSceneDataPassing
{
  var dataStore: LandingSceneDataStore? { get }
}

class LandingSceneRouter: NSObject, LandingSceneRoutingLogic, LandingSceneDataPassing
{
  weak var viewController: LandingSceneViewController?
  var dataStore: LandingSceneDataStore?
  
  // MARK: Routing
  
    func routeToRootViewController() {
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "RootTabBarViewController") as! RootTabBarViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = vc
    }
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  //{
  //  if let segue = segue {
  //    let destinationVC = segue.destination as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //  } else {
  //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
  //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }
  //}

  // MARK: Navigation
  
  //func navigateToSomewhere(source: LandingSceneViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: LandingSceneDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}