//
//  ViewController.swift
//  Menu Delegation
//
//  Created by Dave Scherler on 3/18/15.
//  Copyright (c) 2015 DaveScherler. All rights reserved.
//

import UIKit
import Snap
import pop

@objc
protocol MainViewControllerDelegate {
    optional func toggleMenu()
}

class MainViewController: UIViewController, PassingQuote {
    
    let menuButton = UIButton()
    let mainImage = UIImage(named: "menu rounded white") as UIImage?
    let menuImage = UIImage(named: "close white") as UIImage?
    let logoImage = UIImage(named: "logo.png") as UIImage?
    let logoImageView = UIImageView()
    let overlay = UIView()
    
    var delegate: MainViewControllerDelegate?
    
    //variable for new nav bar icons
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 85, height: 30))
    let logo = UIImage(named: "logo.png")
    let hamburgerButton = UIImage(named: "white hamburger.png")
    let bookmarkButton = UIImage(named: "white bookmark.png")
    
    var quoteTextFieldWidth: Int?
    var isMenuOpen: Bool = false
    var menu: MenuViewController?
    var menuLeftConstraint: NSLayoutConstraint?
    var logoTopConstraint = NSLayoutConstraint()
    //var logoCenterXConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var mainContainerView: UIView!

    @IBOutlet weak var mainVCLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var quoteTextField: UITextView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorInfoButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    @IBAction func addToFavorites(sender: UIButton) {
        var image: UIImage?
        // Creating a dictionary that will store all the info necessary for the currently onscreen quote
        var quoteDict = ["quote_id": self.quoteID, "quote_text": self.quoteTextField.text, "term_name": self.infoLabel.text, "drupal_interview_url": self.interviewLink, "contributor_name": self.authorLabel.text,  "contributor_id": self.authorID]
        
        // Creating a mutable array that stores all the favorite quotes
        var bookmarksPath = NSBundle.mainBundle().pathForResource("Favorites", ofType: "plist")
        var bookmarks = NSMutableArray(contentsOfFile: bookmarksPath!)
        
        if self.isAFavoriteQuote == false {
            self.isAFavoriteQuote = true
            image = UIImage(named: "bookmark-fill.png") as UIImage?
            self.favQuotesArray.insert(quoteDict["quote_text"]!, atIndex: 0)
            self.favQuotesIdArray.insert(quoteDict["quote_id"]!, atIndex: 0)
            self.menu?.favQuotesData = self.favQuotesArray
            
            // Now we will store the quoteDict dictionary just created into our Favorites plist
            bookmarks!.insertObject(quoteDict, atIndex: 0)
            bookmarks?.writeToFile(bookmarksPath!, atomically: true)
            
            println("MainViewVC addToFavorites(): The quote and its info was added to favQuotesArray (count:\(self.favQuotesArray.count)); quote ID is \(self.quoteID) and favQuotesIdArray is now \(self.favQuotesIdArray)")
            
        } else {
            self.isAFavoriteQuote = false
            image = UIImage(named: "bookmark empty white bordered.png") as UIImage?
            for i in 0..<self.favQuotesIdArray.count {
                if self.favQuotesIdArray[i] == quoteDict["quote_id"]! {
                    println("found the id at position \(i)")
                    // We need to remove reference to the quote in the variables that holds information about favorites
                    self.favQuotesArray.removeAtIndex(i)
                    self.favQuotesIdArray.removeAtIndex(i)
                    bookmarks!.removeObjectAtIndex(i)
                    bookmarks?.writeToFile(bookmarksPath!, atomically: true)
                    self.menu?.favQuotesData = self.favQuotesArray
                    break
                }
            }
        }
        self.favoriteButton.setImage(image, forState: .Normal)
        // Refreshing the quote table in the MenuViewVC
        self.menu?.re_filter()
    }
    
    
    @IBAction func showVideo(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let next = storyboard.instantiateViewControllerWithIdentifier("VideoVC") as! VideoViewController
        next.urlstring = self.interviewLink
        self.presentViewController(next, animated: true, completion: nil)
    }
    
    
    @IBAction func showAuthorInfo(sender: UIButton) {
        println("The ID for the author of this quote is: \(self.authorID)")
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let next = storyboard.instantiateViewControllerWithIdentifier("AuthorInfoVC") as! AuthorInfoViewController
        // Now we're passing to the 'next' AuthorViewController the author ID so that it knows what info to display
        next.contributorID = self.authorID
        if let passingName = self.authorLabel.text {
            next.textForAuthorName = passingName
        }
        self.presentViewController(next, animated: true, completion: nil)
    }
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var quoteTextFieldTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundViewLeadingConstraint: NSLayoutConstraint!
    
    var json: NSArray?
    var jsonTodaysQuote: NSArray?
    // We're using isAFavoriteQuote to help us decide what to do when clicking on the bookmark button in the top right corner, and also whether the icon for that button should be a full or empty bookmark.
    var isAFavoriteQuote: Bool = false
    
    // the authorID variable stores an ID used to find the right author information from the contributor.json file, in case the user
    // wants to learn more about the author. By default it is "none" (i.e. no ID found)
    var authorID = "none"
    // the interviewLink variable stores the URL of the video associated with the quote on screen.
    // By default it is "none" (i.e. no URL video for the quote)
    var interviewLink = "none"
    var quoteID = "noID"
    var midtempData:[String] = []
    var favQuotesArray:[String] = []
    // favQuotesIdArray is to help us manage the saved quotes in Favorites.plist
    var favQuotesIdArray:[String] = []
    
    func showSelectedQuote(ArrayLocation: Int, listOrigin: String) {
        println("MainViewVC showSelectedQuote(): The selected row was \(ArrayLocation) and the list containing that quote is \(listOrigin)")
        if listOrigin == "All" {
            refreshQuoteOnScreen(ArrayLocation, origin: "All")
        } else {
            refreshQuoteOnScreen(ArrayLocation, origin: "Favorites")
        }
        // refreshQuoteOnScreen() just updated all the variables that hold the quote info, among them self.quoteID
        // We are going to check whether this quote ID is part of the favorite quotes list.
        // If it is, then we are going to update self.isAFavoriteQuote to true and also udpate the bookmark Image
        self.checkIfFavorite(self.quoteID)
        updateQuoteTextAppearance()
        // toggle the menu back to the right
        delegate?.toggleMenu?()
        changeBackgroundImage()
        println("MainViewVC showSelectedQuote(): isAFavoriteQuote is now \(self.isAFavoriteQuote)")
    }
    
    // refreshQuoteOnScreen() takes an integer (the row of the table clicked)
    // and gets the appropriate dictionary from the right source to get that quote's info (text, author...)
    // to display that info on the MainVC view
    func refreshQuoteOnScreen(index:Int, origin: String) {
        var arrayOfQuoteDicts: NSArray?
        if origin == "All" {
            arrayOfQuoteDicts = self.json
        } else if origin == "Favorites" {
            var bookmarksPath = NSBundle.mainBundle().pathForResource("Favorites", ofType: "plist")
            arrayOfQuoteDicts = NSArray(contentsOfFile: bookmarksPath!)
        } else {
            arrayOfQuoteDicts = self.jsonTodaysQuote
        }
        // Although unlikely, we need to make sure the index returned to us (i.e. the row clicked on the menuVC table)
        // is LESS than the count of quotes in arrayOfQuoteDicts because otherwise we would be calling an index
        // that is bigger than the array and the app would crash
        if index < arrayOfQuoteDicts!.count {
            if let allQuotesData = arrayOfQuoteDicts {
                if let quoteDict = allQuotesData[index] as? NSDictionary {
                    if let quoteText = quoteDict["quote_text"] as? NSString {
                        self.quoteTextField.text = "\(quoteText)"
                        // removing some HTML for quotation mark from the quote. This will need to be improved in the future. There is some function in objective C that does HTML replacement already.
                        var cleanText = quoteText as String
                        self.quoteTextField.text = cleanText.stringByReplacingOccurrencesOfString("&#039;", withString: "'", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    }
                    if let authorOfQuote = quoteDict["contributor_name"] as? NSString {
                        self.authorLabel.text = authorOfQuote as String
                    }
                    if let infoForQuote = quoteDict["term_name"] as? NSString {
                        self.infoLabel.text = infoForQuote as String
                    }
                    if let authorInfo = quoteDict["contributor_id"] as? NSString {
                        self.authorID = authorInfo as String
                    }
                    if let interviewInfo = quoteDict["drupal_interview_url"] as? NSString {
                        self.interviewLink = interviewInfo as String
                    }
                    if let quoteIdentifier = quoteDict["quote_id"] as? NSString {
                        self.quoteID = quoteIdentifier as String
                    }
                }
            }
        }
        println("end of refreshQuoteOnScreen()")
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func checkIfFavorite(idOfQuote: String) {
        for i in 0..<self.favQuotesIdArray.count {
            if self.favQuotesIdArray[i] == idOfQuote {
                self.isAFavoriteQuote = true
                var image = UIImage(named: "bookmark-fill.png") as UIImage?
                self.favoriteButton.setImage(image, forState: .Normal)
                break
            } else {
                self.isAFavoriteQuote = false
                var image = UIImage(named: "bookmark empty white bordered.png") as UIImage?
                self.favoriteButton.setImage(image, forState: .Normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Now loading the data from the Favorites plist
        // bookmarksPath is a string that is the path to the Favorites.plist file
        var bookmarksPath = NSBundle.mainBundle().pathForResource("Favorites", ofType: "plist")
        var bookmarks = NSMutableArray(contentsOfFile: bookmarksPath!)
        if bookmarks!.count > 0 {
            self.favQuotesArray = []
            // Loop to load from the plist all the favorite quotes into favQuotesArray and all the quote_id from these quotes into favQuotesIdArray
            for i in bookmarks! {
                self.favQuotesArray.append(i["quote_text"] as! NSString as String)
                self.favQuotesIdArray.append(i["quote_id"] as! NSString as String)
            }
        }
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        //makeMenuNavigationButtons()
        makeLogo()
        
        //createMenuButton()
        println("MainViewVC(): viewDidLoad() this is where initMenu() would launch (but commented out now)")
//        initMenu()
        //createLaunchOverlay()
        //performLaunchOverlayAnimation()
        
        self.quoteTextFieldWidth = Int(quoteTextField.frame.size.width)
        
        
        // working on loading JSON for today's quote
        if let url = NSURL(string: "http://www.closertotruth.com/api/todays-quote") {
            println("MainViewVC: The json for today's quote url does exist")
            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                if let jsonDict: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) {
                    self.jsonTodaysQuote = jsonDict as? NSArray
                    println("MainViewVC: json in viewDidLoad(). jsonTodaysQuote count is now \(self.jsonTodaysQuote!.count)")
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // IMPORTANT we need to reload the data we got into our table view
                    self.refreshQuoteOnScreen(0, origin: "Today")
                    // Now that the screen is refreshed with Today's quote we need to check whether that quote is one of the favorites
                    self.checkIfFavorite(self.quoteID)
                    
                    self.updateQuoteTextAppearance()
                })
            })
            task.resume()
        }
        
        // working on loading JSON for all quotes
        // JSON Trial file https://raw.githubusercontent.com/ASJ3/PlayersGame/master/API_JSON/all-quotes-changed.json
        if let url = NSURL(string: "http://www.closertotruth.com/api/all-quotes") {
            println("MainViewVC: The json url does exist")
            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                if let jsonDict: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) {
                    self.json = jsonDict as? NSArray
                    println("MainViewVC: json in viewDidLoad(). json count is now \(self.json!.count)")
                    
                    // Append all the text of quotes to the midtempData array, so that we can show these quotes
                    // in the MenuViewController's table
                    if let jsonData = self.json {
                        println("MainViewVC: json in viewDidLoad(). jsonData exists")
                        for i in jsonData {
                            if let quote = i["quote_text"] as? NSString {
                                var cleanText = quote as String
                                self.midtempData.append(cleanText.stringByReplacingOccurrencesOfString("&#039;", withString: "'", options: NSStringCompareOptions.LiteralSearch, range: nil))
                            }
                        }
                        println("MainViewVC: json in viewDidLoad(). midtempData count is now \(self.midtempData.count)")
                        // Commenting out the lines below because we commented out initmenu() so the lines below now throws an error
//                        self.menu!.allQuotesData = self.midtempData
//                        var menuVCArray = self.menu!.allQuotesData
//                        println("MainViewVC: json in viewDidLoad(). The number of quotes in MenuViewVC's allQuotes is \(menuVCArray.count)")
//                        self.menu!.re_filter()
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // IMPORTANT we need to reload the data we got into our table view
                    // Commenting out the line below because we commented out initmenu() so the line below now throws an error
//                    self.menu!.table.reloadData()
                })
            })
            task.resume()
        }
        println("MainViewVC: reaching the end of viewDidload()")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func menu(sender: AnyObject) {
        delegate?.toggleMenu?()
    }
    
    //because I'm initializing all the view controllers in the ContainerViewController, we might not need this initMenu function. I think that is what is causing the problem below, on line 320. If that is correct, we'd need to re-direct the JSON data somehow. But I don't want to touch the JSON data or code. Hoping Alexis can make sense of what's going on.
    
    func initMenu() {
        
        self.menu = (self.storyboard?.instantiateViewControllerWithIdentifier("MenuVC") as! MenuViewController)
        
        //if I set this to true, then then the menu is able to load the JSON data. BUT the menu loads over top the main view contoller. If I keep this as false, the app looks like it should but the menu doesn't load JSON data. And the selecting of quotes from the menu doesn't load back onto the main view controller.  
        self.menu!.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(self.menu!.view)

        //Loading the quotes into the menuViewController
        self.menu?.allQuotesData = self.midtempData
        self.menu?.favQuotesData = self.favQuotesArray
        self.menu?.delegate = self
        self.menu?.re_filter()
    }
    
    //new nav bar buttons
  func makeMenuNavigationButtons() {
        let hamburgerButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        hamburgerButton.frame = CGRectMake(0, 0, 20, 15)
        hamburgerButton.setImage(self.hamburgerButton, forState: .Normal)
        //hamburgerButton.addTarget(self, action: "toggle:", forControlEvents: .TouchUpInside)
        
        var leftBarButtonItem = UIBarButtonItem(customView: hamburgerButton)
        
        navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)
        navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        let bookmarkButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        bookmarkButton.frame = CGRectMake(0, 0, 10, 20)
        bookmarkButton.setImage(self.bookmarkButton, forState: .Normal)
        //bookmarkButton.addTarget(self, action: "addToFavorites:", forControlEvents: .TouchUpInside)
        
        var rightBarButtonItem = UIBarButtonItem(customView: bookmarkButton)
        
        navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: false)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    
    //new nav bar logo func
    func makeLogo() {
        self.imageView.image = self.logo
        self.imageView.contentMode = .ScaleAspectFit
        navigationItem.titleView = self.imageView
    }
    
    func toggle(sender: UIButton!) {
        if isMenuOpen == false {
            showMenu()
        } else {
            hideMenu()
        } }
    
    func showMenu(){
        // Hide the bookmark button, otherwise there would be overlap when the menu is open

        self.favoriteButton.hidden = true
        
        self.quoteTextField.alpha = 0
        self.authorLabel.alpha = 0
        self.infoLabel.alpha = 0
        self.authorInfoButton.alpha = 0
        self.videoButton.alpha = 0
        self.view.backgroundColor = self.menu!.view.backgroundColor
        
        let transitionOptions = UIViewAnimationOptions.TransitionFlipFromLeft
        UIView.transitionWithView(self.menuButton, duration: 0.75, options: transitionOptions, animations: {
            self.menuButton.setImage(self.menuImage, forState: .Normal)
            }, completion: nil)
        self.isMenuOpen = true
    }
    
    func hideMenu() {
        
        self.isMenuOpen = false
        
        let transitionOptions = UIViewAnimationOptions.TransitionFlipFromRight
        UIView.transitionWithView(self.menuButton, duration: 0.75, options: transitionOptions, animations: {
            self.menuButton.setImage(self.mainImage, forState: .Normal)
            }, completion: nil)
        self.isMenuOpen = false
        
        UIView.animateWithDuration(0.3, animations: {
            self.authorInfoButton.alpha = 1
            self.videoButton.alpha = 1
            
        })
        
        // The bookmark button, which was hidden by showMenu()
        // now needs to come back but fading in
        // First we unhide it and put its alpha at 0
        self.favoriteButton.hidden = false
        self.favoriteButton.alpha = 0
        
        // Then we put the alpha progressively to 1
        UIView.animateWithDuration(1, animations: {
            self.quoteTextField.alpha = 1
            self.authorLabel.alpha = 1
            self.infoLabel.alpha = 1
            self.favoriteButton.alpha = 1
        })
    }
    
    func changeBackgroundImage() {
        var imageToChangeTo: String?
        var imagePath = NSBundle.mainBundle().pathForResource("BackgroundImage", ofType: "plist")
        var imageNames = NSArray(contentsOfFile: imagePath!)
        //         println("the image names are: \(imageNames)")
        
        var numberOfImages = imageNames?.count
        var randomNumber = Int(arc4random_uniform(UInt32(numberOfImages!)))
        //        println("MainViewVC: There are:\(numberOfImages) images and the random number is:\(randomNumber)")
        
        let imageArray: [String] = imageNames as! Array
        
        var randomImageName = imageArray[randomNumber]
        //        println("the random image is: \(randomImageName)")
        self.backgroundView.image = UIImage(named:randomImageName)
        self.backgroundView.frame = self.view.frame
    }
    
    func updateQuoteTextAppearance() {
        self.quoteTextField.textColor = UIColor.whiteColor()
        self.quoteTextField.font = UIFont(name: "Avenir", size: 20)
        self.quoteTextField.textAlignment = .Center
    }
    
    func createLaunchOverlay() {
        self.logoImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.logoTopConstraint = NSLayoutConstraint(item: self.logoImageView, attribute: .Top, relatedBy: .Equal, toItem: self.overlay, attribute: .Top, multiplier: 1, constant: 250)
        println("top constraint is: \(logoTopConstraint.constant)")
        
        self.view.addSubview(self.overlay)
        self.view.addSubview(logoImageView)
        self.view.addConstraint(logoTopConstraint)
        self.overlay.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.overlay.backgroundColor = UIColor.darkGrayColor()
        
        self.logoImageView.image = logoImage
        self.logoImageView.snp_makeConstraints { (make) -> () in
            make.width.equalTo(300)
            make.height.equalTo(128)
            make.centerX.equalTo(self.overlay.snp_centerX)
        }
        
        
    }
    
    func performLaunchOverlayAnimation() {
        UIView.animateWithDuration(1, animations: {
            let scale = CGAffineTransformMakeScale(0.3, 0.285)
            self.logoImageView.transform = scale
            }, completion: { (Bool) -> Void in
                let slideUp = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
                slideUp.toValue = -24.5
                slideUp.springBounciness = -10
                slideUp.springSpeed = 40
                self.logoTopConstraint.pop_addAnimation(slideUp, forKey: "slideUp.move")
                self.destroyLaunchOverlay()
        })
    }
    
    func destroyLaunchOverlay() {
        UIView.animateWithDuration(2, animations: { () -> Void in
            self.overlay.alpha = 0
            }) { (Bool) -> Void in
                self.logoImageView.removeFromSuperview()
                //self.createLogo()
        }
    }
    
}