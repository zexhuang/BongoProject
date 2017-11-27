//
//  RouteInfoTableViewCell.swift
//  Bongo
//
//  Created by Huangzexian on 11/7/17.
//  Copyright © 2017 Huangzexian. All rights reserved.
//

import UIKit

class RouteInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var StopTitle: UILabel!
    @IBOutlet weak var StopNumber: UILabel!
    @IBOutlet weak var CardView: UIView!
    
    
    var stop:Stops! {
        didSet {
            self.updateUI()
        }
    }
    
    
    func updateUI(){
        

        
        StopTitle.text = stop.stoptitle
        StopTitle.font = UIFont.boldSystemFont(ofSize: 18)
        StopTitle.adjustsFontSizeToFitWidth = true
        StopTitle.minimumScaleFactor = 0.1
        StopNumber.text  =  "Stop " + stop.stopnumber!
        
        CardView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:0.95)
        CardView.layer.masksToBounds = false
        CardView.layer.cornerRadius = 5.0
        CardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
