//
//  SeatViewController.swift
//  iOSMovieApp
//
//  Created by GUILLAUME DINYS MONVOISIN on 23/5/19.
//  Copyright © 2019 GUILLAUME DINYS MONVOISIN. All rights reserved.
//

import UIKit

class SeatViewController: UIViewController {

    var bookingDetail: BookDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(bookingDetail!.movieId)
    }

}
