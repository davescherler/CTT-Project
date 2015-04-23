//
//  ContainerViewController.swift
//  CloserToTruth
//
//  Created by Dave Scherler on 4/15/15.
//  Copyright (c) 2015 DaveScherler. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
    case BothCollapsed
    case MenuExpanded
}

class ContainerViewController: UIViewController, DisplayViewControllerDelegate, PassingQuote, ShowingQuote {
    //create an instance of the model
    var model = QuoteModel()
    // ALEXIS: the favQuotes data needs to be called in ContainerVC, maybe later it can be called in a different file, just like allQuotes comes from QuoteModel
    var favQuotesData = [QuoteData]()
    
    
    var mainNavigationController: UINavigationController!
    var displayViewController: DisplayViewController!
    var currentState: SlideOutState = .BothCollapsed { didSet {
        let shouldShowShadow = currentState != .BothCollapsed
        showShadowForDisplayViewController(shouldShowShadow)
        }}
    var menuViewController: MenuViewController?
    let displayVCExpandedOffset: CGFloat = 60
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("ContainerVC: viewDidLoad()")
        // ALEXIS Adding ContainerViewVC as a delegate of model
        model.delegate = self
        
        displayViewController = UIStoryboard.displayViewController()
        displayViewController?.delegate = self

        // wrap the centerViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar
        mainNavigationController = UINavigationController(rootViewController: displayViewController)
        view.addSubview(mainNavigationController.view)
        addChildViewController(mainNavigationController)
        
        mainNavigationController.didMoveToParentViewController(self)
        println("the number of quote structs is \(model.quotes.count)")
        
        
                // ALEXIS: Creating a few quoteData to have fav list to work with
                println("MenuViewVC: viewDidLoad()")
                var favQuote1 = QuoteData()
                favQuote1.quoteText = "Fav 1 from ContainerVC"
                favQuote1.authorName = "Me"
                favQuote1.termName = "other"
                favQuote1.contributorID = "3"
                favQuote1.drupalInterviewURL = "www.google.com"
                favQuote1.quoteID = "1"
        
                self.favQuotesData.append(favQuote1)
        
                var favQuote2 = QuoteData()
                favQuote2.quoteText = "Fav 2 from ContainerVC"
                favQuote2.authorName = "Dave"
                favQuote2.termName = "New"
                favQuote2.contributorID = "2"
                favQuote2.drupalInterviewURL = "www.yahoo.com"
                favQuote2.quoteID = "20"
        
                self.favQuotesData.append(favQuote2)
                println("ContainerVC: favQuotesData has now \(self.favQuotesData.count) quotes")
        
        // ALEXIS: Now loading the data from the Favorites plist
        // bookmarksPath is a string that is the path to the Favorites.plist file
        var bookmarksPath = NSBundle.mainBundle().pathForResource("Favorites", ofType: "plist")
        var bookmarks = NSMutableArray(contentsOfFile: bookmarksPath!)
        if bookmarks!.count > 0 {
            println("ContainerVC: viewDidLoad() number of objects stored in plist is > 0 at \(bookmarks!.count)")
        } else {
            println("ContainerVC: viewDidLoad() number of objects stored in plist is: \(bookmarks!.count)")
        }
    }
    //all these functions are just to call and show the menu screens.
    func addMenuViewController() {
        println("ContainerVC: addMenuViewController()")
        
        if (menuViewController == nil) {
            menuViewController = UIStoryboard.menuViewController()
            menuViewController?.delegate = self
            //pass quotes text to menuViewController
            menuViewController!.quotesText = model.quotes
            menuViewController!.favQuotesData = self.favQuotesData
            println("ContainerVC: adding \(self.favQuotesData.count) quotes to MenuVC favQuotesData")
            addChildMenuViewController(menuViewController!)
        }
    }
    
    func addChildMenuViewController(menuViewController: MenuViewController) {
        println("ContainerVC: addChildMenuViewController()")
        view.insertSubview(menuViewController.view, atIndex: 0)
        addChildViewController(menuViewController)
        menuViewController.didMoveToParentViewController(self)
    }
    
    func animateMenu(#shouldExpand: Bool) {
        println("ContainerVC: animateMenu()")
        if (shouldExpand) {
            currentState = .MenuExpanded
            
            animateMainViewControllerXPosition(targetPosition: CGRectGetWidth(mainNavigationController.view.frame) - displayVCExpandedOffset)
            
        } else {
            animateMainViewControllerXPosition(targetPosition: 0) { finished in
                self.currentState = .BothCollapsed
                self.menuViewController!.view.removeFromSuperview()
                self.menuViewController = nil;
            }
        }
    }
    
    func animateMainViewControllerXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        println("ContainerVC: animateMainViewControllerXPosition()")
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.mainNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func showShadowForDisplayViewController(shouldShowShadow: Bool) {
        println("ContainerVC: showShadowForMainViewController()")
        if (shouldShowShadow) {
            mainNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            mainNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
    func toggleMenu() {
        println("ContainerVC: toggleMenu()")
        let notAlreadyExpanded = (currentState != .MenuExpanded)
        
        if notAlreadyExpanded {
            addMenuViewController()
        }
        animateMenu(shouldExpand: notAlreadyExpanded)
        println("finished running toggleMenu")
    }
    
    func passingTodaysQuote(index: Int) {
        // The purpose of this method is to update the quote on the DisplayVC with today's quote from JSON
            let quoteSelected = self.model.retrieveTodaysQuote(index)
            self.displayViewController.quoteDataToDisplay = quoteSelected
    }
    
    func didSelectQuoteAtIndex(index: Int) {
        println("ContainerVC: function called by the MenuVC table")
        let quoteSelected = self.model.quoteAtIndex(index)
        self.displayViewController.quoteDataToDisplay = quoteSelected
        toggleMenu()
        updateBackgroundImage()
    }
    
    
    func showSelectedQuote(index: Int, listOrigin: String) {
        println("ContainerVC: showSelectedQuote() called by the MenuVC table")
        var quoteSelected = QuoteData()
        if listOrigin == "All" {
            quoteSelected = self.model.quoteAtIndex(index)
        } else {
            quoteSelected = self.favQuotesData[index]
            println("favQuotesData is \(self.favQuotesData.count) long")
        }
        self.displayViewController.quoteDataToDisplay = quoteSelected
        // ALEXIS: need to force the isFavorite to false each time
        self.displayViewController.isFavorite = false
        self.displayViewController.bookmarkButton.setImage(displayViewController.bookmarkPlainImage, forState: .Normal)
        
        toggleMenu()
        updateBackgroundImage()
    }
    
    func updateBackgroundImage() {
        var imagePath = NSBundle.mainBundle().pathForResource("BackgroundImageList", ofType: "plist")
        var imageNames = NSArray(contentsOfFile: imagePath!)
        //println("the image names are: \(imageNames)")
        
        var numberOfImages = imageNames?.count
        var randomNumber = Int(arc4random_uniform(UInt32(numberOfImages!)))
        //println("MainViewVC: There are:\(numberOfImages) images and the random number is:\(randomNumber)")
        
        let imageArray: [String] = imageNames as! Array
        
        var randomImageName = imageArray[randomNumber]
        //println("the random image is: \(randomImageName)")
        
        displayViewController!.backgroundImage.image = UIImage(named: randomImageName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func menuViewController() -> MenuViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("MenuVC") as? MenuViewController
    }
    
    class func displayViewController() -> DisplayViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("DisplayVC") as? DisplayViewController
    }
}
