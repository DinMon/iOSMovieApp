//
//  MoviesController.swift
//  iOSMovieApp
//
//  Created by GUILLAUME DINYS MONVOISIN on 20/5/19.
//  Copyright © 2019 GUILLAUME DINYS MONVOISIN. All rights reserved.
//

import Foundation

class MoviesController{
    private let movieAPIKey: String = "4b2ca740a7a3bfc4ba30abef86f5d389"
    private var movies: [Movie] = []
    /// Fetch movies from an online API
    ///
    /// - Parameter url: API url of movies to fetch
    private func fetchMovies(url: String){
        
        let urlString = URL(string: url + "&api_key=" + movieAPIKey)
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let fdata = data {
                        do{
                            let decoded = try JSONDecoder().decode(MovieList.self, from: fdata)
                            self.movies = decoded.results
                            for movie in self.movies{
                                print(movie.title)
                            }
                            //self.delegate?.didFetchData(sender: self)
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    /// Fetch movies from specific query string passed
    ///
    /// - Parameter query: String parameter to determine category of movies to fetch(genres,recent,top rated)
    public func fetch(queryParam query: [String: String]){
        //TODO: upwrap dictinary query to a string URL
        
        fetchMovies(url: "https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc")
    }
}
