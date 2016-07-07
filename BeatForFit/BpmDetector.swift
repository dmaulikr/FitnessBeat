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
    let storage = Storage.sharedInstance
    
    //detecting can not be parallel
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
        song.bpm = Int(bpm)
        semaphore.signal()
    }
    
    //it's executing in background and showing progress bar
    func analize(progressBar: ProgressBar) {
        for song in storage.songs {
            if song.bpm == nil {
                detect(song)
                //wait until detection finished and then continue
                semaphore.wait()
                if (progressBar.counter<progressBar.amountOFAnalizingSongs) {
                    progressBar.counter += 1
                } else {
                    progressBar.counter -= 1
                }
                //set index of the song to bpm
                guard let bpm = song.bpm else { print("no bpm yet"); continue}
                guard let index = song.index else {print(" no index "); continue}
                if var _ = storage.bpmIndexDictionary[bpm] {
                    storage.bpmIndexDictionary[bpm]!.append(index)
                } else {
                    storage.bpmIndexDictionary[bpm] = [Int]()
                    storage.bpmIndexDictionary[bpm]!.append(index)
                }
                
            }
        }
        progressBar.counter = 0
        progressBar.amountOFAnalizingSongs = 0
        //storage.sortAllSongsByBpm()
    }

    
}
