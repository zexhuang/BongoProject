//
//  StopsPredictionTableViewCell.swift
//  Bongo
//
//  Created by Huangzexian on 10/31/17.
//  Copyright © 2017 Huangzexian. All rights reserved.
//

import UIKit

class StopsPredictionTableViewCell: UITableViewCell
{
    @IBOutlet weak var StopPrediction: UILabel!
    @IBOutlet weak var RouteName: UILabel!
    @IBOutlet weak var AgencyImage: UIImageView!
    
    var stopsInfo:StopsInfo!
    {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        if (String(describing: stopsInfo.Prediction!) == "0"){
            
            StopPrediction.text = "Arriving"
            StopPrediction.font =  UIFont.boldSystemFont(ofSize: 18)
        }
        else if (String(describing: stopsInfo.Prediction!)=="999"){
            
            StopPrediction.text = " "
        }
            
        else
        {
            StopPrediction.text = String (describing: stopsInfo.Prediction!) + " min"
            StopPrediction.font =  UIFont.boldSystemFont(ofSize: 18)
        }
        
        
        if (stopsInfo.Agency == "iowa-city")
        {
            AgencyImage.image = UIImage(named: "bus-stop (2)")
        }
        else if (stopsInfo.Agency == "uiowa")
        {
            AgencyImage.image = UIImage(named: "bus-stop (1)")
        }
            
        else if (stopsInfo.Agency == "No Agency Running")
        {
            AgencyImage.image = nil
        }
        else
        {
            AgencyImage.image = UIImage(named: "bus-stop-1")
        }
        
        RouteName.text = stopsInfo.RouteName
        RouteName.font =  UIFont.boldSystemFont(ofSize: 18)
        RouteName.adjustsFontSizeToFitWidth = true
        RouteName.minimumScaleFactor = 0.1
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }

}
