//
//  SongPicker.swift
//  BeatForFit
//
//  Created by Grigory Bochkarev on 27.06.16.
//  Copyright © 2016 Grigory Bochkarev. All rights reserved.
//

import Foundation
import MediaPlayer

class SongPicker : NSObject {
    
    let storage = Storage.sharedInstance //storage
    let progressBar : ProgressBar //progress of analizing songs
    let sender : UIViewController //view that contain progress bar
    private let detector : BpmDetector //detecting bpm
    
    init(progressBar : ProgressBar, sender : UIViewController) {
        self.progressBar = progressBar
        self.sender = sender
        self.detector = BpmDetector()
    }
    
}

extension SongPicker : MPMediaPickerControllerDelegate {
    
    //show media picker and set all picked songs
    func mediaPicker(mediaPicker: MPMediaPickerController,didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        sender.dismissViewControllerAnimated(true, completion: {
            self.setCollectinOfSongs(mediaItemCollection)
        })
    }
    
    //if no songs were choosen
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        sender.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //add songs in collection that user choose in media picker
    func setCollectinOfSongs (mediaItemCollection: MPMediaItemCollection) {
        for songs in mediaItemCollection.items {
            //check is that song already in collection
            guard (storage.storedSongs[songs.persistentID.description] == nil ) else {continue}
            guard (songs.assetURL != nil ) else {continue}
            let index = storage.songs.count
            storage.songs.append(Song(item: songs, bpm: nil,index: index))
            storage.storedSongs[songs.persistentID.description] = nil
            storage.persistanceidIndex[songs.persistentID.description] = index
            progressBar.amountOFAnalizingSongs += 1
        }
        //analize(BPM) in background
        NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            self.detector.analize(self.progressBar)
        }
    }

}
