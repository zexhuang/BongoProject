//
//  MyTabBarViewController.swift
//  Bongo
//
//  Created by Huangzexian on 10/20/17.
//  Copyright © 2017 Huangzexian. All rights reserved.
//

import Foundation
import UIKit

class MyTabBarViewController:UITabBarController{
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.tabBar.barTintColor =  UIColor(red:37.0/255.0, green: 39.0/255.0, blue:42.0/255.0, alpha: 1.0)
        
        self.tabBar.tintColor = UIColor.white
        
        self.tabBar.isTranslucent = false
        
        tabBar.reloadInputViews()
        
        
    }
    
    override func viewWillLayoutSubviews() {
    
           var tabFrame = self.tabBar.frame
           tabFrame.size.height = 45
           tabFrame.origin.y = self.view.frame.size.height - 45
           self.tabBar.frame = tabFrame
        
        
    }
}
