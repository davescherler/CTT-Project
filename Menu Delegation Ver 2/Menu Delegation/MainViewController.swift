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
    let mainImage = UIImage(named: "orange main") as UIImage?
    let menuImage = UIImage(named: "white menu") as UIImage?
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
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var quoteTextFieldTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundViewLeadingConstraint: NSLayoutConstraint!
    
    var midtempData = ["I see God’s hand in everything around us including the whole universe. If it suited His purposes not just to have one planet that could sustain life that would give rise to intelligence, fine. I don't see any reason to be shaken or object to that at all", "The big bang is not a point in space. It’s a moment in time. It’s a moment when the density of the universe was infinite.", "One of the most important things which our minds undertake is to understand other human beings. We’ve become - we’ve evolved to be - what I call ‘natural psychologists’, who are brilliant at mind reading.", "Is it possible that this idea of God is something more than merely a functional idea. Could it be that under this world as we find it, there is some sort of deeper reality.", "It is remarkable that the complexity of our world can be explained in terms of simple physical laws and that these laws, which we can study in a lab, apply in the remotest galaxies.", "I see God’s hand in everything around us including the whole universe. If it suited His purposes not just to have one planet that could sustain life that would give rise to intelligence, fine. I don't see any reason to be shaken or object to that at all"]
    
    var favQuotesArray = ["my fav quote 1", "my fav quote 2", "my fav quote 3"]
    
    func showSelectedQuote(ArrayLocation: Int, listOrigin: String) {
        println("the row selected is \(ArrayLocation) and the list containing that quote is \(listOrigin)")
        if listOrigin == "All" {
            self.quoteTextField.text = midtempData[ArrayLocation]
            updateQuoteTextAppearance()
        } else {
            self.quoteTextField.text = favQuotesArray[ArrayLocation]
            updateQuoteTextAppearance()
        }
        // toggle the menu back to the right
        hideMenu()
        changeBackgroundImage()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initMenu()
        createMenuButton()
        createLaunchOverlay()
        performLaunchOverlayAnimation()
        //miniaturizeLaunchOverlay()
        //self.view.removeFromSuperview(self.overlay)
        //self.quoteTextFieldWidth = Int(quoteTextField.frame.size.width)
        //println("the container width is: \(self.mainContainerView.frame.width)")
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
            make.width.equalTo(325) //(self.view.frame.width - 50)
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
            make.centerY.equalTo(self.topBarContainerView.snp_centerY).offset(10)
            make.leading.equalTo(12)
            make.width.equalTo(26)
            make.height.equalTo(30)
        }
    }
    
    func createLogo() {
        let logo = UIImageView(image: logoImage)
        self.topBarContainerView.addSubview(logo)
        logo.snp_makeConstraints { (make) -> () in
            make.centerY.equalTo(self.topBarContainerView.snp_centerY).offset(10.5)
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
            changeBackgroundImage()
        } }
    
    func showMenu(){
        let toggleMenuIn = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        toggleMenuIn.toValue = -5
        toggleMenuIn.springBounciness = 10
        toggleMenuIn.springSpeed = 10
        self.menuLeftConstraint?.pop_addAnimation(toggleMenuIn, forKey: "toggleMenuIn.move")
                
        let toggleMainVCOut = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        toggleMainVCOut.toValue = 320//self.menu!.view.frame.width - 5
        toggleMainVCOut.springBounciness = 10
        toggleMainVCOut.springSpeed = 10
        self.mainVCLeftConstraint?.pop_addAnimation(toggleMainVCOut, forKey: "toggleMainVCOut.move")
        
        let slideBackgroundOut = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
        slideBackgroundOut.toValue = 320//self.mainVCLeftConstraint.constant
        slideBackgroundOut.springBounciness = 10
        slideBackgroundOut.springSpeed = 10
        self.backgroundViewLeadingConstraint.pop_addAnimation(slideBackgroundOut, forKey: "slideBackgroundOut.move")

        self.quoteTextField.alpha = 0
        self.authorLabel.alpha = 0
        self.infoLabel.alpha = 0
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
        
        UIView.animateWithDuration(1, animations: {
            self.quoteTextField.alpha = 1
            self.authorLabel.alpha = 1
            self.infoLabel.alpha = 1
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
            //make.centerY.equalTo(self.overlay.snp_centerY)
        }
        

    }
    
    func performLaunchOverlayAnimation() {
        UIView.animateWithDuration(1, animations: {
            let scale = CGAffineTransformMakeScale(0.3, 0.285)
            self.logoImageView.transform = scale
            }, completion: { (Bool) -> Void in
                let slideUp = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
                slideUp.toValue = -21
                slideUp.springBounciness = 2
                slideUp.springSpeed = 1
                self.logoTopConstraint.pop_addAnimation(slideUp, forKey: "slideUp.move")
                
                self.destroyLaunchOverlay()
                //self.createLogo()
            })
            //destroyLaunchOverlay()
//                UIView.animateWithDuration(2.0, animations: {
//                    self.overlay.alpha = 0
//                    
//                    }, completion: { (Bool) -> Void In
//                         self.logoImageView.removeFromSuperview()
//                })
       
    }
    
    func destroyLaunchOverlay() {
        UIView.animateWithDuration(1.7, animations: { () -> Void in
        self.overlay.alpha = 0
        }) { (Bool) -> Void in
            self.createLogo()
            self.logoImageView.removeFromSuperview()
        }
    }
    
}

