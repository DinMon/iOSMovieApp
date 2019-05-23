//
//  SeatViewController.swift
//  iOSMovieApp
//
//  Created by GUILLAUME DINYS MONVOISIN on 23/5/19.
//  Copyright © 2019 GUILLAUME DINYS MONVOISIN. All rights reserved.
//

import UIKit
import Firebase

class SeatViewController: UIViewController {

    @IBOutlet var seats: [UIButton]!
    
    let firedb = Database.database().reference()
    
    var bookingDetail: BookDetail?
    
    var numberSeatSelected: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var count = 0
        firedb.child("Theatre").child("1").child("Seats").observe(.value) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            let username = value?["1"] as? String ?? ""
            print(username)
        
        }
        // Do any additional setup after loading the view.
        print(bookingDetail!.movieId)
    }
    
    @IBAction func seatTapped(_ sender: UIButton) {
        if  numberSeatSelected < bookingDetail!.numOfSeat{
            let tag = sender.tag
            for seat in seats{
                if seat.tag == tag{
                    // seat selected
                    if seat.tintColor != .orange && seat.tintColor != .red{
                        seat.tintColor = .orange
                        numberSeatSelected += 1
                    }else if(seat.tintColor == .orange){
                        seat.tintColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0) // default tint
                        numberSeatSelected -= 1
                    }
                    
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let bookingVC: BookingViewController  = segue.destination as? BookingViewController{
            bookingVC.bookDetail = bookingDetail
        }
    }
    
}
