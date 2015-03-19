//
//  ViewController.swift
//  CTT3
//
//  Created by Alexis Saint-Jean on 3/18/15.
//  Copyright (c) 2015 Alexis Saint-Jean. All rights reserved.
//

import UIKit

protocol PassingQuote {
    func returnQuote(ArrayLocation: Int, listOrigin: String)
}

class ViewController: UIViewController {
    @IBOutlet weak var menuView: UIView!
    
//    var listController: ListViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller = storyboard!.instantiateViewControllerWithIdentifier("ListVC") as ListViewController
        self.addChildViewController(controller)
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

