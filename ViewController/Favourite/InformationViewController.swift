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
