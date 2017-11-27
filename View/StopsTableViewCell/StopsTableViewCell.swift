//
//  StopsTableViewCell.swift
//  Bongo
//
//  Created by Huangzexian on 10/22/17.
//  Copyright © 2017 Huangzexian. All rights reserved.
//

import UIKit

class StopsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var Stoptitle: UILabel!
    
    @IBOutlet weak var Stopnumber: UILabel!
    
    @IBOutlet weak var MyCardView: UIView!
    
    
    var stop:Stops! {
        didSet {
            self.updateUI()
        }
    }
    
    
    func updateUI(){
        
        
        Stoptitle.text = stop.stoptitle
        Stoptitle.font = UIFont.boldSystemFont(ofSize: 18)
        Stoptitle.adjustsFontSizeToFitWidth = true
        Stoptitle.minimumScaleFactor = 0.1
        Stopnumber.text  =  "Stop " + stop.stopnumber!
        
        MyCardView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        MyCardView.layer.masksToBounds = false
        MyCardView.layer.cornerRadius = 5.0
        MyCardView.layer.shadowOffset = CGSize(width: 0, height: 0)

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
