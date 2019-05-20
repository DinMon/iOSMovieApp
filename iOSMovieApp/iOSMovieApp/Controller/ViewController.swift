//
//  ViewController.swift
//  iOSMovieApp
//
//  Created by GUILLAUME DINYS MONVOISIN on 20/5/19.
//  Copyright © 2019 GUILLAUME DINYS MONVOISIN. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MoviesControllerDelegate, UITabBarDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var movieController: MoviesController?
    var movies = [Movie]()
    
    var refresher: UIRefreshControl!

    var filteredMovies = [Movie](){
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupRefreshControls()
        
        movieController = MoviesController()
        movieController?.delegate = self
        
        fetchData()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return filteredMovies.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        
        cell.textLabel?.text = filteredMovies[indexPath.row].title
        
        return cell
    }
    
    // MARK := Fetch from Network controller
    @objc func fetchData(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        movieController?.fetch(queryParam: [:])
    }

    // MARK := MoviesController Delegate
    
    func didFetchMovies(data: [Movie]) {
        DispatchQueue.main.async { // Make sure you're on the main thread here
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        self.movies = data
        self.filteredMovies = data
    }
    
    // MARK := UIRefreshControl
    
    func setupRefreshControls() {
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(self.fetchData), for: .valueChanged)
        tableView.insertSubview(refresher, at: 0)
    }
    
    // MARK := Tab Bar Control
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem){
        print("lol")
        switch tabBar.items?.index(of: item) {
        case 2:
            print("fac")
            //performSegue(withIdentifier: "theatreMain", sender: nil)
        default:
            print("ss")
        }
    }
}

