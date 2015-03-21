//
//  quoteViewController.swift
//  Closer To Truth
//
//  Created by Alexis Saint-Jean on 3/14/15.
//  Copyright (c) 2015 Alexis Saint-Jean. All rights reserved.
//

import UIKit

class quoteViewController: ViewController, SideMenuDelegate { //SideMenuDelegate was being used here before.
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var quoteTextField: UITextView!
    
<<<<<<< HEAD
=======
    
    var fakedata = "stingurl"

>>>>>>> 8d1d25b30bcea9fe119ca2ad5828b21a530bf85c
//    @IBOutlet weak var quoteTextField: UITextView!
//    @IBOutlet weak var authorLabel: UILabel!
//    @IBOutlet weak var professionLabel: UILabel!
    
    var textOfQuote: String?
    var authorOfQuote: String?
    var professionOfAuthor: String?
    
    //this is a dummy array of strings for testing.
    var quotes: [String] = ["I see God’s hand in everything around us including the whole universe. If it suited His purposes not just to have one planet that could sustain life that would give rise to intelligence, fine. I don't see any reason to be shaken or object to that at all", "The big bang is not a point in space. It’s a moment in time. It’s a moment when the density of the universe was infinite.", "One of the most important things which our minds undertake is to understand other human beings. We’ve become - we’ve evolved to be - what I call ‘natural psychologists’, who are brilliant at mind reading."]
    
    var delegate: SideMenuTableViewControllerDelegate?
    var tableData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var sideMenu = SideMenu(sourceView: self.view, menuItems: quotes)
        sideMenu.delegate = self
        
        // Do any additional setup after loading the view.
        self.quoteTextField.text = textOfQuote
        self.authorLabel.text = authorOfQuote
        self.professionLabel.text = professionOfAuthor
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sideMenuDidSelectButtonAtIndex(index: Int) {
        println("foo fooo foooooo")
        self.quoteTextField.text = self.quotes[index]
    }
    
    @IBAction func showAuthorVC(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let next = storyboard.instantiateViewControllerWithIdentifier("authorVC") as AuthorViewController
        self.presentViewController(next, animated: true, completion: nil)

    }

    @IBAction func showVideoVC(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let next = storyboard.instantiateViewControllerWithIdentifier("videoVC") as videoViewController
        self.presentViewController(next, animated: true, completion: nil)
        self.videoViewController.request = fakedata
    }

}