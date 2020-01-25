//
//  DatabaseManager.swift
//  MovieApp
//
//  Created by Thanos on 13/01/20.
//  Copyright © 2020 Thanos. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DatabaseManager{
    
   static let manager = DatabaseManager()
   static var nowPlayingMovies = [Movie]()
   static var topRatedMovies = [Movie]()
   static var popularMovies = [Movie]()
   static var upcomingMovies = [Movie]()
    
    func storeMovieDetails(movies: [Movie],category : MovieCategory, completion: @escaping (_ success : Bool)-> Void){
        
       
        
    
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "MoviesDetail", in: context)
            
            for movie in movies{
                let movieResult = MoviesDetail(entity: entity!, insertInto: context)
                
                if let _ = movie.adult, let _ = movie.backdropPath, let _ = movie.posterPath, let _ = movie.id, let _ = movie.originalLanguage, let _ = movie.originalTitle, let _ = movie.overview, let _ = movie.popularity, let _ = movie.releaseDate, let _ = movie.title, let _ = movie.video, let _ = movie.voteCount, let _ = movie.voteAverage
                {
                    movieResult.adult = movie.adult!
                    movieResult.backdropPath = movie.backdropPath!
                    movieResult.posterPath = movie.posterPath!
                    movieResult.id = Int64(movie.id!)
                    movieResult.originalLanguage = movie.originalLanguage!
                    movieResult.originalTitle = movie.originalTitle!
                    movieResult.overview = movie.overview!
                    movieResult.popularity = movie.popularity!
                    movieResult.releaseDate = movie.releaseDate!
                    movieResult.title = movie.title!
                    movieResult.video = movie.video!
                    movieResult.voteCount = Int64(movie.voteCount!)
                    movieResult.voteAverage = Float(movie.voteAverage!)
                    movieResult.saveDate = Date()
                    movieResult.movieType = category.rawValue
                    
                }
                print(movie.title)
                print(movie.originalTitle)
                print(movie.backdropPath)
                print(movie.posterPath)
                

                
            }
            
            do{
                try context.save()
                completion(true)
            } catch(let error){
                print(error.localizedDescription)
            }
            
            
        
        
        
    }
    
    func deleteMovieDetails(category: MovieCategory){
        var count = 0
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesDetail")
            
            switch category{
            case .nowPlaying:
                fetchRequest.predicate = NSPredicate(format: "movieType == %@", argumentArray: ["now_playing"])
                DatabaseManager.nowPlayingMovies = [Movie]()
                
            case .popular:
                fetchRequest.predicate = NSPredicate(format: "movieType == %@", argumentArray: ["popular"])
                DatabaseManager.popularMovies = [Movie]()
                
            case .topRated:
                fetchRequest.predicate = NSPredicate(format: "movieType == %@", argumentArray: ["top_rated"])
                DatabaseManager.topRatedMovies = [Movie]()
                
            case .upcoming:
                fetchRequest.predicate = NSPredicate(format: "movieType == %@", argumentArray: ["upcoming"])
                DatabaseManager.upcomingMovies = [Movie]()
            }
            
            do{
    
                             var result = try context.fetch(fetchRequest)
                            for managedObject in result
                            {
                                count+=1
                                print(count)
                                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                                context.delete(managedObjectData)
                            }
                
                            try context.save()
            }catch(let error){
                print(error.localizedDescription)
            }
        }
        
        
        print("data Deleted")
    }
    
    func fetchMovieDetails(category: MovieCategory, completion: (_ success : Bool)-> Void){
        
        
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesDetail")
            
            
            switch category{
            case .nowPlaying:
                fetchRequest.predicate = NSPredicate(format: "movieType == %@", argumentArray: ["now_playing"])
                DatabaseManager.nowPlayingMovies = [Movie]()
                
            case .popular:
                fetchRequest.predicate = NSPredicate(format: "movieType == %@", argumentArray: ["popular"])
                DatabaseManager.popularMovies = [Movie]()
                
            case .topRated:
                fetchRequest.predicate = NSPredicate(format: "movieType == %@", argumentArray: ["top_rated"])
                DatabaseManager.topRatedMovies = [Movie]()
                
            case .upcoming:
                fetchRequest.predicate = NSPredicate(format: "movieType == %@", argumentArray: ["upcoming"])
                DatabaseManager.upcomingMovies = [Movie]()
            }
            
            let sectionSortDescriptor = NSSortDescriptor(key: "saveDate", ascending: true)
            let sortDescriptors = [sectionSortDescriptor]
            fetchRequest.sortDescriptors = sortDescriptors
//            let sort = NSSortDescriptor(key: "date", ascending: true)
//            fetchRequest.sortDescriptors = [sort]
            
            do{
                let result = try context.fetch(fetchRequest)
                for data in result as! [MoviesDetail]{
                    
                    var movie = Movie()
                    if let _ = data.originalTitle, let _ = data.posterPath, let _ = data.backdropPath, let _ = data.title, let _ = data.overview, let _ = data.releaseDate{
                        movie.originalTitle = data.originalTitle!
                        movie.popularity  = data.popularity
                        movie.voteCount = Int(data.voteCount)
                        movie.video = data.video
                        movie.posterPath = data.posterPath!
                        movie.id = Int(data.id)
                        movie.adult = data.adult
                        movie.backdropPath = data.backdropPath!
                        movie.originalLanguage = data.originalLanguage
                        movie.title = data.title!
                        movie.voteAverage = Double(exactly: data.voteAverage)
                        movie.overview = data.overview!
                        movie.releaseDate = data.releaseDate!
                        
                    }
                    
                    switch category{
                    case .nowPlaying:
                        DatabaseManager.nowPlayingMovies.append(movie)
                    case .popular:
                        DatabaseManager.popularMovies.append(movie)
                    case .topRated:
                        DatabaseManager.topRatedMovies.append(movie)
                    case .upcoming:
                        DatabaseManager.upcomingMovies.append(movie)
                    }
                    
                }
                completion(true)
            }catch(let error){
                print(error.localizedDescription)
            }
           
        
        print("fetch called")
    }
    
}
