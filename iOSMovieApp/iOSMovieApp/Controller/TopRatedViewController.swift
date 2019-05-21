//
//  TopRatedViewController.swift
//  iOSMovieApp
//
//  Created by GUILLAUME DINYS MONVOISIN on 21/5/19.
//  Copyright © 2019 GUILLAUME DINYS MONVOISIN. All rights reserved.
//

import UIKit

class TopRatedViewController: UIViewController {
    
    private var gridViewController: GridViewController?
    
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
        }
    }
}
