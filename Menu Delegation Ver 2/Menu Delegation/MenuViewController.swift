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
    var favListSelected: Bool?
    var tableSelected: String?
    
    var allQuotesData = ["Local All One","Local All Two","Local All Three"]
    var favQuotesData = ["Local Fav One","Local Fav Two", "Local Fav Three"]

    @IBOutlet weak var filterStatus: UISegmentedControl!
    @IBOutlet weak var table: UITableView!
    @IBAction func filterQuotes(sender: UISegmentedControl) {
        switch filterStatus.selectedSegmentIndex {
        case 0:
            self.tableSelected = "allQuotes"
            filter(self.tableSelected!)
            self.table.reloadData()
            self.favListSelected = false
        case 1:
            self.tableSelected = "favQuotes"
            filter(self.tableSelected!)
            self.table.reloadData()
            self.favListSelected = true
        default:
            self.tableSelected = "allQuotes"
            filter(self.tableSelected!)
            self.table.reloadData()
            self.favListSelected = false
        }
    }
    
    
    // The re_filter function is called by the MainViewController
    // This function ensures that the quotes pushed by the MainViewController actually display
    func re_filter() {
        filter(self.tableSelected!)
        self.table.reloadData()
        println("MenuViewVC: re_filter() called. The number of quotes in allQuotes is now: \(allQuotesData.count)\n")
        println("MenuViewVC: re_filter() called. The number of quotes in favQuotes is now: \(favQuotesData.count)\n")
    }
    
    var dataForCells: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        println("MenuViewVC: The dataForCells value before calling filter is: \(dataForCells)")
        self.tableSelected = "allQuotes"
        filter(self.tableSelected!)

        self.table.reloadData()
    }
    
    func filter(filter: String) {
        if filter == "favQuotes" {
            self.dataForCells = self.favQuotesData
            println("MenuViewVC: filter() called for favQuotes. Number of favQuotes is \(self.favQuotesData.count)")
        } else {
            self.dataForCells = self.allQuotesData
            println("MenuViewVC: filter() called for allQuotes. Number of allQuotes is \(self.allQuotesData.count)")
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataForCells.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell = tableView.dequeueReusableCellWithIdentifier("quoteCell", forIndexPath: indexPath) as UITableViewCell
        var cell = tableView.dequeueReusableCellWithIdentifier("quoteCell") as UITableViewCell!
        if cell == nil  {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "quoteCell")
        }
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.text = dataForCells[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? LocationTableViewCell
        
        println("MenuViewVC: The selected row is \(indexPath.row)")
        var stringToPass: String?
        if self.favListSelected == true {
            stringToPass = "Favorites"
        } else {
            stringToPass = "All"
        }
        println("MenuViewVC: the quote selected was from the \(stringToPass) table")
        self.delegate?.showSelectedQuote(indexPath.row, listOrigin: stringToPass!)
        
    }
}


    

//}
