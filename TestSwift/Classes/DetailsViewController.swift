//
//  DetailsViewController.swift
//  TestSwift
//
//  Created by Jameson Quave on 6/4/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//

import UIKit
import QuartzCore

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, APIControllerProtocol {
    
    let playIcon = "▶️"
    let stoppedIcon = "⬛️"
    
    @IBOutlet var albumCover : UIImageView
    @IBOutlet var titleLabel : UILabel
    @IBOutlet var tracksTableView : UITableView
    
    var album: Album?
    var tracks: Track[] = []
    var api: APIController?
    var mediaPlayer: MPMoviePlayerController = MPMoviePlayerController()
    
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
    
    func tableView(tableView: UITableView!, didDeselectRowAtIndexPath indexPath: NSIndexPath!) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TrackCell {
            cell.playIcon.text = playIcon
        }
    }
    
    func trackPlaying(track: Track) -> Bool {
        if mediaPlayer.contentURL? {
            return (mediaPlayer.contentURL == NSURL(string: track.previewUrl))
        }
        else {
            return false
        }
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var track = tracks[indexPath.row]
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TrackCell {
            if(trackPlaying(track)) {
                cell.playIcon.text = playIcon
                mediaPlayer.stop()
            }
            else {
                cell.playIcon.text = stoppedIcon
                mediaPlayer.stop()
                mediaPlayer.contentURL = NSURL(string: track.previewUrl)
                mediaPlayer.play()
            }
        }
        
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!) {
        
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        
        UIView.beginAnimations("animInCell", context: nil)
        cell.layer.transform = CATransform3DMakeScale(1,1,1)
        UIView.commitAnimations()
    }

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("TrackCell") as TrackCell
        
        
        var track = tracks[indexPath.row]
        cell.titleLabel.text = track.title
        
        if( trackPlaying(track) ) {
            cell.playIcon.text = stoppedIcon
        }
        else {
            cell.playIcon.text = playIcon
        }
        
        return cell
    }

}
