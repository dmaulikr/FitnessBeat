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
    fileprivate let detector : BpmDetector //detecting bpm
    
    init(progressBar : ProgressBar, sender : UIViewController) {
        self.progressBar = progressBar
        self.sender = sender
        self.detector = BpmDetector()
    }
    
}

extension SongPicker : MPMediaPickerControllerDelegate {
    
    //show media picker and set all picked songs
    func mediaPicker(_ mediaPicker: MPMediaPickerController,didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        sender.dismiss(animated: true, completion: {
            self.setCollectionOfSongs(mediaItemCollection)
            //Show alert when close picker
            self.showAnalyzeAlert()
        })
    }
    
    //if no songs were chosen
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        sender.dismiss(animated: true, completion: nil)
    }
    
    //add songs in collection that user choose in media picker
    func setCollectionOfSongs (_ mediaItemCollection: MPMediaItemCollection) {
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
        //analyse(BPM) in background
        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: nil)
        DispatchQueue.global(qos: .utility).async {
            self.detector.analize(self.progressBar)
        }
    }
    
    //Alert massage about being patient while the process of analyzing songs
    //Should appear only once
    func showAnalyzeAlert() {
        if !storage.lounchedBefore {
            let alert = UIAlertController(title: "Keep calm", message: "We are analysing your songs. It will take some time", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            storage.lounchedBefore = true
            storage.defaults.set(true, forKey: Constants.Settings.louchedBefore.rawValue)
            sender.present(alert, animated: true, completion: nil)
        }
    }


}
