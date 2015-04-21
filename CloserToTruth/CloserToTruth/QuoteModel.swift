//
//  QuoteModel.swift
//  CloserToTruth
//
//  Created by Dave Scherler on 4/15/15.
//  Copyright (c) 2015 DaveScherler. All rights reserved.
//

import Foundation

protocol ShowingQuote {
    func passingTodaysQuote(index: Int)
}


class QuoteModel {
    var quotes = [QuoteData]()
    var todaysQuote = [QuoteData]()
    
    var delegate: ShowingQuote?
    
    //ALEXIS: The following variables are to store values for quotes pulled from JSON API
    var jsonTodaysQuote: NSArray?
    var json: NSArray?
    var midtempData:[String] = []
    
    
    init() {
        var todaysQuoteDefault = QuoteData(quoteText: "A connection with the Closer To Truth website could not be established. Either your phone doesn't have access to the Internet, or Closer To Truth servers are unavailable. Please try again later.", authorName: "Couldn't Connect", termName: "---")
        self.todaysQuote.append(todaysQuoteDefault)
        
        //ALEXIS: working on loading JSON for today's quote
        if let url = NSURL(string: "http://www.closertotruth.com/api/todays-quote") {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                if let jsonDict: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) {
                    self.jsonTodaysQuote = jsonDict as? NSArray
                    println("QuoteModel: json in viewDidLoad(). jsonTodaysQuote count is now \(self.jsonTodaysQuote!.count)")
                    // Create a quote struct with Today's data, then append that struct to todaysQuote array (which contains only one struct)
                    var quoteOne = QuoteData()
                    quoteOne.authorName = self.jsonTodaysQuote![0]["contributor_name"] as! String
                    quoteOne.termName = self.jsonTodaysQuote![0]["term_name"] as! String
                    quoteOne.quoteText = self.jsonTodaysQuote![0]["quote_text"] as! String
                    self.todaysQuote.insert(quoteOne, atIndex: 0)
                    self.quotes.insert(quoteOne, atIndex: 0)
                }
                else {
                    println("QuoteModel: couldn't create jsonDict, which means there was no Internet connection. The no-connection text will show instead of a quote")
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in                    
                    // ACTIONS TO TAKE ONCE THE DATA IS LOADED. NOTHING DONE NOW
                    println("QuoteModel: dispatch_async() loading today's Quote")
                    self.delegate?.passingTodaysQuote(0)
                    
                })
            })
            task.resume()
        }
        
        // working on loading JSON for all quotes
        // JSON Trial file https://raw.githubusercontent.com/ASJ3/PlayersGame/master/API_JSON/all-quotes-changed.json
        if let url = NSURL(string: "http://www.closertotruth.com/api/all-quotes") {
            println("QuoteModel: The json url does exist")
            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                if let jsonDict: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) {
                    self.json = jsonDict as? NSArray
                    println("QuoteModel: json in viewDidLoad(). json count is now \(self.json!.count)")
                    
                    // Append all the text of quotes to the midtempData array, so that we can show these quotes
                    // in the MenuViewController's table
                    if let jsonData = self.json {
                        println("QuoteModel: json in viewDidLoad(). jsonData exists")
                        for i in jsonData {
                            if let quote = i["quote_text"] as? NSString {
                                var cleanText = quote as String
                                self.midtempData.append(cleanText.stringByReplacingOccurrencesOfString("&#039;", withString: "'", options: NSStringCompareOptions.LiteralSearch, range: nil))
                            }
                        }
                        println("QuoteModel: json in viewDidLoad(). midtempData count is now \(self.midtempData.count)")
                        // ALEXIS: need to load the quote into the menu
                        //                        self.menu!.allQuotesData = self.midtempData
                        //                        var menuVCArray = self.menu!.allQuotesData
                        //                        println("MainViewVC: json in viewDidLoad(). The number of quotes in MenuViewVC's allQuotes is \(menuVCArray.count)")
                        //                        self.menu!.re_filter()
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    
                    // IMPORTANT we need to reload the data we got into our table view
                    //                    self.menu!.table.reloadData()
                })
            })
            task.resume()
        }

        
        
        
        
        // Creating dummy data. This is where the JSON code should live.
        // Essentially, the code should parse the JSON data, find all the quote data (name, text, author, url, etc) and create discrete structs of QuoteData for each set of data. We then append each struct to the array above named 'quotes.' All we need to do is have a have to iterate through all the structs created from the JSON data and add each one to the array. The dummy data is easy to add because we know we only have two structs, but in reality we may not know how many structs will be created.
        
        var quoteOne = QuoteData()
        quoteOne.authorName = "Dave Scherler"
        quoteOne.termName = "Origin"
        quoteOne.quoteText = "I'm from New Jersey!"
        quotes.append(quoteOne)
        
        var quoteTwo = QuoteData()
        quoteTwo.authorName = "Alexis"
        quoteTwo.termName = "Children"
        quoteTwo.quoteText = "I have two children!"
        quotes.append(quoteTwo)
    }
    
    func quoteAtIndex(index:Int) -> QuoteData {
        return self.quotes[index]
    }
    
    func retrieveTodaysQuote(index: Int) -> QuoteData {
        return self.todaysQuote[0]
    }

}
