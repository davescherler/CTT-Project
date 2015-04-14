//
//  LaunchViewController.swift
//  Menu Delegation
//
//  Created by Dave Scherler on 3/20/15.
//  Copyright (c) 2015 DaveScherler. All rights reserved.
//

import UIKit
import pop

class LaunchViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    
    var main: MainViewController?
    
    override func viewDidLoad() {
        UIView.animateWithDuration(1, animations: { () -> Void in
            let scale = CGAffineTransformMakeScale(0.2, 0.25)
            self.logoImage.transform = scale
            }, completion: { (Bool) -> Void in
            let slideUp = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
            slideUp.toValue = -35
            slideUp.springBounciness = 5
            slideUp.springSpeed = 10
            self.logoTopConstraint.pop_addAnimation(slideUp, forKey: "slideUp.move")
            })
        present()
    }

    func present() {
    //self.view.backgroundColor = UIColor.clearColor()
    let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    self.main = self.storyboard?.instantiateViewControllerWithIdentifier("MainVC") as? MainViewController
//    self.main?.view.setTranslatesAutoresizingMaskIntoConstraints(false)
//    self.view.addSubview(self.main!.view)
    self.presentViewController(main!, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
