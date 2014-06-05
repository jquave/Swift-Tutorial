//
//  ViewController.swift
//  TestSwift
//
//  Created by Jameson Quave on 6/2/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//

import UIKit
 
class SearchResultsViewController: UIViewController,/* UITableViewDataSource, UITableViewDelegate, */APIControllerProtocol {
    
    let kCellIdentifier: String = "SearchResultCell"
    
    var api: APIController = APIController()
    @IBOutlet var appsTableView : UITableView
    
    var tableData: Dictionary<String, AnyObject>[] = []
    var albums: Album[] = []
    
    var imageCache = NSMutableDictionary()
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        api.delegate = self
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api.searchItunesFor("Bob Dylan");
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        
        
        if segue.identifier == "Details" {
            //var detailsViewController: DetailsViewController? = segue.destinationViewController! as? DetailsViewController
            
            var destinationViewController: UIViewController = segue.destinationViewController as UIViewController

         //   var detailsViewController: DetailsViewController = destinationViewController as DetailsViewController
            
            
            //var destinationViewController: UIViewController! = segue.destinationViewController as UIViewController!
            //var detailsViewController: DetailsViewController = destinationViewController as DetailsViewController
/*            var selectedIndexPathRow = appsTableView.indexPathForSelectedRow().row
            var selectedAppDetails: NSDictionary = self.tableData[selectedIndexPathRow] as NSDictionary
            
            detailsViewController.detailInfo = selectedAppDetails*/
        }
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        //return countElements(self.tableData)
        //return self.tableData.count
        return albums.count
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        
        
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: kCellIdentifier)
        } 
        
        var index: Int = indexPath.row
        
        // Find this cell's album by passing in the Int 'index' to the subscript method for an array of type Album[]
        var album = self.albums[index]
        
        cell.text = album.title
        cell.image = UIImage(named: "Blank52")
        
        cell.detailTextLabel.text = album.price
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            // Jump in to a background thread to get the image for this item
            
            // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
            //var urlString: NSString = rowData["artworkUrl60"] as NSString
            var urlString = album.thumbnailImageURL
            
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
                        image = UIImage(data: data)
                        
                        // Store the image in to our cache
                        self.imageCache.setValue(image, forKey: urlString)
                        
                        // Sometimes this request takes a while, and it's possible that a cell could be re-used before the art is done loading.
                        // Let's explicitly call the cellForRowAtIndexPath method of our tableView to make sure the cell is not nil, and therefore still showing onscreen.
                        // While this method sounds a lot like the method we're in right now, it isn't.
                        // Ctrl+Click on the method name to see how it's defined, including the following comment:
                            /** // returns nil if cell is not visible or index path is out of range **/
                        if let albumArtsCell: UITableViewCell? = tableView.cellForRowAtIndexPath(indexPath) {
                            albumArtsCell!.image = image
                        }
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
        return cell
    }
    
    func didRecieveAPIResults(results: NSDictionary) {
        // Store the results in our table data array
        if results.count>0 {
            
            var allResults: NSDictionary[] = results["results"] as NSDictionary[]
            
           // var swiftResultArray: NSDictionary[] = allResults

            // Sometimes iTunes returns a collection, not a track, so we check both for the 'name'
            for result: NSDictionary in allResults {
                
                var name: String? = result["trackName"] as? String
                if !name? {
                    name = result["collectionName"] as? String
                }
                
                // Sometimes price comes in as formattedPrice, sometimes as collectionPrice.. and sometimes it's a float instead of a string. Hooray!
                var price: String? = result["formattedPrice"] as? String
                if !price? {
                    price = result["collectionPrice"] as? String
                    if !price? {
                        var priceFloat: Float? = result["collectionPrice"] as? Float
                        println(priceFloat)
                        var nf: NSNumberFormatter = NSNumberFormatter()
                        nf.maximumFractionDigits = 2;
                        if priceFloat? {
                            price = "$"+nf.stringFromNumber(priceFloat)
                        }
                    }
                }
                
                var thumbnailURL: String? = result["artworkUrl60"] as? String
                var imageURL: String? = result["artworkUrl100"] as? String
                
                var artistURL: String? = result["artistViewUrl"] as? String
                
                var itemURL: String? = result["collectionViewUrl"] as? String
                if !itemURL? {
                    itemURL = result["trackViewUrl"] as? String
                }
                
                var newAlbum = Album(name: name!, price: price!, thumbnailImageURL: thumbnailURL!, largeImageURL: imageURL!, itemURL: itemURL!, artistURL: artistURL!)
                
                albums.append(newAlbum)
            }
            
            
            self.appsTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        // Get the album for this row
        var album = albums[indexPath.row]
    }
    
}





















