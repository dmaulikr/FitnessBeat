//
//  Semaphore.swift
//  BeatForFit
//
//  Created by Grigory Bochkarev on 23.06.16.
//  Copyright © 2016 Grigory Bochkarev. All rights reserved.
//

import Foundation

struct Semaphore {
    
    let semaphore: DispatchSemaphore
    
    init(value: Int = 0) {
        semaphore = DispatchSemaphore(value: value)
    }
    
    // Blocks the thread until the semaphore is free and returns true
    // or until the timeout passes and returns false
    func wait(_ nanosecondTimeout: Int64) -> Bool {
        return semaphore.wait(timeout: DispatchTime.now() + Double(nanosecondTimeout) / Double(NSEC_PER_SEC)) != DispatchTimeoutResult.success
    }
    
    // Blocks the thread until the semaphore is free
    func wait() {
        semaphore.wait(timeout: DispatchTime.distantFuture)
    }
    
    //@discardableResult
    // Alerts the semaphore that it is no longer being held by the current thread
    // and returns a boolean indicating whether another thread was woken
    func signal() -> Bool {
        return semaphore.signal() != 0
    }

}
