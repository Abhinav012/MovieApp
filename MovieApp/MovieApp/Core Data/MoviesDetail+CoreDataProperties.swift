//
//  MoviesDetail+CoreDataProperties.swift
//  MovieApp
//
//  Created by Thanos on 23/01/20.
//  Copyright © 2020 Thanos. All rights reserved.
//
//

import Foundation
import CoreData


extension MoviesDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoviesDetail> {
        return NSFetchRequest<MoviesDetail>(entityName: "MoviesDetail")
    }

    @NSManaged public var adult: Bool
    @NSManaged public var backdropPath: String?
    @NSManaged public var id: Int64
    @NSManaged public var movieType: String?
    @NSManaged public var originalLanguage: String?
    @NSManaged public var originalTitle: String?
    @NSManaged public var overview: String?
    @NSManaged public var popularity: Double
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var saveDate: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var video: Bool
    @NSManaged public var voteAverage: Float
    @NSManaged public var voteCount: Int64

}
