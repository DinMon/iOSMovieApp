//
//  DetailViewController.swift
//  iOSMovieApp
//
//  Created by GUILLAUME DINYS MONVOISIN on 22/5/19.
//  Copyright © 2019 GUILLAUME DINYS MONVOISIN. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, MoviesControllerDelegate {
    
    var movieController: MoviesController?
    var movieId: Int?
    var movieDetail: MovieDetail?
    
    // Header and ScrollView
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mainStackView: UIStackView!
    
    // Section 1: Main Detail and Action
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var runtime: UILabel!
    
    @IBOutlet weak var trailerBtn: UIButton!
    @IBOutlet weak var bookBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    
    // Section 2: Description and info
    
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var movieDesc: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var actors: UILabel!
    @IBOutlet weak var countryName: UILabel!
    
    // Recommendations
    @IBOutlet weak var collectionView: UICollectionView!
    
    var recommendations = [Movie](){
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentInsetAdjustmentBehavior = .never
        // Do any additional setup after loading the view.
        print(movieId!)
        
        movieController = MoviesController()
        movieController?.delegate = self
        
        movieController?.fetchMovie(id: movieId!)
    }
    
    func updateUIMovieDetail(){
        updateMainSection()
        updateDetailSection()
    }
    
    func updateMainSection(){
        mainTitle!.text = movieDetail!.title
        rating!.text = String(movieDetail!.voteAverage)
        let minutes = movieDetail!.runtime
        let time = (minutes / 60, (minutes % 60))
        runtime!.text = String("\(time.0) h \(time.1)")
        posterImage!.load(url: URL(string: MoviesController.imgBaseString + "w500" + movieDetail!.posterPath)!)
        imageView!.load(url: URL(string: MoviesController.imgBaseString + "w500" + movieDetail!.backdropPath)!)
    }
    
    func updateDetailSection(){
        genre!.text = movieDetail!.genres.map{$0.name}.joined(separator: ",")
        movieDesc!.text = movieDetail!.overview
        companyName!.text = movieDetail!.productionCompanies.map{$0.name}.joined(separator: ", ")
        actors!.text = movieDetail!.credits.cast.map{$0.name}[0..<5].joined(separator: ", ")
        countryName!.text = movieDetail!.productionCountries.first?.name
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = -scrollView.contentOffset.y + 350 // should be a bit than 300
        let height = min(max(y, 80), 300)
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
        
        
        let gapBtwHeader :CGFloat = 18.0
        mainStackView.frame = CGRect(x: mainStackView.frame.origin.x, y: height + gapBtwHeader, width: mainStackView.frame.width, height: mainStackView.frame.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendCell", for: indexPath) as! RecommendationCollectionViewCell
        
        //let movie: Movie = recommendations[indexPath.row]
        
        //cell.movieImage!.load(url: movie.posterImageURLMedium!)
        
        cell.recommendImage!.image = UIImage(named: "poster")
        cell.movieTitle!.text = "Dinys"
        
        return cell
    }

    func didFetchMovies(data: [Movie]) {
        // Do being use
    }
    
    func didFetchMovie(data: MovieDetail) {
        self.movieDetail = data
        DispatchQueue.main.async {
            self.updateUIMovieDetail()
        }
    }
}
