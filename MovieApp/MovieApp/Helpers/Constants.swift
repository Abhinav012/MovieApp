//
//  Constants.swift
//  MovieApp
//
//  Created by Thanos on 13/01/20.
//  Copyright © 2020 Thanos. All rights reserved.
//

import Foundation

let baseURL = "https://api.themoviedb.org/3/"
let apiKey = "api_key=60af9fe8e3245c53ad9c4c0af82d56d6"
let imagDwldBaseURL = "https://image.tmdb.org/t/p/w200"

enum MovieCategory: String{
    case nowPlaying = "now_playing"
    case topRated = "top_rated"
    case popular = "popular"
    case upcoming = "upcoming"
}
