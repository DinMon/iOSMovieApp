//
//  RemoveMovieTableViewCell.swift
//  iOSMovieApp
//
//  Created by GUILLAUME DINYS MONVOISIN on 22/5/19.
//  Copyright © 2019 GUILLAUME DINYS MONVOISIN. All rights reserved.
//

import UIKit

/// Define the table cell for a favourite movies in a table view in FavouriteViewController
class RemoveMovieTableViewCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var movieImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
