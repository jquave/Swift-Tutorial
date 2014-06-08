//
//  ViewController.swift
//  TestSwift
//
//  Created by Jameson Quave on 6/2/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//

import UIKit
 
class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    let kCellIdentifier = "SearchResultCell"
    
    var api: APIController?
    
    @IBOutlet var appsTableView : UITableView
    
    var albums: Album[] = []
    var imageCache = Dictionary<String, UIImage>()
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        self.api = APIController(delegate: self)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        println("Search")
        self.api!.searchItunesFor("Bob Dylan");
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject) {
        var detailsViewController: DetailsViewController = segue.destinationViewController as DetailsViewController
        var albumIndex = appsTableView.indexPathForSelectedRow().row
        var selectedAlbum = self.albums[albumIndex]
        detailsViewController.album = selectedAlbum
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell
        
        // Find this cell's album by passing in the indexPath.row to the subscript method for an array of type Album[]
        let album = self.albums[indexPath.row]
        cell.text = album.title
        cell.image = UIImage(named: "Blank52")
        cell.detailTextLabel.text = album.price
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            // Jump in to a background thread to get the image for this item
            
            // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
            //var urlString: NSString = rowData["artworkUrl60"] as NSString
            let urlString = album.thumbnailImageURL
            
            // Check our image cache for the existing key. This is just a dictionary of UIImages
            var image: UIImage? = self.imageCache[urlString!]

            if( !image? ) {
                // If the image does not exist, we need to download it
                let imgURL = NSURL(string: urlString)
                
                // Download an NSData representation of the image at the URL
                let request = NSURLRequest(URL: imgURL)
                let urlConnection = NSURLConnection(request: request, delegate: self)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                    if !error? {
                        image = UIImage(data: data)
                        
                        // Store the image in to our cache
                        self.imageCache[urlString!] = image
                        
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
            
            let allResults: NSDictionary[] = results["results"] as NSDictionary[]

            // Sometimes iTunes returns a collection, not a track, so we check both for the 'name'
            for result in allResults {
                
                var name = result["trackName"] as? String
                if !name? {
                    name = result["collectionName"] as? String
                }
                
                // Sometimes price comes in as formattedPrice, sometimes as collectionPrice.. and sometimes it's a float instead of a string. Hooray!
                var price = result["formattedPrice"] as? String
                if !price? {
                    price = result["collectionPrice"] as? String
                    if !price? {
                        var priceFloat: Float? = result["collectionPrice"] as? Float
                        var nf: NSNumberFormatter = NSNumberFormatter()
                        nf.maximumFractionDigits = 2;
                        if priceFloat? {
                            price = "$"+nf.stringFromNumber(priceFloat)
                        }
                    }
                }
                
                let thumbnailURL = result["artworkUrl60"] as? String
                let imageURL = result["artworkUrl100"] as? String
                let artistURL = result["artistViewUrl"] as? String
                
                var itemURL = result["collectionViewUrl"] as? String
                if !itemURL? {
                    itemURL = result["trackViewUrl"] as? String
                }
                
                var collectionId = result["collectionId"] as? Int
                
                var newAlbum = Album(name: name!, price: price!, thumbnailImageURL: thumbnailURL!, largeImageURL: imageURL!, itemURL: itemURL!, artistURL: artistURL!, collectionId: collectionId!)
                albums.append(newAlbum)
            }
            
            
            self.appsTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
}





















