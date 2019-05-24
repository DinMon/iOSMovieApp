//
//  TopRatedViewController.swift
//  iOSMovieApp
//
//  Created by GUILLAUME DINYS MONVOISIN on 21/5/19.
//  Copyright © 2019 GUILLAUME DINYS MONVOISIN. All rights reserved.
//

import UIKit

///The Category Page to display movies in a collection view
/// Contains a container that displays a GridViewController
/// so that both theatre and top rated movies can be displayed
class TopRatedViewController: UIViewController {
    
    private var gridViewController: GridViewController?
    
    let endpoint :String = "discover/movie?sort_by=popularity.desc&"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let gridController = children.first as? GridViewController else  {
            fatalError("Check storyboard for missing GridViewController")
        }
        
        gridViewController = gridController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let gridController = destination as? GridViewController {
            self.gridViewController = gridController
            gridController.endpoint = endpoint
        }
    }
}
