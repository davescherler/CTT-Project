//
//  AuthorInfoViewController.swift
//  CloserToTruth
//
//  Created by Dave Scherler on 4/17/15.
//  Copyright (c) 2015 DaveScherler. All rights reserved.
//

import UIKit

class AuthorInfoViewController: UIViewController {


    @IBOutlet weak var closeButton: UIBarButtonItem!

        let closeButtonIcon = UIImage(named: "Close Button White 4042.png")
        
        override func viewDidLoad() {
            super.viewDidLoad()
            makeNavigationBarCloseButton()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
        
        @IBAction func closeButtonPressed(sender: AnyObject) {
            dismissViewControllerAnimated(true, completion: nil)
        }
        
    func makeNavigationBarCloseButton() {
        self.closeButton.image = closeButtonIcon
        self.closeButton.tintColor = UIColor.whiteColor()
    }

}
