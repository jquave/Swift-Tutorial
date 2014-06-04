//
//  ViewController.swift
//  TestSwift
//
//  Created by Jameson Quave on 6/2/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//

import UIKit
 
class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    var api: APIController = APIController()
    @IBOutlet var appsTableView : UITableView
    var tableData: NSArray = NSArray()
    var imageCache = NSMutableArray()
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        api.delegate = self
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api.searchItunesFor("Angry Birds");
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        
        var rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        cell.text = rowData["trackName"] as String
        cell.image = UIImage(named: "Icon76")

        
        // Get the formatted price string for display in the subtitle
        var formattedPrice: NSString = rowData["formattedPrice"] as NSString
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
            var urlString: NSString = rowData["artworkUrl60"] as NSString
            //var image: UIImage? = self.imageCache[urlString] as? UIImage
            var image: UIImage? = self.imageCache.valueForKey(urlString) as? UIImage
            if( !image? ) {
                var imgURL: NSURL = NSURL(string: urlString)
                
                // Download an NSData representation of the image at the URL
                var imgData: NSData = NSData(contentsOfURL: imgURL)
                image = UIImage(data: imgData)
                self.imageCache.setValue(image, forKey: urlString)
//                self.imageCache[urlString] = image
            }
            dispatch_async(dispatch_get_main_queue()) {
                var sCell: UITableViewCell? = tableView.cellForRowAtIndexPath(indexPath)
                if sCell != nil {
                    let pCell: UITableViewCell = sCell!
                    pCell.image = image
                    println("set cell to \(image?.size.width)")
                    cell.image = image
                    
                }
                println("attempt to set cell")
            }
            
        })

        tableView.indexPathForCell(cell)

        cell.detailTextLabel.text = formattedPrice
        
        return cell
    }
    
    func didRecieveAPIResults(results: NSDictionary) {
        // Store the results in our table data array
        if results.count>0 {
            self.tableData = results["results"] as NSArray
            self.appsTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
}