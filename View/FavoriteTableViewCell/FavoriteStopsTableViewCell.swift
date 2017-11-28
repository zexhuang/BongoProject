
//
//  FavoriteStopsTableViewCell.swift
//  Bongo
//
//  Created by Huangzexian on 11/22/17.
//  Copyright © 2017 The University of Iowa (CTS). All rights reserved.
//

import Foundation
import UIKit

class FavoriteStopsTableViewCell: UITableViewCell{
    
    @IBOutlet weak var StopTitle: UILabel!
    @IBOutlet weak var StopNumber: UILabel!

//    @IBOutlet weak var background: UIView!
    
//
//    @IBOutlet weak var MyBackgroundCardView: UIView!
    
    var stop:Stops! {
        didSet {
            self.updateUI()
        }
    }
    
    
    func updateUI(){
        
//        background.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
//        background.layer.masksToBounds = false
//        background.layer.cornerRadius = 5.0
//        background.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        
        StopTitle.text = stop.stoptitle
        StopTitle.font = UIFont.boldSystemFont(ofSize: 18)
        StopTitle.adjustsFontSizeToFitWidth = true
        StopTitle.minimumScaleFactor = 0.1
        StopNumber.text  =  "Stop " + stop.stopnumber!
        
        
    }

    
    
    
}
