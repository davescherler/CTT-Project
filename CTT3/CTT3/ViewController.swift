//
//  ViewController.swift
//  CTT3
//
//  Created by Alexis Saint-Jean on 3/18/15.
//  Copyright (c) 2015 Alexis Saint-Jean. All rights reserved.
//

// CTT3 in CTT-Project

import UIKit

protocol PassingQuote {
    func returnQuote(ArrayLocation: Int, listOrigin: String)
}

class ViewController: UIViewController {
    @IBOutlet weak var menuView: UIView!
    
//    var listController: ListViewController?
    
    
     var midtempData = ["I see God’s hand in everything around us including the whole universe. If it suited His purposes not just to have one planet that could sustain life that would give rise to intelligence, fine. I don't see any reason to be shaken or object to that at all", "The big bang is not a point in space. It’s a moment in time. It’s a moment when the density of the universe was infinite.", "One of the most important things which our minds undertake is to understand other human beings. We’ve become - we’ve evolved to be - what I call ‘natural psychologists’, who are brilliant at mind reading.", "Is it possible that this idea of God is something more than merely a functional idea. Could it be that under this world as we find it, there is some sort of deeper reality.", "It is remarkable that the complexity of our world can be explained in terms of simple physical laws and that these laws, which we can study in a lab, apply in the remotest galaxies.", "I see God’s hand in everything around us including the whole universe. If it suited His purposes not just to have one planet that could sustain life that would give rise to intelligence, fine. I don't see any reason to be shaken or object to that at all"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller = storyboard!.instantiateViewControllerWithIdentifier("ListVC") as ListViewController
        self.addChildViewController(controller)
        // Transferring data to populate the table in 'controller'
        controller.midtempData = self.midtempData
        controller.view.frame = CGRectMake(0, 20, 180, 600)
        self.view.addSubview(controller.view)
        controller.didMoveToParentViewController(self)
        
        // Do any additional setup after loading the view.
        
        
//        self.listController = ListViewController()
//        self.menuView.addSubview(self.listController!.view)
        
        

        println("Hello there")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

