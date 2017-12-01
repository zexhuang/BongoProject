//
//  InformationViewController.swift
//  Bongo
//
//  Created by Brian Schweer on 11/28/17.
//  Copyright © 2017 Brian Schweer. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 0 , y: 0, width: self.view.frame.size.width , height: self.view.frame.size.height))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.95, 0.95, 0.95, 0.95])

        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 5.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        
        self.view.addSubview(whiteRoundedView)
        self.view.sendSubview(toBack: whiteRoundedView)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
