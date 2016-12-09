//
//  Album.swift
//  TestSwift
//
//  Created by Jameson Quave on 6/4/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//

class Album {
    
    var title: String?
    var price: String?
    var thumbnailImageURL: String?
    var largeImageURL: String?
    var itemURL: String?
    var artistURL: String?
    
    init(name: String!, price: String!, thumbnailImageURL: String!, largeImageURL: String!, itemURL: String!, artistURL: String!) {
        self.title = name
        self.price = price
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.itemURL = itemURL
        self.artistURL = artistURL
    }
}
