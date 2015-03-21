//
//  SideMenu.swift
//  Closer To Truth
//
//  Created by Dave Scherler on 3/15/15.
//  Copyright (c) 2015 Alexis Saint-Jean. All rights reserved.
//

import UIKit

@objc protocol SideMenuDelegate {
    func sideMenuDidSelectButtonAtIndex(index: Int)
    optional func sideMenuWillOpen()
    optional func sideMenutWillClose()
}

class SideMenu: NSObject, SideMenuTableViewControllerDelegate {
    let menuWidth = CGFloat(325)
    let sideMenuTableViewTopInset = CGFloat(50)
    let sideMenuContainerView = UIView()
    let sideMenuTableViewController = SideMenuTableViewController()
    let originView: UIView!
    
    var animator: UIDynamicAnimator!
    var delegate: SideMenuDelegate?
    
    var isSideMenuOpen: Bool = false
    
    override init() {
        super.init()
    }
    
    init(sourceView: UIView, menuItems: [String]) {
        super.init()
        originView = sourceView
        sideMenuTableViewController.tableData = menuItems
        
        createSideMenu()
        
        animator = UIDynamicAnimator(referenceView: originView)
        
        let showGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        showGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        originView.addGestureRecognizer(showGestureRecognizer)
        
        let hideGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        hideGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        originView.addGestureRecognizer(hideGestureRecognizer)
        
    }
    
    func createSideMenu() {
        sideMenuContainerView.frame = CGRect(x: -menuWidth - 1, y: originView.frame.origin.y, width: menuWidth, height: originView.frame.height)
        sideMenuContainerView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.3)
        sideMenuContainerView.clipsToBounds = false
//        
        originView.addSubview(sideMenuContainerView)
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        blurView.frame = sideMenuContainerView.bounds
        sideMenuContainerView.addSubview(blurView)
        
        sideMenuTableViewController.delegate = self
        sideMenuTableViewController.tableView.frame = sideMenuContainerView.bounds
        sideMenuTableViewController.tableView.clipsToBounds = false
        sideMenuTableViewController.tableView.backgroundColor = UIColor.clearColor()
        sideMenuTableViewController.tableView.scrollsToTop = false
        sideMenuTableViewController.tableView.contentInset = UIEdgeInsetsMake(sideMenuTableViewTopInset, 0, 0, 0)
        
        sideMenuTableViewController.tableView.reloadData()
        
        sideMenuContainerView.addSubview(sideMenuTableViewController.tableView)
    }
    
    func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        if recognizer.direction == UISwipeGestureRecognizerDirection.Right {
            showSideMenu(true)
            delegate?.sideMenuWillOpen?()
        } else {
            showSideMenu(false)
            delegate?.sideMenutWillClose?()
        }
    }
    
    
    func showSideMenu(shouldOpen: Bool) {
        animator.removeAllBehaviors()
        isSideMenuOpen = shouldOpen
        
        let gravityInXDirection: CGFloat = (shouldOpen) ? 1 : -1
        let magnitude: CGFloat = (shouldOpen) ? 60 : -60
        let boundaryWithXPosition = (shouldOpen) ? menuWidth : -menuWidth - 25
        
        let gravityBehavior = UIGravityBehavior(items: [sideMenuContainerView])
        gravityBehavior.gravityDirection = CGVectorMake(gravityInXDirection, 0)
        animator.addBehavior(gravityBehavior)
        
        let collisionBehavior = UICollisionBehavior(items: [sideMenuContainerView])
        collisionBehavior.addBoundaryWithIdentifier("sideMenuBoundary", fromPoint: CGPointMake(boundaryWithXPosition, 20), toPoint: CGPointMake(boundaryWithXPosition, originView.frame.size.height))
        animator.addBehavior(collisionBehavior)
        
        let pushBehavior = UIPushBehavior(items: [sideMenuContainerView], mode: UIPushBehaviorMode.Instantaneous)
        pushBehavior.magnitude = magnitude
        animator.addBehavior(pushBehavior)
        
        let sideMenuBehavior = UIDynamicItemBehavior(items: [sideMenuContainerView])
        sideMenuBehavior.elasticity = 0.2
        animator.addBehavior(sideMenuBehavior)
    }
    
    func sideMenuDidSelectRow(indexPath: NSIndexPath) {
        delegate?.sideMenuDidSelectButtonAtIndex(indexPath.row)
    }
}

