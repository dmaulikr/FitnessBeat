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
    
    let storage : Storage
    let progressBar : ProgressBar
    let sender : UIViewController
    private let detector : BpmDetector
    
    init(storage: Storage, progressBar : ProgressBar, sender : UIViewController) {
        self.storage = storage
        self.progressBar = progressBar
        self.sender = sender
        self.detector = BpmDetector(storage: storage)
    }
    
}

extension SongPicker : MPMediaPickerControllerDelegate {
    func mediaPicker(mediaPicker: MPMediaPickerController,didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        sender.dismissViewControllerAnimated(true, completion: {
            self.setCollectinOfSongs(mediaItemCollection)
        })
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        sender.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //add songs in collection that user choose in media picker
    func setCollectinOfSongs (mediaItemCollection: MPMediaItemCollection) {
        for songs in mediaItemCollection.items {
            let exist = storage.storedSongs[songs.persistentID.description] != nil
            if (songs.assetURL != nil && !exist) {
                storage.allSongs.append(Song.init(item: songs, bpm:nil))
                progressBar.amountOFAnalizingSongs += 1
            }
            else {
                print("nil songs.assetURL or already exist")
            }
        }
        //analize in background
        NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            self.detector.analize(self.progressBar)
        }
    }

}
