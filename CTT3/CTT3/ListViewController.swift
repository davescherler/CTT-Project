//
//  ListViewController.swift
//  CTT3
//
//  Created by Alexis Saint-Jean on 3/19/15.
//  Copyright (c) 2015 Alexis Saint-Jean. All rights reserved.
//
// CTT3 in CTT-Project

import UIKit

class ListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate  {
    @IBOutlet weak var tableView: UITableView!
    
//    var firstTimeLoading = true
//    var json: NSArray?
    
    var failedToLoadData = ["quote_text"]
    
    
    var midtempData = ["Couldn't Load Data"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("beginning of viewDidLoad")
        
//        // working on loading JSON
//        if let url = NSURL(string: "https://raw.githubusercontent.com/ASJ3/PlayersGame/master/API_JSON/all-quotes.json") {
//            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
//                if let jsonDict: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) {
//                    self.json = jsonDict as? NSArray
//                    println("json count is now \(self.json!.count)")
//                }
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    // IMPORTANT we need to reload the data we got into our table view
//                    self.tableView.reloadData()
//                })
//            })
//            task.resume()
//        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return midtempData.count
//        if let jsonData = self.json {
//            return self.json!.count
        
//        }
//        //            println("jsonData hasn't loaded yet")
//        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        if cell == nil  {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        }
//        
//        if let jsonData = self.json {
//            if let quote = jsonData[indexPath.row] as? NSDictionary {
//                let articleTitle = quote["quote_text"] as NSString
//                cell.textLabel?.text = articleTitle
//            }
//        }
        
                    cell.textLabel?.text = midtempData[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        var permalink = midtempData[indexPath.row]
//        if let jsonData = self.json {
//            if let quote = jsonData[indexPath.row] as? NSDictionary {
//                var permalink = quote
//                println("the quote is:\n\(permalink)\nthe number to pass to the ViewController with the quote is: \(indexPath.row)")
//                //                self.performSegueWithIdentifier("showQuote", sender: permalink)
//            }
//        }
        //        var permalink = midtempData[indexPath.row]
        
        println("Do nothing for now")
    }
    
    
}
