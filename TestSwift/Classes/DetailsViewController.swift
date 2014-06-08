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
    }
    
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        return nil
    }

}
