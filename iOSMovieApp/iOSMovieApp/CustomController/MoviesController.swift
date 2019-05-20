//
//  MoviesController.swift
//  iOSMovieApp
//
//  Created by GUILLAUME DINYS MONVOISIN on 20/5/19.
//  Copyright © 2019 GUILLAUME DINYS MONVOISIN. All rights reserved.
//

import Foundation

protocol MoviesControllerDelegate{
    func didFetchMovies(data: [Movie])
}


/// Network Controller to fetch movie data from MovieDB API
class MoviesController{
    static let movieAPIKey: String = "4b2ca740a7a3bfc4ba30abef86f5d389"
    static let imgBaseString: String = "https://image.tmdb.org/t/p/"
    
    private var movies: [Movie] = []
    
    var delegate: MoviesControllerDelegate?
    
    /// Fetch movies from an online API
    ///
    /// - Parameter url: API url of movies to fetch
    private func fetchMovies(url: String){
        
        let urlString = URL(string: url + "&api_key=" + MoviesController.movieAPIKey)
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let fdata = data {
                        do{
                            let decoded = try JSONDecoder().decode(MovieList.self, from: fdata)
                            self.movies = decoded.results
                            self.delegate?.didFetchMovies(data: self.movies)
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


// MARK: - load() method to fetch image from URL when setting UIImageView
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }else{
                    DispatchQueue.main.async {
                        self?.image = UIImage(named: "placeholder")
                    }
                }
            }
        }
    }
}
