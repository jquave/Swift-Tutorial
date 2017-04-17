//
//  Intro.swift
//  DevelopingiOSAppsUsingSwiftTutorial-Part1
//
//  Created by Jameson Quave on 4/17/17.
//  Copyright © 2017 Jameson Quave. All rights reserved.
//

import Foundation

func Intro() {
    print("Intro")
    
    var myString = "This is my string"
    let someConstant = 40
    let someOtherConstant: Int = 40
    var colorsArray = ["Blue", "Red", "Green", "Yellow"]
    var colorsDictionary = ["PrimaryColor": "Green", "SecondaryColor": "Red"]
    let firstColor = colorsArray[0]
    assert(firstColor == "Blue")
    let aColor = colorsDictionary["PrimaryColor"]
    assert(aColor == "Green")
    
}
