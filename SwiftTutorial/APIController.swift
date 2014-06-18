//
//  APIController.swift
//  SwiftTutorial
//
//  Created by Jameson Quave on 6/16/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//

import UIKit

protocol APIControllerProtocol {
    func didReceiveAPIResults(results: NSDictionary)
}

class APIController: NSObject {

    var delegate: APIControllerProtocol?
    
    func searchItunesFor(searchTerm: String) {
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ",
            withString: "+",
            options: NSStringCompareOptions.CaseInsensitiveSearch,
            range: nil)
        
        // Now escape anything else that isn't URL-friendly
        let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
        let url: NSURL = NSURL(string: urlPath)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            println("Search: Task completed")
            if error {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            } else {
                var errorJson: NSError?
                let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &errorJson) as NSDictionary
                if errorJson? {
                    // If there is an error parsing JSON, print it to the console
                    println("JSON Error \(errorJson!.localizedDescription)")
                } else {
                    // Now send the JSON result to our delegate object
                    self.delegate?.didReceiveAPIResults(jsonResult)
                }
            }
        })
        task.resume()
    }
    
}
