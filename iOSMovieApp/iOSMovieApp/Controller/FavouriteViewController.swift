//
//  FavouriteViewController.swift
//  iOSMovieApp
//
//  Created by GUILLAUME DINYS MONVOISIN on 22/5/19.
//  Copyright © 2019 GUILLAUME DINYS MONVOISIN. All rights reserved.
//

import UIKit

class FavouriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,MovieFileSaverDelegate {
    func didRemoveMovie() {
        //do nothing
    }
    
    func didAppendMovie() {
        // Do nothing
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noFavourite: UIView!
    
    var movies = [Movie](){
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if self.movies.count == 0{
                    self.tableView.backgroundView = self.noFavourite
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        fetchMovieFile()
        
        self.tableView.tableFooterView = UIView() // hack to remove empty separator from tableview
    }
    
    func fetchMovieFile(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        FavouriteController.shared.requestForFavourites(sender: self)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return movies.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "removeCell", for: indexPath) as! RemoveMovieTableViewCell
        
        let movie: Movie = movies[indexPath.row]
        
        cell.title!.text = movie.title
        
        cell.movieImg!.load(url: movie.posterImageURLMedium!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        let share = shareAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete,share])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.movies.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            //TODO: Update the local json file in a background thread

            DispatchQueue.global(qos: .utility).async {
                // encode
                do {
                    let jsonEncoder = JSONEncoder()
                    let jsonData = try jsonEncoder.encode(self.movies)
                    FavouriteController.shared.saveFavourites(sender: self, data: jsonData)
                } catch let error{
                    print(error.localizedDescription)
                }
                
            }
            
            completion(true)
        }
        action.image = UIImage(named: "delete")
        
        return action
    }
    
    func shareAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Share") { (action, view, completion) in
            let activityVC = UIActivityViewController(activityItems: ["#FavouriteMovie \(self.movies[indexPath.row])"], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            
            self.present(activityVC, animated: true, completion: nil)
        }
        action.backgroundColor = .gray
        
        return action
    }
    
    func didFetchMovies(data: [Movie]) {
        DispatchQueue.main.async { // Make sure you're on the main thread here
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        self.movies = data
    }
    
}
