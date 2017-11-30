//
//  FavoriteRoutesTableViewCell.swift
//  Bongo
//
//  Created by Huangzexian on 11/22/17.
//  Copyright © 2017 The University of Iowa (CTS). All rights reserved.
//

import Foundation

import UIKit

class FavoriteRoutesTableViewCell: UITableViewCell{
    
    
    @IBOutlet weak var RouteName: UILabel!
    
    @IBOutlet weak var RouteImage: UIImageView!
    
    @IBOutlet weak var MyBackgroundCardView: UIView!
    
    var route: Routes! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        MyBackgroundCardView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        MyBackgroundCardView.layer.masksToBounds = false
        MyBackgroundCardView.layer.cornerRadius = 5.0
        MyBackgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        
        RouteName.text = route.name
        RouteName.font = UIFont.boldSystemFont(ofSize: 18)
        RouteName.adjustsFontSizeToFitWidth = true
        RouteName.minimumScaleFactor = 0.1
        
        if (route.agencyName == "Cambus")
        {
            RouteImage.image = UIImage(named: "bus-stop (1)")
        }
        else if route.agencyName == "Coralville Transit"
        {
            RouteImage.image = UIImage(named: "bus-stop-1")
        }
        else
        {
            RouteImage.image = UIImage(named: "bus-stop (2)")
        }
    }
}
