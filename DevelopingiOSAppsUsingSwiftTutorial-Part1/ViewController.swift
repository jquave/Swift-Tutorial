//
//  ViewController.swift
//  DevelopingiOSAppsUsingSwiftTutorial-Part1
//
//  Created by Jameson Quave on 4/17/17.
//  Copyright © 2017 Jameson Quave. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var appsTableView: UITableView!
    var tableData = [[String: String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchItunes(searchTerm: "JQ Software")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "MyTestCell")
        
        // Get the app from the list at this row's index
        let app = tableData[indexPath.row]
        
        // Pull out the relevant strings in the app record
        cell.textLabel?.text = app["appName"]
        cell.detailTextLabel?.text = app["price"]
        
        return cell
    }
    
    func didReceive(searchResult: [String: Any]) {
        // Make sure the results are in the expected format of [String: Any]
        guard let results = searchResult["results"] as? [[String: Any]] else {
            print("Could not process search results...")
            return
        }
        
        // Create a temporary place to add the new list of app details to
        var apps = [[String: String]]()
        
        // Loop through all the results...
        for result in results {
            // Check that we have String values for each key we care about
            if let thumbnailURLString = result["artworkUrl100"] as? String,
                let appName = result["trackName"] as? String,
                let price = result["formattedPrice"] as? String {
                // All three data points are valid, add the record to the list
                apps.append(
                    [
                        "thumbnailURLString": thumbnailURLString,
                        "appName": appName,
                        "price": price
                    ]
                )
            }
        }
        // Update our tableData variable as a way to store
        // the list of app's data we pulled out of the JSON
        tableData = apps
        
        // Refresh the table with the new data
        DispatchQueue.main.async {
            self.appsTableView.reloadData()
        }
    }
    
    func searchItunes(searchTerm: String) {
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let itunesSearchTerm = searchTerm.replacingOccurrences(of: " ", with: "+", options: .caseInsensitive, range: nil)
        // Also replace every character with a percent encoding
        let escapedSearchTerm = itunesSearchTerm.addingPercentEncoding(withAllowedCharacters: [])!
        
        // This is the URL that Apple offers for their search API
        let urlString = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                // If there is an error in the web request, print it to the console
                print(error)
                return
            }
            // Because we'll be calling a function that can throw an error
            // we need to wrap the attempt inside of a do { } block
            // and catch any error that comes back inside the catch block
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.didReceive(searchResult: jsonResult)
            }
            catch let err {
                print(err.localizedDescription)
            }
            // Close the dataTask block, and call resume() in order to make it run immediately
        }.resume()
    }

}

