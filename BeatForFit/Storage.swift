//
//  Storage.swift
//  BeatForFit
//
//  Created by Grigory Bochkarev on 27.06.16.
//  Copyright © 2016 Grigory Bochkarev. All rights reserved.
//

import Foundation
import MediaPlayer

class Storage: NSObject {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var allSongs = [Song]() //during execution
    var storedSongs = [String : Float]() //UserDefaults persistanceID : BPM
    var selectedSongs = [String : Float]() //UserDefaults for playlist persistanceID : BPM
    
    let defaultSongs = "Songs"
    let defaultPlaylist = "Playlistsogs"
    
    override init() {
        super.init()
        storedSongs = defaults.objectForKey(defaultSongs) as? [String: Float] ?? [String: Float]()
        selectedSongs = defaults.objectForKey(defaultPlaylist) as? [String: Float] ?? [String: Float]()
        if storedSongs.count>0 {
            findSongWithPersistentIdString(storedSongs)
        }
    }
    func findSongWithPersistentIdString(persistentIDString: [String : Float]) {
        for songs in persistentIDString{
            let predicate = MPMediaPropertyPredicate(value: songs.0, forProperty: MPMediaItemPropertyPersistentID)
            let songQuery = MPMediaQuery()
            songQuery.addFilterPredicate(predicate)
            if let items = songQuery.items where items.count > 0 {
                allSongs.append(Song.init(item: items[0], bpm: songs.1))
            }
        }
        //sort by bpm
        allSongs.sortInPlace {(song1: Song, song2: Song) -> Bool in
            song1.bpm > song2.bpm
        }
    }
    
    func sortByBpm() {
        allSongs.sortInPlace {(song1: Song, song2: Song) -> Bool in
            song1.bpm > song2.bpm
        }
    }

}