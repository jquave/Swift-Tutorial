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
        
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: kCellIdentifier)
        }
        
        var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        // Add a check to make sure this exists
        let cellText: String? = rowData["trackName"] as? String
        cell.text = cellText
        cell.image = UIImage(named: "Blank52")
        
        
        // Get the formatted price string for display in the subtitle
        var formattedPrice: NSString = rowData["formattedPrice"] as NSString
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            // Jump in to a background thread to get the image for this item
            
            // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
            var urlString: NSString = rowData["artworkUrl60"] as NSString
            
            // Check our image cache for the existing key. This is just a dictionary of UIImages
            var image: UIImage? = self.imageCache.valueForKey(urlString) as? UIImage
            
            if( !image? ) {
                // If the image does not exist, we need to download it
                var imgURL: NSURL = NSURL(string: urlString)
                
                // Download an NSData representation of the image at the URL
                var request: NSURLRequest = NSURLRequest(URL: imgURL)
                var urlConnection: NSURLConnection = NSURLConnection(request: request, delegate: self)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                    if !error? {
                        //var imgData: NSData = NSData(contentsOfURL: imgURL)
                        image = UIImage(data: data)
                        
                        // Store the image in to our cache
                        self.imageCache.setValue(image, forKey: urlString)
                        cell.image = image
                    }
                    else {
                        println("Error: \(error.localizedDescription)")
                    }
                    })
                
            }
            else {
                cell.image = image
            }
            
            
            })
        
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
