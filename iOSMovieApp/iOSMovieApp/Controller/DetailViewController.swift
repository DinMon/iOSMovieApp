//
//  DetailViewController.swift
//  iOSMovieApp
//
//  Created by GUILLAUME DINYS MONVOISIN on 22/5/19.
//  Copyright © 2019 GUILLAUME DINYS MONVOISIN. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var recommendations = [Movie](){
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var movieId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentInsetAdjustmentBehavior = .never
        // Do any additional setup after loading the view.
        print(movieId!)
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

}
