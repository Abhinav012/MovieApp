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
    
    func storeMovieDetails(movies: [Movie],category : MovieCategory){
        
       
        
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "MovieDetails", in: context)
            
            for movie in movies{
                let movieResult = NSManagedObject(entity: entity!, insertInto: context)
                
                print(movie.title)
                print(movie.originalTitle)
                
                movieResult.setValue(movie.adult, forKey: "adult")
                movieResult.setValue(movie.backdropPath, forKey: "backdrop_path")
                movieResult.setValue(movie.id, forKey: "id")
                movieResult.setValue(movie.originalLanguage, forKey: "original_language")
                movieResult.setValue(movie.originalTitle, forKey: "original_title")
                movieResult.setValue(movie.overview, forKey: "overview")
                movieResult.setValue(movie.popularity, forKey: "popularity")
                movieResult.setValue(movie.posterPath, forKey: "poster_path")
                movieResult.setValue(movie.releaseDate, forKey: "release_date")
                movieResult.setValue(movie.title, forKey: "title")
                movieResult.setValue(movie.video, forKey: "video")
                movieResult.setValue(movie.voteAverage, forKey: "vote_average")
                movieResult.setValue(movie.voteCount, forKey: "vote_count")
                movieResult.setValue(Date(), forKey: "save_date")
                
                switch category{
                case .nowPlaying:
                    movieResult.setValue("now_playing", forKey: "movie_type")
                 
                case .popular:
                    movieResult.setValue("popular", forKey: "movie_type")

                case .topRated:
                    movieResult.setValue("top_rated", forKey: "movie_type")
                    
                case .upcoming:
                    movieResult.setValue("upcoming", forKey: "movie_type")
                }
                
            }
            
            do{
                try context.save()
                
                //self.fetchMovieDetails(category: category)
            } catch(let error){
                print(error.localizedDescription)
            }
            
            
        }
        
        
    }
    
    func deleteMovieDetails(category: MovieCategory){
        var count = 0
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieDetails")
            
            switch category{
            case .nowPlaying:
                fetchRequest.predicate = NSPredicate(format: "movie_type == %@", argumentArray: ["now_playing"])
                DatabaseManager.nowPlayingMovies = [Movie]()
                
            case .popular:
                fetchRequest.predicate = NSPredicate(format: "movie_type == %@", argumentArray: ["popular"])
                DatabaseManager.popularMovies = [Movie]()
                
            case .topRated:
                fetchRequest.predicate = NSPredicate(format: "movie_type == %@", argumentArray: ["top_rated"])
                DatabaseManager.topRatedMovies = [Movie]()
                
            case .upcoming:
                fetchRequest.predicate = NSPredicate(format: "movie_type == %@", argumentArray: ["upcoming"])
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
    
    func fetchMovieDetails(category: MovieCategory){
        
        
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieDetails")
            
            
            switch category{
            case .nowPlaying:
                fetchRequest.predicate = NSPredicate(format: "movie_type == %@", argumentArray: ["now_playing"])
                DatabaseManager.nowPlayingMovies = [Movie]()
                
            case .popular:
                fetchRequest.predicate = NSPredicate(format: "movie_type == %@", argumentArray: ["popular"])
                DatabaseManager.popularMovies = [Movie]()
                
            case .topRated:
                fetchRequest.predicate = NSPredicate(format: "movie_type == %@", argumentArray: ["top_rated"])
                DatabaseManager.topRatedMovies = [Movie]()
                
            case .upcoming:
                fetchRequest.predicate = NSPredicate(format: "movie_type == %@", argumentArray: ["upcoming"])
                DatabaseManager.upcomingMovies = [Movie]()
            }
            
            let sectionSortDescriptor = NSSortDescriptor(key: "save_date", ascending: true)
            let sortDescriptors = [sectionSortDescriptor]
            fetchRequest.sortDescriptors = sortDescriptors
//            let sort = NSSortDescriptor(key: "date", ascending: true)
//            fetchRequest.sortDescriptors = [sort]
            
            do{
                let result = try context.fetch(fetchRequest)
                for data in result as! [NSManagedObject]{
                    
                    var movie = Movie()
                    
                    movie.originalTitle = data.value(forKey: "original_title") as? String
                    movie.popularity  = data.value(forKey: "popularity") as? Double
                    movie.voteCount = data.value(forKey: "vote_count") as? Int
                    movie.video = data.value(forKey: "video") as? Bool
                    movie.posterPath = data.value(forKey: "poster_path") as? String
                    movie.id = data.value(forKey: "id") as? Int
                    movie.adult = data.value(forKey: "adult") as? Bool
                    movie.backdropPath = data.value(forKey: "backdrop_path") as? String
                    movie.originalLanguage = data.value(forKey: "original_language") as? String
                    movie.title = data.value(forKey: "title") as? String
                    movie.voteAverage = data.value(forKey: "vote_average") as? Double
                    movie.overview = data.value(forKey: "overview") as? String
                    movie.releaseDate = data.value(forKey: "release_date") as? String
                    
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
                
            }catch(let error){
                print(error.localizedDescription)
            }
           
        }
        print("fetch called")
    }
    
}
