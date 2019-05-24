//
//  FavouriteController.swift
//  iOSMovieApp
//
//  Created by GUILLAUME DINYS MONVOISIN on 23/5/19.
//  Copyright © 2019 GUILLAUME DINYS MONVOISIN. All rights reserved.
//

import Foundation

/// FavouriteController abstract the interaction between the VC and the json file controller
class FavouriteController{
    static let shared = FavouriteController()
    
    private let fileManipulator: MovieFileSaver?
    
    init(){
        fileManipulator = MovieFileSaver()
    }
    
    func requestForFavourites(sender: Any?){
        fileManipulator?.delegate = sender as? MovieFileSaverDelegate
        fileManipulator?.loadJson(filename: "movies")
    }
    
    func saveFavourites(sender: Any?, data: Data){
        fileManipulator?.delegate = sender as? MovieFileSaverDelegate
        fileManipulator?.saveJsonToFile(filename: "movies", data: data)
    }
    
    func saveSingleFavourite(sender: Any?, movie: Movie){
        fileManipulator?.delegate = sender as? MovieFileSaverDelegate
        fileManipulator?.appendJsonFile(filename: "movies", movie: movie)
    }
    
    func removeSingleFavourite(sender: Any?, id: Int){
        fileManipulator?.delegate = sender as? MovieFileSaverDelegate
        fileManipulator?.removeFromJsonFile(filename: "movies", id: id)
    }
}
