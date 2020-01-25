//
//  APIManager.swift
//  MovieApp
//
//  Created by Thanos on 13/01/20.
//  Copyright © 2020 Thanos. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class APIManager{
    private var databaseManager = DatabaseManager()
    private var category: MovieCategory = .nowPlaying
    private var searchedMovies = [Movie]()
    static var imageCache = NSCache<NSString, UIImage>()
    
    
    func fetchAPIResults(url: URL, completion: @escaping (Data)-> Void){
        
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }else{
                if let data = data{
                    
                    completion(data)
                }
            }
        }
        
        dataTask.resume()
    }
    
    func fetchMovieDetails(lang: String, page: Int, category: MovieCategory, completion: @escaping (_ success : Bool) -> Void){
        
        print("fetch Movie Detail API called")
        self.category = category
        var urlString = baseURL+"movie/now_playing?"+apiKey+"&language="+lang+"&page=\(page)"
        switch category{
        case .nowPlaying:
            urlString = baseURL+"movie/now_playing?"+apiKey+"&language="+lang+"&page=\(page)"
            
        case .popular:
            urlString = baseURL+"movie/popular?"+apiKey+"&language="+lang+"&page=\(page)"
            
        case .topRated:
            urlString = baseURL+"movie/top_rated?"+apiKey+"&language="+lang+"&page=\(page)"
            
        case .upcoming:
            urlString = baseURL+"movie/upcoming?"+apiKey+"&language="+lang+"&page=\(page)"
        }
        
        
        let url = URL(string: urlString)
        fetchAPIResults(url: url!) { (data) in
            self.storeMovieDetails(data: data, completionStore: { (success) in
                completion(success)
            })
        }
       
    }
    
    func storeMovieDetails(data: Data, completionStore: @escaping (_ success : Bool) -> Void){
        
        let defaults = UserDefaults.standard
        
        do{
            print(data)
            let decoder = JSONDecoder()
           let movieDetails = try decoder.decode(MovieResults.self, from: data)
            
            switch(category){
            case .nowPlaying :
                defaults.set(movieDetails.totalPages!, forKey: "nowPlayingPageCount")
            case .topRated :
                defaults.set(movieDetails.totalPages!, forKey: "topRatedPageCount")
            case .popular :
                defaults.set(movieDetails.totalPages!, forKey: "popularPageCount")
            case .upcoming :
                defaults.set(movieDetails.totalPages!, forKey: "upcomingPageCount")
            }
            
            databaseManager.storeMovieDetails(movies: movieDetails.results!, category: category, completion: ({ success in
               completionStore(success)
            }))
            
         }catch(let error){
            print(error.localizedDescription)
        }
    }
    
    static func getImage(imagePath: String?, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
        DispatchQueue.global().async {
            
        guard let imagePath = imagePath else{
            completion(nil,nil)
            return
        }
        let url = URL(string: imagDwldBaseURL + imagePath)!
        
        if let cachedImage = APIManager.imageCache.object(forKey: imagePath as NSString) {
            completion(cachedImage, nil)
        } else {
           let datatask = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
                if let error = error {
                    completion(nil, error)
                    
                } else if let data = data, let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: imagePath as NSString)
                    completion(image, nil)
                } else {
                    completion(nil, error)
                }
            })
            datatask.resume()
        }
      }
    }
}
