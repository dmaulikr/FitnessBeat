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
            DispatchQueue.main.async(execute: {
                self.progress.setProgress(fractionalProgress, animated: animated)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: nil)
            })
        }
    }
    init(progress: UIProgressView!) {
        self.progress = progress
        progress.setProgress(0, animated: true)
    }
}
