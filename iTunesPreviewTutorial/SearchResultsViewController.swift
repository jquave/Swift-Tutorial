//
//  SearchResultsViewController.swift
//  iTunesPreviewTutorial
//
//  Created by Jameson Quave on 4/16/15.
//  Copyright (c) 2015 JQ Software LLC. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol  {
    var albums = [Album]()
    var api: APIController!
    let kCellIdentifier: String = "SearchResultCell"
    var imageCache = [String:UIImage]()
    @IBOutlet weak var appsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api.searchItunesFor("Beatles")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! UITableViewCell
        let album = self.albums[indexPath.row]

        // Get the formatted price string for display in the subtitle
        cell.detailTextLabel?.text = album.price
        // Update the textLabel text to use the title from the Album model
        cell.textLabel?.text = album.title
        
        // Start by setting the cell's image to a static file
        // Without this, we will end up without an image view!
        cell.imageView?.image = UIImage(named: "Blank52")
        
        let thumbnailURLString = album.thumbnailImageURL
        let thumbnailURL = NSURL(string: thumbnailURLString)!
        
        // If this image is already cached, don't re-download
        if let img = imageCache[thumbnailURLString] {
            cell.imageView?.image = img
        }
        else {
            // The image isn't cached, download the img data
            // We should perform this in a background thread
            let request: NSURLRequest = NSURLRequest(URL: thumbnailURL)
            let mainQueue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    // Convert the downloaded data in to a UIImage object
                    let image = UIImage(data: data)
                    // Store the image in to our cache
                    self.imageCache[thumbnailURLString] = image
                    // Update the cell
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                            cellToUpdate.imageView?.image = image
                        }
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        }
        return cell
    }
    
    func didReceiveAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.albums = Album.albumsWithJSON(results)
            self.appsTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailsViewController: DetailsViewController = segue.destinationViewController as? DetailsViewController {
            var albumIndex = appsTableView!.indexPathForSelectedRow()!.row
            var selectedAlbum = self.albums[albumIndex]
            detailsViewController.album = selectedAlbum
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
}

