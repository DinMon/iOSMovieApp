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
    var selectedSeat: [Int] = []
    
    let firedb = Database.database().reference()
    
    var bookingDetail: BookDetail?
    
    var numberSeatSelected: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firedb.child("Theatre").child("1").child("Seats").observe(.value) { (snapshot) in
            
            let values = snapshot.value as! [String]
            for i in 0..<values.count{
                if values[i] == "Unavailable"{
                    self.seats[i].tintColor = .red
                    self.seats[i].isEnabled = false
                }
            }
        }
        // Do any additional setup after loading the view.
        print(bookingDetail!.movieId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func seatTapped(_ sender: UIButton) {
        let tag = sender.tag
        for seat in seats{
            if seat.tag == tag{
                // seat selected
                if seat.tintColor != .orange && seat.tintColor != .red && selectedSeat.count < bookingDetail!.numOfSeat{
                    seat.tintColor = .orange
                    selectedSeat.append(seat.tag)
                }else if(seat.tintColor == .orange){
                    seat.tintColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0) // default tint
                    selectedSeat.remove(at: seat.tag - 1)
                }
            }
        }
    }
    
    @IBAction func confirmSeatBooking(_ sender: Any) {
        
        for seat in selectedSeat{
            let childUpdates = ["/Theatre/1/Seats/\(seat)": "Unavailable"]
            firedb.updateChildValues(childUpdates)
        }
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .text
        hud.label.text = "You successfully book your tickets"
        hud.customView = UIImageView(image: UIImage(named: "done"))
        
        hud.hide(animated: true, afterDelay: 1)
        let completion: MBProgressHUDCompletionBlock = { self.performSegue(withIdentifier: "returnToMainPage", sender: self) }
        hud.completionBlock = completion

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let bookingVC: BookingViewController  = segue.destination as? BookingViewController{
            bookingVC.bookDetail = bookingDetail
        }
    }
    
}
