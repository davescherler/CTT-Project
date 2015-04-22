//
//  DisplayViewController.swift
//  CloserToTruth
//
//  Created by Dave Scherler on 4/15/15.
//  Copyright (c) 2015 DaveScherler. All rights reserved.
//

import UIKit

@objc
protocol DisplayViewControllerDelegate {
    optional func toggleMenu()
}

class DisplayViewController: UIViewController {

    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var termName: UILabel!
    @IBOutlet weak var quoteText: UITextView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    // ALEXIS: variables to store the values of the quote that do not get displayed on screen but are needed
    var interviewLink: String?
    var authorInfo: String?
    var idOfQuote: String?
    
    var isFavorite: Bool?
    
    
    //variable for nav bar icons
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 85, height: 30))
    let logo = UIImage(named: "CTT Logo White.png")
    let hamburgerButton = UIImage(named: "white hamburger.png")
    let altHambugerButton = UIImage(named: "Fill Bookmark White 40.png")
    let bookmarkButton = UIImage(named: "white bookmark.png")
    
    //delegate for talking to the ContainerVC
    var delegate: DisplayViewControllerDelegate?
    
    //this uses the didSet modifier to call the updateQuoteData as soon as it's set
    var quoteDataToDisplay: QuoteData? {
        didSet {
            self.updateQuoteData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("DisplayVC: viewDidLoad()")
        makeNavigationBarButtons()
    }
    
    @IBAction func authorInfoButtonPressed(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let authorInfoVC = storyboard.instantiateViewControllerWithIdentifier("AuthorInfoVC") as! AuthorInfoViewController
        // ALEXIS: Now we're passing to the 'authorInfoVC' AuthorViewController the author ID so that it knows what info to display
        authorInfoVC.contributorID = self.authorInfo!
        if let passingName = self.authorName.text {
            authorInfoVC.textForAuthorName = passingName
        }
        self.presentViewController(authorInfoVC, animated: true, completion: nil)
    }

    
    @IBAction func videoButtonPressed(sender: UIButton) {
        println("video button pressed!")
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let videoVC = storyboard.instantiateViewControllerWithIdentifier("VideoVC") as! VideoViewController
        videoVC.urlstring = self.interviewLink
        self.presentViewController(videoVC, animated: true, completion: nil)
    }
    
    
//    @IBAction func bookmarkPressed(sender: UIBarButtonItem) {
//        println("bookmark pressed")
//        
//        
//    }
    // Dave to Alexis - this where your old addToFavorites code should go. This should create/remove the favorite record based on the pressed. I've added this function as the bookmarkButtons "selector" on line 123. So it should run this code everytime it's clicked. 
    func bookmarkButtonPressed() {
        println("bookmark button pressed!")
        var image: UIImage?
        if self.isFavorite == true {
            self.isFavorite = false
            println("isFavorite is now \(self.isFavorite)")
        } else {
            self.isFavorite = true
            println("isFavorite is now \(self.isFavorite)")
        }
        
    }
    
    //this is what actually slides the menuViewContoller in, the displayViewController out. 
    func toggleMenuButton() {
        println("menu button pressed!")
        delegate?.toggleMenu!()
    }
    //this updates the labels on the displayViewController
    func updateQuoteData() {
        self.authorName.text = self.quoteDataToDisplay?.authorName
        self.termName.text = self.quoteDataToDisplay?.termName
        self.quoteText.text = self.quoteDataToDisplay?.quoteText
        self.authorInfo = self.quoteDataToDisplay?.contributorID
        self.interviewLink = self.quoteDataToDisplay?.drupalInterviewURL
        self.idOfQuote = self.quoteDataToDisplay?.quoteID
        
        println("DisplayVC: See if quote's info updates correctly: authorInfo is \(self.authorInfo) and interviewURL is \(self.interviewLink) and idOfQuote is \(self.idOfQuote)")
    }
    
    func makeNavigationBarButtons() {
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        
        //make logo
        self.imageView.image = self.logo
        self.imageView.contentMode = .ScaleAspectFit
        navigationItem.titleView = self.imageView
        
        //make menu button
        let hamburgerButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        hamburgerButton.frame = CGRectMake(0, 0, 20, 15)
        hamburgerButton.setImage(self.hamburgerButton, forState: .Normal)
        hamburgerButton.addTarget(self, action: "toggleMenuButton", forControlEvents: .TouchUpInside)
        
        var leftBarButtonItem = UIBarButtonItem(customView: hamburgerButton)
        navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)
        navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        //make bookmarkbutton
        let bookmarkButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        bookmarkButton.frame = CGRectMake(0, 0, 10, 20)
        bookmarkButton.setImage(self.bookmarkButton, forState: .Normal)
        bookmarkButton.addTarget(self, action: "bookmarkButtonPressed", forControlEvents: .TouchUpInside)
        
        var rightBarButtonItem = UIBarButtonItem(customView: bookmarkButton)
        navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: false)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
