//
//  ViewController.swift
//  iOSMovieApp
//
//  Created by GUILLAUME DINYS MONVOISIN on 20/5/19.
//  Copyright © 2019 GUILLAUME DINYS MONVOISIN. All rights reserved.
//

import UIKit
import Foundation

/// The Main Page containing a TableView
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MoviesControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movieController: MoviesController?
    
    // Contains movies fetch from the API
    var movies = [Movie]()
    
    var refresher: UIRefreshControl!

    
    /// Contains the movies with conditions(filter)
    var filteredMovies = [Movie](){
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupRefreshControls()
        self.tableView.tableFooterView = UIView() // hack to remove empty separator from tableview
        
        movieController = MoviesController()
        movieController?.delegate = self
        
        fetchData(endpoint: "movie/upcoming?")
    }
    
     // MARK :- Table View
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return filteredMovies.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        
        let movie: Movie = filteredMovies[indexPath.row]
        
        cell.title!.text = movie.title
        
        cell.releaseDate!.text = movie.releaseDate!.components(separatedBy: "-")[0]
        
        cell.rating!.text = String(movie.voteAverage!)
        
        cell.movieImage!.load(url: movie.posterImageURLMedium!)
        
        cell.overview!.text = movie.overview
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailMovie", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailController: DetailViewController = segue.destination as? DetailViewController{
            if let index = sender as? Int{
                detailController.movieId = movies[index].id
            }
        }
    }
    
    // MARK :- Fetch from Network controller
    
    @objc func fetchData(endpoint: String){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        movieController?.fetch(endpoint: endpoint)
    }

    // MARK :- MoviesController Delegate
    
    func didFetchMovies(data: [Movie]) {
        DispatchQueue.main.async { // Make sure you're on the main thread here
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        self.movies = data
        self.filteredMovies = data
    }
    
    func didFetchMovie(data: MovieDetail) {
        // Do not use movie detail
    }
    
    // MARK :- UIRefreshControl
    
    func setupRefreshControls() {
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(self.fetchData), for: .valueChanged)
        tableView.insertSubview(refresher, at: 0)
    }
    
    // MARK :- Search bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovies = searchText.isEmpty ? movies:movies.filter {($0.title).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        filteredMovies = movies
        searchBar.resignFirstResponder()
    }
}

