//
//  APIController.swift
//  TestSwift
//
//  Created by Jameson Quave on 6/3/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
    func didRecieveAPIResults(results: NSDictionary)
}

class APIController {
    
    var delegate: APIControllerProtocol?
    
    init(delegate: APIControllerProtocol?) {
        self.delegate = delegate
    }
    
    func get(path: String) {
        let url = NSURL(string: path)
        let request = NSURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
            if error? {
                println("ERROR: \(error.localizedDescription)")
            }
            else {
                var error: NSError?
                let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
                // Now send the JSON result to our delegate object
                if error? {
                    println("HTTP Error: \(error?.localizedDescription)")
                }
                else {
                    println("Results recieved")
                    self.delegate?.didRecieveAPIResults(jsonResult)
                }
            }
        })
    }
    
    func searchItunesFor(searchTerm: String) {
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music&entity=album"
        get(urlPath)
    }
    
    func lookupTrackWithID(trackID: String) {
        
    }
    
}