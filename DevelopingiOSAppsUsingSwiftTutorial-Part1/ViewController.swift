//
//  ViewController.swift
//  DevelopingiOSAppsUsingSwiftTutorial-Part1
//
//  Created by Jameson Quave on 4/17/17.
//  Copyright © 2017 Jameson Quave. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "MyTestCell")
        
        cell.textLabel?.text = "Row \(indexPath.row)"
        cell.detailTextLabel?.text = "Subtitle \(indexPath.row)"
        
        return cell
    }

}

