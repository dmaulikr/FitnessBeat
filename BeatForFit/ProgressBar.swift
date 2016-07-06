//
//  ProgressBar.swift
//  BeatForFit
//
//  Created by Grigory Bochkarev on 27.06.16.
//  Copyright © 2016 Grigory Bochkarev. All rights reserved.
//

import Foundation
import UIKit

class ProgressBar : NSObject {
    //progress bar
    var progress: UIProgressView!
    var amountOFAnalizingSongs : Int = 0
    var counter: Int = 0 {
        didSet {
            let fractionalProgress = Float(counter) / Float(amountOFAnalizingSongs)
            let animated = counter != 0
            dispatch_async(dispatch_get_main_queue(),{
                self.progress.setProgress(fractionalProgress, animated: animated)
                if fractionalProgress == 1 {
                    //reload table when analize complete 
                    NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
                    sleep(1)
                }
            })
        }
    }
    init(progress: UIProgressView!) {
        self.progress = progress
        progress.setProgress(0, animated: true)
    }
}
