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

class MainViewController: UIViewController, PassingQuote {

    let menuButton = UIButton()
    let mainImage = UIImage(named: "menu rounded white") as UIImage?
    let menuImage = UIImage(named: "close white") as UIImage?
    let logoImage = UIImage(named: "logo.png") as UIImage?
    let logoImageView = UIImageView()
    let overlay = UIView()
    
    var quoteTextFieldWidth: Int?
    var isMenuOpen: Bool = false
    var menu:MenuViewController?
    var menuLeftConstraint:NSLayoutConstraint?
    var logoTopConstraint = NSLayoutConstraint()
    //var logoCenterXConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var topBarContainerView: UIView!
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
        if self.isAFavoriteQuote == false {
            self.isAFavoriteQuote = true
            image = UIImage(named: "bookmark-fill.png") as UIImage?
            
            // Creating a dictionary that will store all the info necessary for the quote
            var quoteDict = ["quote_id": self.quoteID, "quote_text": self.quoteTextField.text, "term_name": self.infoLabel.text, "drupal_interview_url": self.interviewLink, "contributor_name": self.authorLabel.text,  "contributor_id": self.authorID]
            println("The addToFavorites button created a dictionary:\n\(quoteDict)")
            self.favQuotesArray.insert(quoteDict["quote_text"]!, atIndex: 0)
            self.favQuotesIdArray.insert(quoteDict["quote_id"]!, atIndex: 0)
            println("favQuotesArray is now \(self.favQuotesArray) and favQuotesIdArray is now \(self.favQuotesIdArray)")
            self.menu?.favQuotesData = self.favQuotesArray
            
            // Now we will store the dictionary just created into our Favorites plist
            var bookmarksPath = NSBundle.mainBundle().pathForResource("Favorites", ofType: "plist")
            var bookmarks = NSMutableArray(contentsOfFile: bookmarksPath!)
            bookmarks!.insertObject(quoteDict, atIndex: 0)
            bookmarks?.writeToFile(bookmarksPath!, atomically: true)

        } else {
            self.isAFavoriteQuote = false
            image = UIImage(named: "bookmark empty white bordered.png") as UIImage?
        }
        self.favoriteButton.setImage(image, forState: .Normal)
    }
    

    @IBAction func showVideo(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let next = storyboard.instantiateViewControllerWithIdentifier("VideoVC") as VideoViewController
        next.urlstring = self.interviewLink
        self.presentViewController(next, animated: true, completion: nil)
        
    }
    
    // Stated there was a potential conflict with func showAuthorInfo()
    @IBAction func showAuthorInfo(sender: UIButton) {
        // Right now, only prints the id of the author
        // in the future we will have to create a new view controller to display the author info
        if self.authorID == "none" {
            println("not enough information to find author bio")
        }
        else {
            println("The ID for the author of this quote is: \(self.authorID)")
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let next = storyboard.instantiateViewControllerWithIdentifier("AuthorInfoVC") as AuthorInfoViewController
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
    var quoteID = "none"
    var midtempData:[String] = []
//    var favQuotesArray = ["Before","ViewDidLoad Changes","to the Array"]
    var favQuotesArray:[String] = []
    // favQuotesIdArray is to help us manage the saved quotes in Favorites.plist
    var favQuotesIdArray:[String] = []

    
    func showSelectedQuote(ArrayLocation: Int, listOrigin: String) {
        println("MainViewVC: The selected row was \(ArrayLocation) and the list containing that quote is \(listOrigin)")
        if listOrigin == "All" {
            refreshJSONQuoteOnScreen(ArrayLocation, origin: "All")
            updateQuoteTextAppearance()
        } else {
            // When selecting a quote on the MenuVC from the 'Favorites' section we need to update the bookmark button
            // in the MainViewVC to show the quote is a favorite
            self.isAFavoriteQuote = true
            var image = UIImage(named: "bookmark-fill.png") as UIImage?
            self.favoriteButton.setImage(image, forState: .Normal)
            refreshFavQuoteOnScreen(ArrayLocation)
            updateQuoteTextAppearance()
        }
        // toggle the menu back to the right
        hideMenu()
        changeBackgroundImage()
    }
    
    // refreshFavQuoteOnScreen() takes an integer (the row of the table clicked)
    // and gets the appropriate dictionary from the Favorites.plist for all the quote info (text, author...)
    // to display that info on the MainVC view
    func refreshFavQuoteOnScreen(index:Int) {
        // Now loading the data from the Favorites plist
        // bookmarksPath is a string that is the path to the Favorites.plist file
        var bookmarksPath = NSBundle.mainBundle().pathForResource("Favorites", ofType: "plist")
        var bookmarks = NSMutableArray(contentsOfFile: bookmarksPath!)
        
        // Although unlikely, we need to make sure the index returned to us (i.e. the row clicked on the menuVC table)
        // is LESS than the count of quotes in bookmarks array because otherwise we would be calling an index 
        // that is bigger than the array and the app would crash
        if index < bookmarks!.count {
            if let quoteText = bookmarks![index]["quote_text"] as? NSString {
                var cleanText = quoteText as String
                self.quoteTextField.text = cleanText.stringByReplacingOccurrencesOfString("&#039;", withString: "'", options: NSStringCompareOptions.LiteralSearch, range: nil)
            }
            if let authorOfQuote = bookmarks![index]["contributor_name"] as? NSString {
                self.authorLabel.text = authorOfQuote
            }
            if let infoForQuote = bookmarks![index]["term_name"] as? NSString {
                self.infoLabel.text = infoForQuote
            }
            if let authorInfo = bookmarks![index]["contributor_id"] as? NSString {
                self.authorID = authorInfo
            }
            if let interviewInfo = bookmarks![index]["drupal_interview_url"] as? NSString {
                self.interviewLink = interviewInfo
            }
            if let quoteIdentifier = bookmarks![index]["quote_id"] as? NSString {
                self.quoteID = quoteIdentifier
            }
        }
    }
    
    
    // refreshJSONQuoteOnScreen() takes an integer (the row of the table clicked)
    // and gets the appropriate dictionary with all the quote info (text, author...)
    // to display that info on the MainVC view
    func refreshJSONQuoteOnScreen(index:Int, origin:String) {
        var jsonToUse: NSArray?
        // since we have two json files ("all quotes" and "today's quotes")
        // we need to figure out which one to use to refresh the info on screen
        if origin == "All" {
            jsonToUse = self.json
        } else {
            jsonToUse = self.jsonTodaysQuote
        }
        
        if let jsonData = jsonToUse {
            if let jsonQuoteSelected = jsonData[index] as? NSDictionary {
                if let jsonQuoteText = jsonQuoteSelected["quote_text"] as? NSString {
                    var cleanText = jsonQuoteText as String
                    self.quoteTextField.text = cleanText.stringByReplacingOccurrencesOfString("&#039;", withString: "'", options: NSStringCompareOptions.LiteralSearch, range: nil)
                }
                if let authorOfQuote = jsonQuoteSelected["contributor_name"] as? NSString {
                    self.authorLabel.text = authorOfQuote
                }
                if let infoForQuote = jsonQuoteSelected["term_name"] as? NSString {
                    self.infoLabel.text = infoForQuote
                }
                if let authorInfo = jsonQuoteSelected["contributor_id"] as? NSString {
                    self.authorID = authorInfo
                }
                if let interviewInfo = jsonQuoteSelected["drupal_interview_url"] as? NSString {
                    self.interviewLink = interviewInfo
                }
                if let quoteIdentifier = jsonQuoteSelected["quote_id"] as? NSString {
                    self.quoteID = quoteIdentifier
                }
            }
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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
                var newString = i["quote_text"] as NSString
                self.favQuotesArray.append(newString)
                self.favQuotesIdArray.append(self.quoteID)
                println("MainViewVCprinting the favQuotesArray: \(self.favQuotesArray)")
            }
        } else {
            println("MainViewVC - ViewDidLoad(): the count of quotes in the favorites plist is not > 0 it is \(bookmarks!.count)")
        }
        
        createMenuButton()
        initMenu()
        createLaunchOverlay()
        performLaunchOverlayAnimation()
        
        
        
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
                    self.refreshJSONQuoteOnScreen(0, origin: "Today")
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
                        self.menu!.allQuotesData = self.midtempData
                        var menuVCArray = self.menu!.allQuotesData
                        println("MainViewVC: json in viewDidLoad(). The number of quotes in MenuViewVC's allQuotes is \(menuVCArray.count)")
                        self.menu!.re_filter()
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // IMPORTANT we need to reload the data we got into our table view
                    self.menu!.table.reloadData()
                })
            })
            task.resume()
                }
        println("MainViewVC: reaching the end of viewDidload()")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func swipeToShowMenu(sender: UISwipeGestureRecognizer) {
        showMenu() }
    
    @IBAction func swipeToHideMenu(sender: UISwipeGestureRecognizer) {
        hideMenu() }

    func initMenu() {
        self.menu = self.storyboard?.instantiateViewControllerWithIdentifier("MenuVC") as? MenuViewController
        self.menu?.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(self.menu!.view)
        
        self.menu!.view.snp_makeConstraints { (make) -> () in
            make.width.equalTo(320)
            make.height.equalTo(self.view.snp_height)
            make.top.equalTo(0)
        }
        self.menuLeftConstraint = NSLayoutConstraint(item: self.menu!.view, attribute: .Left, relatedBy: .Equal, toItem: nil, attribute: .Left, multiplier: 1.0, constant: -self.menu!.view.frame.width)
        self.menu!.view.addConstraint(self.menuLeftConstraint!)
        
        //Loading the quotes into the menuViewController
        self.menu?.allQuotesData = self.midtempData
        self.menu?.favQuotesData = self.favQuotesArray
        self.menu?.delegate = self
        self.menu?.re_filter()
    }
    
    func createMenuButton() {
        self.topBarContainerView.addSubview(menuButton)
        self.menuButton.setImage(mainImage, forState: .Normal)
        self.menuButton.addTarget(self, action: "toggle:", forControlEvents: UIControlEvents.TouchUpInside)
        self.menuButton.snp_makeConstraints { (make) -> () in
            make.centerY.equalTo(self.topBarContainerView.snp_centerY).offset(7)
            make.leading.equalTo(10)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
    }
    
    func createLogo() {
        let logo = UIImageView(image: logoImage)
        self.topBarContainerView.addSubview(logo)
        logo.alpha = 1
        logo.snp_makeConstraints { (make) -> () in
            make.centerY.equalTo(self.topBarContainerView.snp_centerY).offset(7)
            //make.centerX.equalTo(self.topBarContainerView.snp_centerX)
            make.leading.equalTo(142.5)
            make.width.equalTo(90)
            make.height.equalTo(36)
        }
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
        
        // Reset isAFavoriteQuote to false and the bookmark image to the empty one
        self.isAFavoriteQuote = false
        var image = UIImage(named: "bookmark empty white bordered.png") as UIImage?
        self.favoriteButton.setImage(image, forState: .Normal)
    
        let toggleMenuIn = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        toggleMenuIn.toValue = -5
        toggleMenuIn.springBounciness = 10
        toggleMenuIn.springSpeed = 10
        self.menuLeftConstraint?.pop_addAnimation(toggleMenuIn, forKey: "toggleMenuIn.move")
                
        let toggleMainVCOut = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        toggleMainVCOut.toValue = 315
        toggleMainVCOut.springBounciness = 10
        toggleMainVCOut.springSpeed = 10
        self.mainVCLeftConstraint?.pop_addAnimation(toggleMainVCOut, forKey: "toggleMainVCOut.move")
        
        let slideBackgroundOut = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        slideBackgroundOut.toValue = 315
        slideBackgroundOut.springBounciness = 10
        slideBackgroundOut.springSpeed = 10
        self.backgroundViewLeadingConstraint.pop_addAnimation(slideBackgroundOut, forKey: "slideBackgroundOut.move")

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
        let toggleMenuOut = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        toggleMenuOut.toValue = -self.menu!.view.frame.width
        toggleMenuOut.springBounciness = 0
        toggleMenuOut.springSpeed = 15
        self.menuLeftConstraint?.pop_addAnimation(toggleMenuOut, forKey: "toggleMenuOut.move")
            
        let toggleMainVCIn = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        toggleMainVCIn.toValue = 0
        toggleMainVCIn.springBounciness = 0
        toggleMainVCIn.springSpeed = 15
        self.mainVCLeftConstraint?.pop_addAnimation(toggleMainVCIn, forKey: "toggleMainVCIn.move")
        
        let slideBackgroundIn = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        slideBackgroundIn.toValue = 0
        slideBackgroundIn.springBounciness = 0
        slideBackgroundIn.springSpeed = 15
        self.backgroundViewLeadingConstraint.pop_addAnimation(slideBackgroundIn, forKey: "slideBackgroundIn.move")
        
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
         println("the image names are: \(imageNames)")
        
        var numberOfImages = imageNames?.count
        var randomNumber = Int(arc4random_uniform(UInt32(numberOfImages!)))
        println("there are :\(numberOfImages) images")
        println("the random number is: \(randomNumber)")
        
        let imageArray: [String] = imageNames as Array
        
        var randomImageName = imageArray[randomNumber]
        println("the random image is: \(randomImageName)")
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
            self.createLogo()
        }
    }
    
}

