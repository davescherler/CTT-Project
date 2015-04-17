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
    
    
    //variable for nav bar icons
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 85, height: 30))
    let logo = UIImage(named: "CTT Logo White.png")
    let hamburgerButton = UIImage(named: "white hamburger.png")
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
        makeNavigationBarButtons()
    }
    
    @IBAction func authorInfoButtonPressed(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let authorInfoVC = storyboard.instantiateViewControllerWithIdentifier("AuthorInfoVC") as! AuthorInfoViewController
        self.presentViewController(authorInfoVC, animated: true, completion: nil)
    }

    
    @IBAction func videoButtonPressed(sender: UIButton) {

        println("video button pressed!")
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let videoVC = storyboard.instantiateViewControllerWithIdentifier("VideoVC") as! VideoViewController
        self.presentViewController(videoVC, animated: true, completion: nil)
    }
    
    
    @IBAction func bookmarkPressed(sender: UIBarButtonItem) {
        println("bookmark pressed")
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
        
        var rightBarButtonItem = UIBarButtonItem(customView: bookmarkButton)
        navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: false)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
