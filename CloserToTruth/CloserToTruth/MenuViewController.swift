//
//  MenuViewController.swift
//  CloserToTruth
//
//  Created by Dave Scherler on 4/15/15.
//  Copyright (c) 2015 DaveScherler. All rights reserved.
//

import UIKit

protocol PassingQuote {
    func didSelectQuoteAtIndex(index: Int)
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // ALEXIS: variables to work on showing the right table
    var favListSelected: Bool?
    var tableSelected: String?
    var favQuotesData = ["Local Fav One","Local Fav Two", "Local Fav Three"]
    

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var filterStatus: UISegmentedControl!
    @IBAction func filterQuotes(sender: UISegmentedControl) {
        
        switch filterStatus.selectedSegmentIndex {
        case 0:
            println("case 0")
            self.tableSelected = "allQuotes"
        case 1:
            println("case 1")
            self.tableSelected = "favQuotes"
        default:
            println("default")
            self.tableSelected = "allQuotes"
//        case 0:
//            self.tableSelected = "allQuotes"
//            filter(self.tableSelected!)
//            self.table.reloadData()
//            self.favListSelected = false
//        case 1:
//            self.tableSelected = "favQuotes"
//            filter(self.tableSelected!)
//            self.table.reloadData()
//            self.favListSelected = true
//        default:
//            self.tableSelected = "allQuotes"
//            filter(self.tableSelected!)
//            self.table.reloadData()
//            self.favListSelected = false
        }
    }
    
    func filter(filter: String) {
        if filter == "favQuotes" {
//            self.dataForCells = self.favQuotesData
//            println("MenuViewVC: filter() called for favQuotes. Number of favQuotes is \(self.favQuotesData.count)")
        } else {
//            self.dataForCells = self.quotesText
//            println("MenuViewVC: filter() called for allQuotes. Number of allQuotes is \(self.allQuotesData.count)")
        }
    }
    
    
    
    var delegate: PassingQuote?
    var quotesText: [QuoteData] = [] {
        didSet {
            println(quotesText)
            self.table?.reloadData()
        } }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.quotesText.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
   
        var cell = tableView.dequeueReusableCellWithIdentifier("quoteCell") as! UITableViewCell!
        if cell == nil  {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "quoteCell")
        }
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.text = quotesText[indexPath.row].quoteText
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        println("MenuViewVC: The selected row is \(indexPath.row)")
//        var stringToPass: String?
//        if self.favListSelected == true {
//            stringToPass = "Favorites"
//        } else {
//            stringToPass = "All"
//        }
        
        //println("MenuViewVC: the quote selected was from the \(stringToPass) table")
        self.delegate?.didSelectQuoteAtIndex(indexPath.row)
    }

}
