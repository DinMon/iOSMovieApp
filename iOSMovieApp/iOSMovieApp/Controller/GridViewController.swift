//
//  GridViewController.swift
//  iOSMovieApp
//
//  Created by GUILLAUME DINYS MONVOISIN on 21/5/19.
//  Copyright © 2019 GUILLAUME DINYS MONVOISIN. All rights reserved.
//

import UIKit

class GridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, MoviesControllerDelegate {
    
    
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var endpoint: String = ""
    
    var movieController: MoviesController?
    var movies = [Movie]()
    
    var filteredMovies = [Movie](){
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewLayout()
        
        movieController = MoviesController()
        movieController?.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        fetchData(endpoint: self.endpoint)//"discover/movie?sort_by=popularity.desc&")
    }
    
    // MARK :- Disable Navigation Bar before going to Detail Page
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK :- Fetch from Network controller
    @objc func fetchData(endpoint: String){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        movieController?.fetch(endpoint: endpoint)
    }
    
    func didFetchMovies(data: [Movie]) {
        DispatchQueue.main.async { // Make sure you're on the main thread here
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        self.movies = data
        self.filteredMovies = data
    }
    
    func didFetchMovie(data: MovieDetail) {
        // Do not use MovieDetail
    }
    
    // MARK :- CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as! MovieCollectionViewCell
        
        let movie: Movie = filteredMovies[indexPath.row]
        
        cell.movieImage!.load(url: movie.posterImageURLMedium!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailController: DetailViewController = segue.destination as? DetailViewController{
            if let index = sender as? Int{
                detailController.movieId = movies[index].id
            }
        }
    }
    
    
    /// Defining the small details of the collectionviewcell
    func setupCollectionViewLayout(){
        let width = self.view.frame.size.width/3
        let layout: UICollectionViewFlowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width - 5, height: width - 5)
        
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
    }

    // Mark :- SearchBar delegate
    
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
