//
//  Semaphore.swift
//  BeatForFit
//
//  Created by Grigory Bochkarev on 23.06.16.
//  Copyright © 2016 Grigory Bochkarev. All rights reserved.
//

import Foundation

struct Semaphore {
    
    let semaphore: dispatch_semaphore_t
    
    init(value: Int = 0) {
        semaphore = dispatch_semaphore_create(value)
    }
    
    // Blocks the thread until the semaphore is free and returns true
    // or until the timeout passes and returns false
    func wait(nanosecondTimeout: Int64) -> Bool {
        return dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, nanosecondTimeout)) != 0
    }
    
    // Blocks the thread until the semaphore is free
    func wait() {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }
    
    // Alerts the semaphore that it is no longer being held by the current thread
    // and returns a boolean indicating whether another thread was woken
    func signal() -> Bool {
        return dispatch_semaphore_signal(semaphore) != 0
    }
}