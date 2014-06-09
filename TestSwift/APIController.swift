//
//  APIController.swift
//  TestSwift
//
//  Created by Jameson Quave on 6/3/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//

import Foundation
import SwiftNetworking

protocol APIControllerProtocol {
    func didRecieveAPIResults(results: NSDictionary)
}

class APIController {
    
    var delegate: APIControllerProtocol?
    
    init(delegate: APIControllerProtocol?) {
        self.delegate = delegate
    }
    
    func get(path: String) {
        var sn = SwiftNetworking()
        sn.get(path, completionHandler: {(result: AnyObject) -> Void in
            if let dict = result as? NSDictionary {
                self.delegate?.didRecieveAPIResults(dict)
            }
        })
    }
    
    func searchItunesFor(searchTerm: String) {
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        get("https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music&entity=album")
    }
    
    func lookupTrack(collectionId: Int) {
        get("https://itunes.apple.com/lookup?id=\(collectionId)&entity=song")
    }
    
}