//
//  BpmDetector.swift
//  BeatForFit
//
//  Created by Grigory Bochkarev on 27.06.16.
//  Copyright © 2016 Grigory Bochkarev. All rights reserved.
//

import Foundation

class BpmDetector: NSObject {
    
    //detecting bpm
    private let beatDetector: TempiBeatDetector = TempiBeatDetector()
    let semaphore = Semaphore(value: 0)
    let defaults = NSUserDefaults.standardUserDefaults()
        
    let defaultSongs = "Songs"
    let storage: Storage

    init(storage: Storage) {
        self.storage = storage
    }
    
    //detecting can not be parallel, but
    //TODO: check is it efficient to create TempiBeatDetector instance in multithreading
    func detect(inSong: Song) {
        
        beatDetector.fileAnalysisCompletionHandler =
            {(
                bpms: [(timeStamp: Double, bpm: Float)],
                mean: Float,
                median: Float,
                mode: Float
                ) in self.setBpm(median, song: inSong)
                
        }
        beatDetector.startFromFile(url: inSong.URL! )
    }
    
    //set bpm when finished detecting
    func setBpm(bpm: Float, song: Song) {
        song.bpm = bpm
        semaphore.signal()
        storage.storedSongs[song.id!] = bpm
    }
    
    //it's executing in background and showing progress bar
    func analize(progressBar: ProgressBar) {
        for songs in storage.allSongs {
            if songs.bpm == nil {
                detect(songs)
                //wait until detection finished and then continue
                semaphore.wait()
                if (progressBar.counter<progressBar.amountOFAnalizingSongs) {
                    progressBar.counter += 1
                } else {
                    progressBar.counter -= 1
                }
            }
        }
        progressBar.counter = 0
        progressBar.amountOFAnalizingSongs = 0
        storage.sortByBpm()
        defaults.setObject(storage.storedSongs, forKey: defaultSongs)
    }

    
}
