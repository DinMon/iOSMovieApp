//
//  GridViewController.swift
//  iOSMovieApp
//
//  Created by GUILLAUME DINYS MONVOISIN on 21/5/19.
//  Copyright © 2019 GUILLAUME DINYS MONVOISIN. All rights reserved.
//

import UIKit

class GridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MoviesControllerDelegate {
    
    
    

    @IBOutlet weak var collectionView: UICollectionView!
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as! MovieCollectionViewCell
        
        let movie: Movie = filteredMovies[indexPath.row]
        
        cell.movieImage!.load(url: movie.posterImageURLMedium!)
        
        return cell
    }
    
    func setupCollectionViewLayout(){
        let width = self.view.frame.size.width/3
        let layout: UICollectionViewFlowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width - 5, height: width - 5)
        
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
    }

}
