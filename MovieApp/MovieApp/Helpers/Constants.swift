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
var day = ""
var monthOfYear = ""

enum MovieCategory: String{
    case nowPlaying = "now_playing"
    case topRated = "top_rated"
    case popular = "popular"
    case upcoming = "upcoming"
}

enum WeekDay: Int{
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
}

enum Month: Int{
    case jan = 1
    case feb = 2
    case mar = 3
    case apr = 4
    case may = 5
    case jun = 6
    case jul = 7
    case aug = 8
    case sep = 9
    case oct = 10
    case nov = 11
    case dec = 12
}

func setDayAndmonthOfYear(weekday: WeekDay, month: Month){
    switch(weekday){
        
    case .sunday:
        day = "SUNDAY"
    case .monday:
        day = "MONDAY"
    case .tuesday:
        day = "TUESDAY"
    case .wednesday:
        day = "WEDNESDAY"
    case .thursday:
        day = "THURSDAY"
    case .friday:
        day = "FRIDAY"
    case .saturday:
        day = "SATURDAY"
    }
    
    switch(month){
    case .jan :
        monthOfYear = "JANUARY"
    case .feb :
        monthOfYear = "FEBRUARY"
    case .mar :
        monthOfYear = "MARCH"
    case .apr :
        monthOfYear = "APRIL"
    case .may :
        monthOfYear = "MAY"
    case .jun :
        monthOfYear = "JUNE"
    case .jul :
        monthOfYear = "JULY"
    case .aug :
        monthOfYear = "AUGUST"
    case .sep :
        monthOfYear = "SEPTEMBER"
    case .oct :
        monthOfYear = "OCTOBER"
    case .nov :
        monthOfYear = "NOVEMBER"
    case .dec :
        monthOfYear = "DECEMBER"
    }
}
