//
//  AuthorInfoViewController.swift
//  Menu Delegation
//
//  Created by Dave Scherler on 3/22/15.
//  Copyright (c) 2015 DaveScherler. All rights reserved.
//

import UIKit

class AuthorInfoViewController: UIViewController {
    var contributorID = "none"
    var json: NSArray?
    var textForAuthorName = ""
    var textForAuthorBio = ""
    var dataForPic: NSData?
    var authorInfoLoaded = false

    @IBOutlet weak var authorImage: UIImageView!
    
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorBio: UITextView!
    
    @IBAction func close(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var loadingImageIndicator: UIActivityIndicatorView!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.authorName.text = self.textForAuthorName
        
        //We're going to find the JSON file with the author info
        var authorURL = "http://www.closertotruth.com/api/contributor?uid=" + self.contributorID
        if let url = NSURL(string: authorURL) {
            println("AuthorInfoVC: the json for the author exist")
            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                if let jsonArray: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) {
                    self.json = jsonArray as? NSArray
                    println("AuthorInfoVC: json in viewDidLoad(). json count is now \(self.json!.count)")
                    if let jsonInfo = self.json![0] as? NSDictionary {
//                        if let authorName = jsonInfo["contributor_name"] as? NSString {
//                            self.textForAuthorName = authorName
//                        }
                    if let authorBiography = jsonInfo["contributor_bio"] as? NSString {
                        self.textForAuthorBio = authorBiography
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // IMPORTANT we need to reload the data we got into our table view
//                    self.authorName.text = self.textForAuthorName
                    self.authorBio.text = self.textForAuthorBio
                    println("doing thread for displaying info text")
                })
            })
            task.resume()
            
        }
        
        
        
        if let url = NSURL(string: authorURL) {
            println("AuthorInfoVC: the json for the author exist")
            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                if let jsonArray: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) {
                    self.json = jsonArray as? NSArray
                    println("AuthorInfoVC: json in viewDidLoad(). json count is now \(self.json!.count)")
                    if let jsonInfo = self.json![0] as? NSDictionary {
                        if let authorPictureLink = jsonInfo["contributor_image"] as? NSString {
                            let urlForImage = NSURL(string: authorPictureLink)
                            self.dataForPic = NSData(contentsOfURL: urlForImage!)
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // IMPORTANT we need to reload the data we got into our table view
                    self.loadingImageIndicator.stopAnimating()
                    self.loadingImageIndicator.hidden = true
                    self.authorImage.image = UIImage(data: self.dataForPic!)
                    println("doing thread for loading the picture")
                })
            })
            task.resume()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
