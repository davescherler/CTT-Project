//
//  SideMenuTableViewController.swift
//  Closer To Truth
//
//  Created by Dave Scherler on 3/15/15.
//  Copyright (c) 2015 Alexis Saint-Jean. All rights reserved.
//

import UIKit

protocol SideMenuTableViewControllerDelegate {
    func sideMenuDidSelectRow(indexPath: NSIndexPath)
}

class SideMenuTableViewController: UITableViewController {
    
    var delegate: SideMenuTableViewControllerDelegate?
    var tableData: [String] = []
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(tableView: (UITableView!), cellForRowAtIndexPath indexPath: (NSIndexPath!)) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            // Configure the cell...
            
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel!.textColor = UIColor.lightTextColor()
            cell!.textLabel?.font = UIFont(name:"Avenir", size: 20)
            
            let selectedView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: cell!.frame.size.width, height: cell!.frame.size.height))
            selectedView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
            
            cell!.selectedBackgroundView = selectedView
        }
        
        cell!.textLabel!.text = tableData[indexPath.row]
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.sideMenuDidSelectRow(indexPath)
    
    
    }
}
