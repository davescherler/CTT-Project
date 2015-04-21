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
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorBio: UITextView!
    
    // ALEXIS: variables to store the Author info that get passed from the DisplayVC
    var contributorID = "none"
    var textForAuthorName = ""
    var textForAuthorBio = ""
    
    // ALEXIS: need to call another JSON file to retrieve the author info
    var json: NSArray?

        let closeButtonIcon = UIImage(named: "Close Button White 4042.png")
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.authorName.text = textForAuthorName
            
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
