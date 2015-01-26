//
//  ViewController.swift
//  iOSHostApp
//
//  Created by Drew Crawford on 1/26/15.
//  Copyright (c) 2015 DrewCrawfordApps. All rights reserved.
//

import UIKit
import RustBasedFramework

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        println("Spinning up C")
        let cStartTime = NSDate()
        cbench()
        let cEndTime = NSDate()
        println("C version took \(cEndTime.timeIntervalSinceDate(cStartTime))")

        println("Spinning up Rust")
        let startTime = NSDate()
        RustBasedFramework.benchmark()
        let endTime = NSDate()
        println("Rust version took \(endTime.timeIntervalSinceDate(startTime))")
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

