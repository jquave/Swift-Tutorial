//
//  Track.swift
//  TestSwift
//
//  Created by Jameson Quave on 6/8/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//

class Track {
    
    var title: String?
    var price: String?
    var previewUrl: String?
    
    init(dict: NSDictionary!) {
        self.title = dict["trackName"] as? String
        self.price = dict["trackPrice"] as? String
        self.previewUrl = dict["previewUrl"] as? String
    }
    
}