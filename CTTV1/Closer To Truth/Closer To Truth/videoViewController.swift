//
//  videoViewController.swift
//  Closer To Truth
//
//  Created by Alexis Saint-Jean on 3/14/15.
//  Copyright (c) 2015 Alexis Saint-Jean. All rights reserved.
//

import UIKit

class videoViewController: ViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBAction func returnToQuoteVC(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = NSURL(string: "http:www.closertotruth.com/series/how-did-our-universe-begin") {
            let request = NSURLRequest(URL: url)
            self.webView.loadRequest(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
