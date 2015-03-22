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
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    let menuButton = UIButton()
    let mainImage = UIImage(named: "orange main") as UIImage?
    let menuImage = UIImage(named: "white menu") as UIImage?
    let logoImage = UIImage(named: "logo.png") as UIImage?
    
    var quoteTextFieldWidth: Int?
    var isMenuOpen: Bool = false
    var menu:MenuViewController?
    var menuLeftConstraint:NSLayoutConstraint?
    //var logoCenterXConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var topBarContainerView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var mainVCLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIImageView!

    @IBOutlet weak var quoteTextField: UITextView!
    @IBOutlet weak var quoteTextFieldTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundViewLeadingConstraint: NSLayoutConstraint!
    
    var json: NSArray?
    
    var midtempData:[String] = []
    
    var favQuotesArray = ["Before","ViewDidLoad Changes","Changes to the Array"]
    
    func showSelectedQuote(ArrayLocation: Int, listOrigin: String) {
        println("MainViewVC: The selected row was \(ArrayLocation) and the list containing that quote is \(listOrigin)")
        if listOrigin == "All" {
            self.quoteTextField.text = midtempData[ArrayLocation]
            updateQuoteTextAppearance()
        } else {
            self.quoteTextField.text = favQuotesArray[ArrayLocation]
            updateQuoteTextAppearance()
        }
        // toggle the menu back to the right
        hideMenu()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createMenuButton()
        createLogo()
        self.quoteTextFieldWidth = Int(quoteTextField.frame.size.width)
        self.favQuotesArray = ["my fav quote 1", "my fav quote 2", "my fav quote 3"]
        
        // working on loading JSON
        if let url = NSURL(string: "https://raw.githubusercontent.com/ASJ3/PlayersGame/master/API_JSON/all-quotes.json") {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                if let jsonDict: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) {
                    self.json = jsonDict as? NSArray
                    
                    println("MainViewVC: json in viewDidLoad(). json count is now \(self.json!.count)")
                    
                    
                    if let jsonData = self.json {
                        println("MainViewVC: json in viewDidLoad(). jsonData exists")
                        for i in jsonData {
                            if let quote = i["quote_text"] as? NSString {
                                self.midtempData.append(quote)
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

        initMenu()
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
            make.width.equalTo(25)
            make.height.equalTo(30)
        }
    }
    
    func createLogo() {
        let logo = UIImageView(image: logoImage)
        self.topBarContainerView.addSubview(logo)
        logo.snp_makeConstraints { (make) -> () in
            make.centerY.equalTo(self.topBarContainerView.snp_centerY).offset(10)
            //make.centerX.equalTo(self.topBarContainerView.snp_centerX)
            make.leading.equalTo(150)
            make.width.equalTo(90)
            make.height.equalTo(30)
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
        
        self.mainContainerView.removeConstraint(quoteTextFieldTrailingConstraint)
        //self.quoteTextField.frame.size.width = 300//CGFloat(self.quoteTextFieldWidth!)
        
        self.view.updateConstraints()
        self.view.layoutIfNeeded()
        self.view.backgroundColor = self.menu!.view.backgroundColor
                
        let transitionOptions = UIViewAnimationOptions.TransitionFlipFromLeft
        UIView.transitionWithView(self.menuButton, duration: 0.75, options: transitionOptions, animations: {
            self.menuButton.setImage(self.menuImage, forState: .Normal)
            }, completion: nil)
        self.isMenuOpen = true
        //println("the container width is: \(self.mainContainerView.frame.width)")
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
        
        self.quoteTextField.frame.size.width = CGFloat(self.quoteTextFieldWidth!)
        self.mainContainerView.addConstraint(quoteTextFieldTrailingConstraint)
        
        self.view.updateConstraints()
        self.view.layoutIfNeeded()
            
        self.isMenuOpen = false
            
        let transitionOptions = UIViewAnimationOptions.TransitionFlipFromRight
        UIView.transitionWithView(self.menuButton, duration: 0.75, options: transitionOptions, animations: {
            self.menuButton.setImage(self.mainImage, forState: .Normal)
            }, completion: nil)
        self.isMenuOpen = false
        //println("the container width is: \(self.mainContainerView.frame.width)")
        }
    
    func changeBackgroundImage() {
        var imageToChangeTo: String?
        var imagePath = NSBundle.mainBundle().pathForResource("BackgroundImage", ofType: "plist")
        var imageNames = NSArray(contentsOfFile: imagePath!)
        //println("the image names are: \(imageNames)")
        
        var numberOfImages = imageNames?.count
        var randomNumber = Int(arc4random_uniform(UInt32(numberOfImages!)))
//        println("there are :\(numberOfImages) images")
//        println("the random number is: \(randomNumber)")
        
        let imageArray: [String] = imageNames as Array
        
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
}
