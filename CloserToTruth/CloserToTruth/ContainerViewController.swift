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

class ContainerViewController: UIViewController, DisplayViewControllerDelegate, PassingQuote {
    //create an instance of the model
    var model = QuoteModel()
    var mainNavigationController: UINavigationController!
    var displayViewController: DisplayViewController!
    var currentState: SlideOutState = .BothCollapsed { didSet {
        let shouldShowShadow = currentState != .BothCollapsed
        showShadowForDisplayViewController(shouldShowShadow)
        }}
    var menuViewController: MenuViewController?
    let displayVCExpandedOffset: CGFloat = 60
    
    
    
    //ALEXIS: The following variables are to store values for quotes pulled from JSON API
    var jsonTodaysQuote: NSArray?
    var json: NSArray?
    var midtempData:[String] = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("ContainerVC: viewDidLoad()")
        
        //ALEXIS: working on loading JSON for today's quote
        if let url = NSURL(string: "http://www.closertotruth.com/api/todays-quote") {
            println("MainViewVC: The json for today's quote url does exist")
            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                if let jsonDict: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) {
                    self.jsonTodaysQuote = jsonDict as? NSArray
                    println("MainViewVC: json in viewDidLoad(). jsonTodaysQuote count is now \(self.jsonTodaysQuote!.count)")
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // ACTIONS TO TAKE ONCE THE DATA IS LOADED. NOTHING DONE NOW
                    
                    
                    
                    
                    // IMPORTANT we need to reload the data we got into our table view
//                    self.refreshQuoteOnScreen(0, origin: "Today")
//                    // Now that the screen is refreshed with Today's quote we need to check whether that quote is one of the favorites
//                    self.checkIfFavorite(self.quoteID)
                    
//                    self.updateQuoteTextAppearance()
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
                        // ALEXIS: need to load the quote into the menu
//                        self.menu!.allQuotesData = self.midtempData
//                        var menuVCArray = self.menu!.allQuotesData
//                        println("MainViewVC: json in viewDidLoad(). The number of quotes in MenuViewVC's allQuotes is \(menuVCArray.count)")
//                        self.menu!.re_filter()
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // IMPORTANT we need to reload the data we got into our table view
//                    self.menu!.table.reloadData()
                })
            })
            task.resume()
        }
        
        displayViewController = UIStoryboard.displayViewController()
        displayViewController.delegate = self
        
        // wrap the centerViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar
        mainNavigationController = UINavigationController(rootViewController: displayViewController)
        view.addSubview(mainNavigationController.view)
        addChildViewController(mainNavigationController)
        
        mainNavigationController.didMoveToParentViewController(self)
        println("the number of quote structs is \(model.quotes.count)")
        
    }
    //all these functions are just to call and show the menu screens.
    func addMenuViewController() {
        println("ContainerVC: addMenuViewController()")
        
        if (menuViewController == nil) {
            menuViewController = UIStoryboard.menuViewController()
            menuViewController?.delegate = self
            //pass quotes text to menuViewController
            menuViewController!.quotesText = model.quotes
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
    
    func didSelectQuoteAtIndex(index: Int) {
        let quoteSelected = self.model.quoteAtIndex(index)
        self.displayViewController.quoteDataToDisplay = quoteSelected
        toggleMenu()
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
