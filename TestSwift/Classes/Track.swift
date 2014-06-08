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
    
    init(name: String!, price: String!, previewUrl: String!) {
        self.title = name
        self.price = price
        self.previewUrl = previewUrl
    }
}