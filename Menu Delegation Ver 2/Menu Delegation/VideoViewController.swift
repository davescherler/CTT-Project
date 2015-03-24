//
//  VideoViewController.swift
//  Menu Delegation
//
//  Created by Dave Scherler on 3/22/15.
//  Copyright (c) 2015 DaveScherler. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var videoView: UIWebView!
    @IBOutlet weak var videoTitle: UILabel!
    
    @IBAction func dismissVideoVC(sender: UIButton!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var loadingVideoIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoView.delegate = self
        //update this URL based on selection. 
        if let url = NSURL(string: "https://www.youtube.com/embed/5ZtRfACbygY") {
            let request = NSURLRequest(URL: url)
            self.videoView.loadRequest(request)
            
            
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        println("the video has finished loading")
        self.loadingVideoIndicator.stopAnimating()
        self.loadingVideoIndicator.hidden = true
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
