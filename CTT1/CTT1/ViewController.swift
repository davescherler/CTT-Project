//
//  ViewController.swift
//  CTT1
//
//  Created by Alexis Saint-Jean on 3/11/15.
//  Copyright (c) 2015 Alexis Saint-Jean. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    var midtempData = [["quote": "I see God’s hand in everything around us including the whole universe. If it suited His purposes not just to have one planet that could sustain life that would give rise to intelligence, fine. I don't see any reason to be shaken or object to that at all", "contributor_name": "Francis Collins", "Profession": "Geneticist"],
        ["quote": "The big bang is not a point in space. It’s a moment in time. It’s a moment when the density of the universe was infinite.", "contributor_name": "Sean Carroll", "Profession": "Physicist"],
        ["quote": "One of the most important things which our minds undertake is to understand other human beings. We’ve become - we’ve evolved to be - what I call ‘natural psychologists’, who are brilliant at mind reading.", "contributor_name": "Nicholas Humphrey", "Profession": "Psychologist"],
        ["quote": "Is it possible that this idea of God is something more than merely a functional idea. Could it be that under this world as we find it, there is some sort of deeper reality.", "contributor_name": "Philip Clayton", "Profession": "Philosopher"],
        ["quote": "It is remarkable that the complexity of our world can be explained in terms of simple physical laws and that these laws, which we can study in a lab, apply in the remotest galaxies.", "Author": "Martin Rees", "Profession": "Astronomer"],
        ["quote": "I see God’s hand in everything around us including the whole universe. If it suited His purposes not just to have one planet that could sustain life that would give rise to intelligence, fine. I don't see any reason to be shaken or object to that at all", "contributor_name": "Francis Collins", "Profession": "Geneticist"]]
//        ["quote": "The big bang is not a point in space. It’s a moment in time. It’s a moment when the density of the universe was infinite.", "contributor_name": "Sean Carroll", "Profession": "Physicist"],
//        ["quote": "One of the most important things which our minds undertake is to understand other human beings. We’ve become - we’ve evolved to be - what I call ‘natural psychologists’, who are brilliant at mind reading.", "contributor_name": "Nicholas Humphrey", "Profession": "Psychologist"],
//        ["quote": "Is it possible that this idea of God is something more than merely a functional idea. Could it be that under this world as we find it, there is some sort of deeper reality.", "contributor_name": "Philip Clayton", "Profession": "Philosopher"],
//        ["quote": "It is remarkable that the complexity of our world can be explained in terms of simple physical laws and that these laws, which we can study in a lab, apply in the remotest galaxies.", "contributor_name": "Martin Rees", "Profession": "Astronomer"]]
    
    var oldtempData = ["I see God’s hand in everything around us including the whole universe. If it suited His purposes not just to have one planet that could sustain life that would give rise to intelligence, fine. I don’t see any reason to be shaken or object to that at all.",
        "The big bang is not a point in space. It’s a moment in time. It’s a moment when the density of the universe was infinite.",
        "One of the most important things which our minds undertake is to understand other human beings. We’ve become - we’ve evolved to be - what I call ‘natural psychologists’, who are brilliant at mind reading.",
        "Is it possible that this idea of God is something more than merely a functional idea. Could it be that under this world as we find it, there is some sort of deeper reality.",
        "It is remarkable that the complexity of our world can be explained in terms of simple physical laws and that these laws, which we can study in a lab, apply in the remotest galaxies.",
        "Quote 6",
        "Quote 7",
        "Quote 8",
        "Quote 9",
        "Quote 10",
        "Quote 11",
        "Quote 12",
        "Quote 13",
        "Quote 14",
        "Quote 15", "Quote 16", "Quote 17", "Quote 18","Quote 19", "Quote 20"]
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //For now uses the tempData array to create the number of cells needed
        return midtempData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
            cell.textLabel?.text = midtempData[indexPath.row]["quote"]
        
        return cell
    }
    
    // When the user clicks on a cell, we want to switch to the quoteViewController and show the quote
    // To do that we need to pass to quoteViewController the info related to the quote clicked
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            var permalink = midtempData[indexPath.row]
            self.performSegueWithIdentifier("showQuote", sender: permalink)
            println("the quote is:\n\(permalink)")
        }
        
    
    // prepareForSegue is directly related to the tableView(...) function
    // here the 'sender' argument in the function is going to be the text info of the quote
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//            var destinationViewController = segue.destinationViewController as UIViewController
        println("running the prepareForSegue function")
        if let forsure = segue.destinationViewController as? quoteViewController {
            
            // **********
            // I'm having issues with setting the text variable to the "quote" of the sender (is it because it is an AnyObject?)
            // So first I am setting a local variable, localdictionary, then I am assigning the sender to it
            var localdictionary = ["quote": "", "contributor_name": "", "Profession": ""]
            localdictionary = sender as Dictionary
//            var text = sender["quote"] as? NSString
            var text = localdictionary["quote"]
            forsure.textOfQuote = text
            var authorName = localdictionary["contributor_name"]
            forsure.authorOfQuote = authorName
            var profession = localdictionary["Profession"]
            forsure.professionOfAuthor = profession
        }
//            var text = sender as? NSString
//            destinationViewController.textOfQuote = text
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

