//
//  DetailsViewController.swift
//  TestSwift
//
//  Created by Jameson Quave on 6/4/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, APIControllerProtocol {
    
    @IBOutlet var albumCover : UIImageView
    @IBOutlet var titleLabel : UILabel
    @IBOutlet var tracksTableView : UITableView
    
    var album: Album?
    var tracks: Track[] = []
    var api: APIController?
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = self.album?.title
        albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album?.largeImageURL)))
        
        // Load in tracks
        self.api = APIController(delegate: self)
        let api = self.api!
        if self.album?.collectionId? {
            api.lookupTrack(self.album!.collectionId!)
        }
    }
    
    func didRecieveAPIResults(results: NSDictionary) {
        println("Got track deets \(results)")
        if let allResults = results["results"] as? NSDictionary[] {
            for trackInfo in allResults {
                // Create the track
                if let kind = trackInfo["kind"] as? String {
                    if kind=="song" {
                        var track = Track(dict: trackInfo)
                        tracks.append(track)
                    }
                }
            }
        }
        tracksTableView.reloadData()
    }
    
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("TrackCell") as TrackCell
        
        var track = tracks[indexPath.row]
        cell.titleLabel.text = track.title
        
        /*var playButton = cell.viewWithTag(0) as UIButton
        var titleText = cell.viewWithTag(1) as UILabel
        
        var track = tracks[indexPath.row]
        
        titleText.text = track.title
        */
        
        return cell
    }

}
