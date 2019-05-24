//
//  DetailViewController.swift
//  iOSMovieApp
//
//  Created by GUILLAUME DINYS MONVOISIN on 22/5/19.
//  Copyright © 2019 GUILLAUME DINYS MONVOISIN. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, MoviesControllerDelegate,MovieFileSaverDelegate {
    
    
    
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
    
    // Section 2: Description and info
    
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var movieDesc: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var actors: UILabel!
    @IBOutlet weak var countryName: UILabel!
    
    // Recommendations
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var favBtn: UIButton!
    
    var recommendations = [RecommendationsResult](){
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let bookingVC: BookingViewController = segue.destination as? BookingViewController{
            bookingVC.movieId = movieId!
        }
    }
    
    ///Load trailer to the default browser
    @IBAction func loadTrailer(_ sender: Any) {
        let myUrl = "https://www.youtube.com/watch?v=\(String(describing: movieDetail!.videos!.results.first!.key))"
        print(myUrl)
        if let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        // or outside scope use this
        guard let url = URL(string: "\(myUrl)"), !url.absoluteString.isEmpty else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    ///Deals with adding and removing of movie to favourite list (NOT ONLY ADDING)
    @IBAction func addFavourite(_ sender: Any) {
        if favBtn.titleLabel!.text == "Add Favourite"{
            if let movieRead = movieDetail{
                let movie : Movie = Movie(id: movieRead.id!, title: movieRead.title!, posterPath: movieRead.posterPath!)
                FavouriteController.shared.saveSingleFavourite(sender: self, movie: movie)
            }else{
                print("Cannot add movie to favourite")
            }
        }else if favBtn.titleLabel!.text == "Remove Favourite"{
            if let movieRead = movieDetail{
                FavouriteController.shared.removeSingleFavourite(sender: self, id: movieRead.id!)
            }else{
                print("Cannot remove movie to favourite")
            }
        }
    }
    
    // MARK :- Updating the UI elements content
    
    func updateUIMovieDetail(){
        updateMainSection()
        updateDetailSection()
    }
    
    func updateMainSection(){
        mainTitle!.text = movieDetail!.title!
        rating!.text = String(movieDetail!.voteAverage!)
        let minutes = movieDetail!.runtime!
        let time = (minutes / 60, (minutes % 60))
        runtime!.text = String("\(time.0) h \(time.1)")
        posterImage!.load(url: URL(string: MoviesController.imgBaseString + "w500" + movieDetail!.posterPath!)!)
        imageView!.load(url: URL(string: MoviesController.imgBaseString + "w500" + movieDetail!.backdropPath!)!)
    }
    
    func updateDetailSection(){
        genre!.text = movieDetail!.genres!.map{$0.name}.joined(separator: ",")
        movieDesc!.text = movieDetail!.overview
        companyName!.text = movieDetail!.productionCompanies!.map{$0.name}[0]
        actors!.text = movieDetail!.credits!.cast.map{$0.name}[0...2].joined(separator: ", ")
        countryName!.text = movieDetail!.productionCountries!.first?.name
    }
    
    // MARK :- Shortening and lengthening the top image when user scroll
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = -scrollView.contentOffset.y + 350 // should be a bit than 300
        let height = min(max(y, 80), 300)
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
        
        
        let gapBtwHeader :CGFloat = 18.0
        mainStackView.frame = CGRect(x: mainStackView.frame.origin.x, y: height + gapBtwHeader, width: mainStackView.frame.width, height: mainStackView.frame.height)
        
    }
    
    // MARK :- CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendCell", for: indexPath) as! RecommendationCollectionViewCell
        
        let movie: RecommendationsResult = recommendations[indexPath.row]
        
        cell.recommendImage!.load(url: URL(string: MoviesController.imgBaseString + "w500" + movie.posterPath)!)
        cell.movieTitle!.text = movie.title
        
        return cell
    }

    
    /// Updating the state of Favourite button from local favourite save in json file (inside Document directory)
    ///
    /// - Parameter data: favourite movies
    func didFetchMovies(data: [Movie]) {
        if data.contains(where: { movie in movie.id == movieDetail!.id }) {
            changeBtnToRemove()
        }
    }
    
    
    /// Updating the movie details for UI in DetailVC
    ///
    /// - Parameter data: Single movie detail
    func didFetchMovie(data: MovieDetail) {
        self.movieDetail = data
        FavouriteController.shared.requestForFavourites(sender: self)
        self.recommendations = (data.recommendations?.results)!
        DispatchQueue.main.async {
            self.updateUIMovieDetail()
        }
    }
    
    // MARK :- Favourite button state change
    func changeBtnToRemove(){
        DispatchQueue.main.async {
            self.favBtn.setTitle("Remove Favourite", for: .normal)
            self.favBtn.setTitleColor(.red, for: .normal)
        }
    }
    
    func changeBtnToFavourite(){
        DispatchQueue.main.async {
            self.favBtn.setTitle("Add Favourite", for: .normal)
            self.favBtn.setTitleColor(.green, for: .normal)
        }
    }
    
    
    func didAppendMovie() {
        changeBtnToRemove()
    }
    
    func didRemoveMovie() {
        changeBtnToFavourite()
    }
}
