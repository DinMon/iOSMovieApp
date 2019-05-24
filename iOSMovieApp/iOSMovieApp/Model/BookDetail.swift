//
//  BookDetail.swift
//  iOSMovieApp
//
//  Created by GUILLAUME DINYS MONVOISIN on 23/5/19.
//  Copyright © 2019 GUILLAUME DINYS MONVOISIN. All rights reserved.
//

import Foundation

enum Day:Int{
    case Thu = 0, Fri = 1, Sat = 2, Sun = 3
}


/// Describe the details of a booking
struct BookDetail{
    var movieId: Int
    var day: Day
    var timeSlot: Double
    var totalPrice: Double
    var theatre: Theatre?
    var seats: [String]?
    var numOfSeat: Int
    
    init(movieId: Int,day: Day, timeSlot: Double, totalPrice: Double, theatre: Theatre, numOfSeat: Int,seats: [String]){
        self.movieId = movieId
        self.day = day
        self.timeSlot = timeSlot
        self.totalPrice = totalPrice
        self.theatre = theatre
        self.seats = seats
        self.numOfSeat = numOfSeat
    }
}
