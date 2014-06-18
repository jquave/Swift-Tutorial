//
//  ViewController.swift
//  SwiftTutorial
//
//  Created by Jameson Quave on 6/16/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    @IBOutlet var appsTableView : UITableView
    
    let api: APIController = APIController()
    let imageCache = NSMutableDictionary()
    var tableData: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.api.delegate = self
        self.api.searchItunesFor("Angry Birds")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("SearchResultCell") as UITableViewCell
        
        let rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        // Get the formatted price string for display in the subtitle
        let formattedPrice: String = rowData["formattedPrice"] as String
        
        // Add a check to make sure this exists
        let cellText: String = rowData["trackName"] as String
        
        // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
        let urlString: String = rowData["artworkUrl60"] as String
        
        // Check our image cache for the existing key. This is just a dictionary of UIImages
        var image: UIImage? = self.imageCache.valueForKey(urlString) as? UIImage
        
        if image? {
            // If image has found in cache set it immediately
            cell.image = image
        } else {
            // Set placeholder image until loading original from the web
            cell.image = UIImage(named: "Blank52")
            
            // If the image does not exist, we need to download it
            let url: NSURL = NSURL(string: urlString)
            let session = NSURLSession.sharedSession()

            // Download an NSData representation of the image at the URL
            let task = session.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
                if error {
                    // If there is an error in the web request, print it to the console
                    println(error.localizedDescription)
                } else {
                    image = UIImage(data: data)
                    dispatch_async(dispatch_get_main_queue(), {
                        // Store the image in to our cache
                        self.imageCache[urlString] = image
                        // Set loaded image instead previously set placeholder
                        if let ownCell = tableView.cellForRowAtIndexPath(indexPath) {
                            ownCell.image = image
                        }
                    })
                }
            })
            task.resume()
        }
        
        cell.text = cellText
        cell.detailTextLabel.text = formattedPrice
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        // Get the row data for the selected row
        let rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        let name: String = rowData["trackName"] as String
        let formattedPrice: String = rowData["formattedPrice"] as String
        
        let alert: UIAlertView = UIAlertView()
        alert.title = name
        alert.message = formattedPrice
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        let resultsArr: NSArray = results["results"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.tableData = resultsArr
            self.appsTableView.reloadData()
        })
    }

}
