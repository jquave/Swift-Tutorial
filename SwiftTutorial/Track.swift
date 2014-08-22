//
//  Track.swift
//  SwiftTutorial
//
//  Created by Jameson Quave on 8/22/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//

import Foundation

class Track {
    
    var title: String
    var price: String
    var previewUrl: String
    
    init(title: String, price: String, previewUrl: String) {
        self.title = title
        self.price = price
        self.previewUrl = previewUrl
    }
    
    class func tracksWithJSON(allResults: NSArray) -> [Track] {
        
        var tracks = [Track]()
        
        if allResults.count>0 {
            for trackInfo in allResults {
                // Create the track
                if let kind = trackInfo["kind"] as? String {
                    if kind=="song" {
                        
                        var trackPrice = trackInfo["trackPrice"] as? String
                        var trackTitle = trackInfo["trackName"] as? String
                        var trackPreviewUrl = trackInfo["previewUrl"] as? String
                        
                        if(trackTitle == nil) {
                            trackTitle = "Unknown"
                        }
                        else if(trackPrice == nil) {
                            println("No trackPrice in \(trackInfo)")
                            trackPrice = "?"
                        }
                        else if(trackPreviewUrl == nil) {
                            trackPreviewUrl = ""
                        }
                        
                        var track = Track(title: trackTitle!, price: trackPrice!, previewUrl: trackPreviewUrl!)
                        tracks.append(track)
                        
                    }
                }
            }
        }
        return tracks
    }
    
}