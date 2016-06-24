//
//  Song.swift
//  FitnessBeat
//
//  Created by Grigory Bochkarev on 15.06.16.
//  Copyright © 2016 Grigory Bochkarev. All rights reserved.
//

import UIKit
import MediaPlayer

class Song: NSObject {
    
    let URL : NSURL?
    let id : String?
    var bpm : Float?
    let name : String?
    let image : UIImage?
    let artist : String?
    let album : String?
    
    init(item: MPMediaItem, bpm: Float?) {
        URL = item.assetURL
        id = item.persistentID.description
        self.bpm = bpm
        name = item.title
        image = item.artwork?.imageWithSize(CGSize(width: 39, height: 39))
        artist = item.artist
        album = item.albumTitle
    }
    
    init(url: NSURL){
        self.URL = url
        self.album = "alb"
        id = "id"
        bpm = 0
        name = "name"
        image = nil
        artist = "art"
    }
}