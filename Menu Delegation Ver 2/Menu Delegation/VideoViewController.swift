//
//  VideoViewController.swift
//  Menu Delegation
//
//  Created by Dave Scherler on 3/22/15.
//  Copyright (c) 2015 DaveScherler. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController {

    @IBOutlet weak var videoView: UIWebView!
    @IBOutlet weak var videoTitle: UILabel!
    
    @IBAction func dismissVideoVC(sender: UIButton!) {
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //update this URL based on selection. 
        if let url = NSURL(string: "https://www.youtube.com/embed/5ZtRfACbygY") {
            let request = NSURLRequest(URL: url)
            self.videoView.loadRequest(request)
        }
    }

     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
