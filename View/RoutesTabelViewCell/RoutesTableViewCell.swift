//
//  RoutesTableViewCell.swift
//  Bongo
//
//  Created by Huangzexian on 10/21/17.
//  Copyright © 2017 Huangzexian. All rights reserved.
//

import UIKit

class RoutesTableViewCell: UITableViewCell
{    
    var route: Routes! {
        didSet {
            self.updateUI()
        }
    }

    @IBOutlet weak var CardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    
    func updateUI()
    {
        CardView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        CardView.layer.masksToBounds = false
        CardView.layer.cornerRadius = 5.0
        CardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        titleLabel.text = route.name
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.1
   
        if (route.agencyName == "Cambus")
        {
            ImageView.image = UIImage(named: "bus-stop (1)")
        }
        else if route.agencyName == "Iowa City Transit"
        {
            ImageView.image = UIImage(named: "bus-stop (2)")
        }
        else if route.agencyName == "Coraville Transit"
        {
            ImageView.image = UIImage(named: "bus-stop-1")
        }
    }
}
