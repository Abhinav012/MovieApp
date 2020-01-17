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
    
    
    func fetchAPIResults(url: URL, completion: @escaping (Data)->()){
        
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
    
    func fetchMovieDetails(lang: String, page: Int, category: MovieCategory){
        
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
        fetchAPIResults(url: url!, completion: storeMovieDetails)
       
    }
    
    func storeMovieDetails(data: Data){
        
        do{
            print(data)
            let decoder = JSONDecoder()
           let movieDetails = try decoder.decode(MovieResults.self, from: data)
            databaseManager.storeMovieDetails(movies: movieDetails.results!, category: category)
            
         }catch(let error){
            print(error.localizedDescription)
        }
    }
    
    
}
