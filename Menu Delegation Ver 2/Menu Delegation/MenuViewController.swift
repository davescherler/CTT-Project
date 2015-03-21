//
//  MenuViewController.swift
//  Menu Delegation
//
//  Created by Dave Scherler on 3/18/15.
//  Copyright (c) 2015 DaveScherler. All rights reserved.
//

import UIKit

protocol PassingQuote {
    func showSelectedQuote(ArrayLocation: Int, listOrigin: String)
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: PassingQuote?

    @IBOutlet weak var filterStatus: UISegmentedControl!
    @IBOutlet weak var table: UITableView!
    @IBAction func filterQuotes(sender: UISegmentedControl) {
        switch filterStatus.selectedSegmentIndex {
        case 0:
            filter("allQuotes")
            self.table.reloadData()
        case 1:
            filter("favQuotes")
            self.table.reloadData()
        default:
            filter("allQuotes")
            self.table.reloadData()
        }
    }
    
    func re_filter() {
        filter("allQuotes")
        self.table.reloadData()
        println("re filtering the quote list on the table")
    }
    
    var allQuotesData = ["Local All one","Local All two","Local All three"]
    var favQuotesData = ["Local fav one","Local fav two", "Local fave three"]

    var dataForCells: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("The dataForCells value before calling filter is: \(dataForCells)")
        filter("allQuotes")
        self.table.reloadData()
        println("The dataForCells value after calling filter is: \(dataForCells)")
    }
    
    func filter(filter: String) {        
        if filter == "favQuotes" {
            self.dataForCells = self.favQuotesData
        } else {
            self.dataForCells = self.allQuotesData
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(dataForCells.count)
        return dataForCells.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("quoteCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.textColor = UIColor.whiteColor()
        //cell.backgroundColor = self.view.backgroundColor
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.text = dataForCells[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
}
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? LocationTableViewCell
//    }
    
    

//}
