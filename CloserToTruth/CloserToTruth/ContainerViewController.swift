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
        // ALEXIS: the following lines are to pass data from the ContainerVC to displayVC variables that are then used to update the values of the labels on the displayVC view

        println("ContainerVC: viewDidLoad() Trying to load todaysQuote into the DisplayVC")
        println("ContainerVC: viewDidLoad() the number of quotes in quotes of model is \(self.model.quotes.count) ")
        println("ContainerVC: viewDidLoad() the first author is \(self.model.quotes[0].authorName)")
        displayViewController.authorNameVar = self.model.todaysQuote[0].authorName
        displayViewController.termNameVar = self.model.todaysQuote[0].termName
        displayViewController.quoteTextVar = self.model.todaysQuote[0].quoteText
        
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
    
    func passingTodaysQuote(index: Int) {
        // The purpose of this method is to update the quote on the DisplayVC with today's quote from JSON
//        displayViewController.authorNameVar = self.model.todaysQuote[0].authorName
            let quoteSelected = self.model.quoteAtIndex(index)
            self.displayViewController.quoteDataToDisplay = quoteSelected
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
