//
//  QuoteModel.swift
//  CloserToTruth
//
//  Created by Dave Scherler on 4/15/15.
//  Copyright (c) 2015 DaveScherler. All rights reserved.
//

import Foundation

class QuoteModel {
    var quotes = [QuoteData]()
    
    init() {
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
        quoteTwo.quoteText = "I have have children!"
        quotes.append(quoteTwo)
    }
    
    func quoteAtIndex(index:Int) -> QuoteData {
        return self.quotes[index]
    }
}
