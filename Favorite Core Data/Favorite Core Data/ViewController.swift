//
//  ViewController.swift
//  Favorite Core Data
//
//  Created by Dave Scherler on 4/2/15.
//  Copyright (c) 2015 DaveScherler. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var quote_id: UITextField!
    @IBOutlet weak var quote_text: UITextField!
    @IBOutlet weak var term_name: UITextField!
    @IBOutlet weak var drupal_interview_url: UITextField!
    @IBOutlet weak var contributor_id: UITextField!
    @IBOutlet weak var contributor_name: UITextField!
    @IBOutlet weak var display: UITextView!
    
    let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //I'm only calling the following code to see how many favorites are saved in Core Data each time the app launches. We don't need this. This was just to help me confirm that the favorite data was persisting.
        if let context = self.appDelegate.managedObjectContext {
            let fetchFavorites = NSFetchRequest(entityName: "Favorite")
            
            if let favoriteList: [Favorite] = context.executeFetchRequest(fetchFavorites, error: nil) as? [Favorite] {
                for favorites in favoriteList {
                    println("viewDidLoad(): the nubmer of quotes in coreData is \(favoriteList.count)")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveFavorite(sender: UIButton) {
        
        //this is saving all the info from the text fields to Core Data.
        if let context = self.appDelegate.managedObjectContext {
        //class func from the Favorite.swift file to simply code.
        Favorite.createNewFavoriteEntry(context, quote_id: self.quote_id.text, quote_text: self.quote_text.text, term_name: self.term_name.text, drupal_interview_url: self.drupal_interview_url.text, contributor_id: self.contributor_id.text, contributor_name: self.contributor_name.text)
            appDelegate.saveContext()
        }
    }
    
    //Alexis - this is not super pertinent to how you will display the favorite list. BUT I needed a way to see what being saved. I thought it would be helpful for you to see what was being saved as well. In reality, you're going to have to do a fetch request, create an array of the results, and populate the favorites list in menu with the array containing the fetch results.
    @IBAction func showFavorite(sender: UIButton) {
        if let context = self.appDelegate.managedObjectContext {
            let fetchFavorites = NSFetchRequest(entityName: "Favorite")
            
            if let fetchResults: [Favorite] = context.executeFetchRequest(fetchFavorites, error: nil) as? [Favorite] {
                println(fetchResults.count)
                
                //this is a local array of dictionaries that we can append with new dictionaries of quote info.
                var favoriteList: [[String:String]] = []
                
                //temporary dictionary of the quote info (from the text fields).
                var favoriteInfoDictionary: [String: String] = ["quote_id": "", "quote_text": "", "term_name": "", "drupal_interview_url": "", "contributor_id": "", "contributor_name": ""]
                
                //updating the temp dictionary with what's in the text fields.
                for favorites in fetchResults {
                    favoriteInfoDictionary.updateValue(favorites.quote_id, forKey: "quote_id")
                    favoriteInfoDictionary.updateValue(favorites.quote_text, forKey: "quote_text")
                    favoriteInfoDictionary.updateValue(favorites.term_name, forKey: "term_name")
                    favoriteInfoDictionary.updateValue(favorites.drupal_interview_url, forKey: "drupal_interview_url")
                    favoriteInfoDictionary.updateValue(favorites.contributor_id, forKey: "contributor_id")
                    favoriteInfoDictionary.updateValue(favorites.contributor_name, forKey: "contributor_name")
                    
                    //collecting all the favoriteInfoDictionary's and saving them to the local array.
                    favoriteList.append(favoriteInfoDictionary)
                }
                self.display.text = "\(favoriteList)"
            }
        }
        
    }
    
    @IBAction func deleteFavorite(sender: UIButton) {
        //this should do the following: 
        //1. do a fetch of all the favorites
        //2. compare the quote_id on the display (the screen) with the quote_ids listed in the favorites fetch
        //3. if the quote_id on display matches, it should delete that record.
        //4. this will be used called when the bookmark is pressed a second time.
        
        if let context = self.appDelegate.managedObjectContext {
            
            let fetchFavorites = NSFetchRequest(entityName: "Favorite")
            
            // this filter takes what's on the display and compares it to the favorite file. It will delete the entire record, which is what we want.
            let filter = NSPredicate(format: "quote_id == %@", self.quote_id.text)
            
            //adding the filter to the fetch request
            fetchFavorites.predicate = filter
            
            if let fetchResults: [Favorite] = context.executeFetchRequest(fetchFavorites, error: nil) as? [Favorite] {
                
                for result in fetchResults {
                    //we can just delete 'result' because since we're filtering by the quote_id, which is completely unique, the filter will always return exactly one result. Which is the one we delete.
                    appDelegate.managedObjectContext!.deleteObject(result)
                }
                appDelegate.saveContext()
                println(fetchResults.count)
            }
          }
        }
    
}

