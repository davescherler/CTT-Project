//
//  AuthorInfoViewController.swift
//  Menu Delegation
//
//  Created by Dave Scherler on 3/22/15.
//  Copyright (c) 2015 DaveScherler. All rights reserved.
//

import UIKit

class AuthorInfoViewController: UIViewController {

    @IBOutlet weak var authorImage: UIImageView!
    
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorBio: UITextView!
    
    @IBAction func close(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
