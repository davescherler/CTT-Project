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
    @IBOutlet weak var loadingImageIndicator: UIActivityIndicatorView!
    
    // ALEXIS: variables to store the Author info that get passed from the DisplayVC
    var contributorID = "none"
    var textForAuthorName = ""
    var textForAuthorBio = ""
    
    // ALEXIS: need to call another JSON file to retrieve the author info and create a variable to store the author Image info
    var json: NSArray?
    var dataForPic: NSData?
    var authorInfoLoaded = false

        let closeButtonIcon = UIImage(named: "Close Button White 4042.png")
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.authorName.text = textForAuthorName
            
            
            //ALEXIS: We're going to find the JSON file with the author info
            var authorURL = "http://www.closertotruth.com/api/contributor?uid=" + self.contributorID
            if let url = NSURL(string: authorURL) {
                let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                    if let jsonArray: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) {
                        self.json = jsonArray as? NSArray
                        println("AuthorInfoVC: json in viewDidLoad(). json count is now \(self.json!.count)")
                        if let jsonInfo = self.json![0] as? NSDictionary {
                            //  if let authorName = jsonInfo["contributor_name"] as? NSString {
                            //  self.textForAuthorName = authorName
                            //  }
                            if let authorBiography = jsonInfo["contributor_bio"] as? NSString as? String {
                                // The authorBiography comes from the server with <p></p> html tags which we need to remove
                                // so we're using a cleanText variable to store the cleaned up version of the biography
                                var cleanText = authorBiography.stringByReplacingOccurrencesOfString("<p>", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                                cleanText = cleanText.stringByReplacingOccurrencesOfString("</p>", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                                self.textForAuthorBio = cleanText
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
            
            // ALEXIS: Another JSON to get the author picture
            if let url = NSURL(string: authorURL) {
                let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                    if let jsonArray: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) {
                        self.json = jsonArray as? NSArray
                        println("AuthorInfoVC: json in viewDidLoad(). json count is now \(self.json!.count)")
                        if let jsonInfo = self.json![0] as? NSDictionary {
                            if let authorPictureLink = jsonInfo["contributor_image"] as? NSString {
                                let urlForImage = NSURL(string: authorPictureLink as String)
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
