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
        
        fetchData()
    }
    
    // MARK :- Fetch from Network controller
    @objc func fetchData(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        movieController?.fetch(queryParam: [:])
    }
    
    func didFetchMovies(data: [Movie]) {
        DispatchQueue.main.async { // Make sure you're on the main thread here
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        self.movies = data
        self.filteredMovies = data
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
