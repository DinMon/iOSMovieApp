//
//  BookingViewController.swift
//  iOSMovieApp
//
//  Created by GUILLAUME DINYS MONVOISIN on 23/5/19.
//  Copyright © 2019 GUILLAUME DINYS MONVOISIN. All rights reserved.
//

import UIKit

class BookingViewController: UIViewController, UITextFieldDelegate {

    var movieId: Int?
    var bookDetail: BookDetail?
    var totalAmount: Double = 0.0
    
    @IBOutlet weak var textBox: UITextField!

    @IBOutlet weak var totalPrice: UILabel!
    
    @IBOutlet weak var daySeg: UISegmentedControl!
    
    @IBOutlet weak var timeSeg: UISegmentedControl!
    
    private let ticketPrice: Double = 15.00;
    override func viewDidLoad() {
        super.viewDidLoad()

        totalPrice.text = String("$0.0")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backToDetail(_ sender: Any) {
        performSegue(withIdentifier: "backToDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC: DetailViewController  = segue.destination as? DetailViewController{
            detailVC.movieId = movieId!
        } else if let seatVC: SeatViewController  = segue.destination as? SeatViewController{
            var time : Double
            switch timeSeg.selectedSegmentIndex {
            case 0:
                time = 3.00
            case 1:
                time = 6.00
            case 2:
                time = 8.00
            default:
                time = 0.0
            }
            
            bookDetail = BookDetail(movieId: self.movieId!,day: Day(rawValue: daySeg.selectedSegmentIndex)!, timeSlot: time, totalPrice: totalAmount, theatre: Theatre(), seats: [])
            seatVC.bookingDetail = bookDetail
        }
    }
    
    @IBAction func bookSeat(_ sender: Any) {
        performSegue(withIdentifier: "seatBook", sender: self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateTotalAmount(textfield: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       updateTotalAmount(textfield: textField)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let length = (textField.text?.count)! + string.count
        if length > 2{
            return false
        }else{
            return true
        }
    }
    
    @IBAction func updateTotalPrice(_ sender: Any) {
        updateTotalAmount(textfield: sender)
    }
    
    func updateTotalAmount(textfield: Any){
        if let priceField = textfield as? UITextField{
            guard let number = Int(priceField.text!) else{
                // display invalid msg
                return
            }
            totalAmount = Double(number) * 15.00
            totalPrice!.text = String("$\(totalAmount)")
        }
    }
}
