//
//  ContainerViewController.swift
//  Menu Delegation
//
//  Created by Dave Scherler on 4/10/15.
//  Copyright (c) 2015 DaveScherler. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
    case BothCollapsed
    case MenuExpanded
}

class ContainerViewController: UIViewController, MainViewControllerDelegate {
    
    var mainNavigationController: UINavigationController!
    var mainViewController: MainViewController!
    var currentState: SlideOutState = .BothCollapsed { didSet {
        let shouldShowShadow = currentState != .BothCollapsed
        showShadowForMainViewController(shouldShowShadow)
        }}
    var menuViewController: MenuViewController?
    let mainVCExpandedOffset: CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("ContainerVC: viewDidLoad()")
        
        mainViewController = UIStoryboard.mainViewController()
        mainViewController.delegate = self
        
        // wrap the centerViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar
        mainNavigationController = UINavigationController(rootViewController: mainViewController)
        view.addSubview(mainNavigationController.view)
        addChildViewController(mainNavigationController)
        
        mainNavigationController.didMoveToParentViewController(self)
        
    }
    
    func addMenuViewController() {
        println("ContainerVC: addMenuViewController()")
            if (menuViewController == nil) {
                menuViewController = UIStoryboard.menuViewController()
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
                
                animateMainViewControllerXPosition(targetPosition: CGRectGetWidth(mainNavigationController.view.frame) - mainVCExpandedOffset)
                
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
    
    func showShadowForMainViewController(shouldShowShadow: Bool) {
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
        
        class func mainViewController() -> MainViewController? {
            return mainStoryboard().instantiateViewControllerWithIdentifier("MainVC") as? MainViewController
        }
}
