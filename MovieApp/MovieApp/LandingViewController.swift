//
//  LandingViewController.swift
//  MovieApp
//
//  Created by Thanos on 15/01/20.
//  Copyright © 2020 Thanos. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    var apiManager = APIManager()
    
    @IBOutlet weak var dataLoader: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()

     }

    func loadData(){
        dataLoader.startAnimating()
        
         DispatchQueue.global().sync {
        self.apiManager.fetchMovieDetails(lang: "en-US", page: 1, category: .topRated)
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                let manager = DatabaseManager()
                manager.fetchMovieDetails(category: .topRated)
            })
       
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            
            self.dataLoader.stopAnimating()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RootTabBarViewController") as! RootTabBarViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = vc
        }
        
        }

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
