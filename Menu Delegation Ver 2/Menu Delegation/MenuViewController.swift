//
//  MenuViewController.swift
//  Menu Delegation
//
//  Created by Dave Scherler on 3/18/15.
//  Copyright (c) 2015 DaveScherler. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var filterStatus: UISegmentedControl!
    @IBOutlet weak var table: UITableView!
    @IBAction func filterQuotes(sender: UISegmentedControl) {
        switch filterStatus.selectedSegmentIndex {
        case 0:
            filter("quote_id")
            self.table.reloadData()
        case 1:
            filter("fav")
            self.table.reloadData()
        default:
            filter("quote_id")
            self.table.reloadData()
        }
    }
    var tableData = [
        ["quote_id":"one"], ["quote_id":"two"], ["quote_id":"three"],
        ["fav":"first quote"], ["fav":"second quote"], ["fav":"why is the third quote."]
    ]
    var dataForCells: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //println("The dataForCells value before calling filter is: \(dataForCells)")
        filter("quote_id")
        self.table.reloadData()
        //println("The dataForCells value after calling filter is: \(dataForCells)")
    }
    
    func filter(filter: String) {
        var tempArray: [String] = []
        for dictionaries in tableData {
            if let results = dictionaries[filter] {
                //println(results)
                tempArray.append(results)
            }
            dataForCells = tempArray
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
