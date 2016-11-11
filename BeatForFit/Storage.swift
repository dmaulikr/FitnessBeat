//
//  Storage.swift
//  BeatForFit
//
//  Created by Grigory Bochkarev on 27.06.16.
//  Copyright © 2016 Grigory Bochkarev. All rights reserved.
//

import Foundation
import MediaPlayer
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
//fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l < r
//  case (nil, _?):
//    return true
//  default:
//    return false
//  }
//}

enum consatnts {
    
}


class Storage: NSObject {
    
    //SINGLETON Contains all data
    static let sharedInstance = Storage()
    let defaults = UserDefaults.standard
    
    var playlistIndexes = [Int]()
    var bpmIndexDictionary  = [Int : [Int]]()
    var songs = [Song]()
    var persistanceidIndex = [String : Int]()
    var arrayOfUrlPlaylist = [URL]()
    
    var storedSongs = [String : Int]()
    
    let defaultAllSongs = "Songs1"
    let defaultPlaylist = "Playlistsogs1"
    let defaultIndex = "Index1"
    let defaultBpmIndex = "BpmIndex1"
    
    //set up and load
    fileprivate override init() {
        super.init()
        
        //bpmIndexDictionary = defaults.objectForKey(defaultBpmIndex) as? [Int : [Int]] ?? [Int : [Int]]()
        playlistIndexes = defaults.array(forKey: defaultPlaylist) as? [Int] ?? [Int]()
        storedSongs = defaults.object(forKey: defaultAllSongs) as? [String: Int] ?? [String: Int]()
        persistanceidIndex = defaults.object(forKey: defaultIndex) as? [String : Int] ?? [String : Int]()
        
        if storedSongs.count > 0 {
            songs = findSongWithPersistentIdString1(storedSongs)
        }
        generateBpmIndex()
    }
    
    //save all data to USERDEFAULTS
    func saveALL() {
        storedSongs = copySongsInDictionary(songs)
        defaults.set(storedSongs, forKey: defaultAllSongs)
        defaults.set(playlistIndexes, forKey: defaultPlaylist)
        defaults.set(persistanceidIndex, forKey: defaultIndex)
    }
    
    func delSong(_ index: Int) {
        if let id = songs[index].id { persistanceidIndex.removeValue(forKey: id)}
        if let bpm = songs[index].bpm {
            if var arrOfIndexWithBpm = bpmIndexDictionary[bpm] {
                if let indexBpm = arrOfIndexWithBpm.index(of: index) {
                    arrOfIndexWithBpm.remove(at: indexBpm)
                    bpmIndexDictionary[bpm] = arrOfIndexWithBpm
                }
            }

        }
        songs.remove(at: index)
        if let indexInPlaylist =  playlistIndexes.index(of: index) {
           playlistIndexes.remove(at: indexInPlaylist)
        }

    }
    
    //convert saved in UserDefaults dictionaries to array of Songs TO DELETE
    func findSongWithPersistentIdString1(_ persistentIDString: [String : Int]) -> [Song] {
        var arrayOfSongs = [Song]()
        for songs in persistentIDString{
            let predicate = MPMediaPropertyPredicate(value: songs.0, forProperty: MPMediaItemPropertyPersistentID)
            let songQuery = MPMediaQuery()
            songQuery.addFilterPredicate(predicate)
            if let items = songQuery.items, items.count > 0 {
                arrayOfSongs.append(Song(item: items[0], bpm: songs.1, index: persistanceidIndex[songs.0]))
            }
        }
        //sort by index
        arrayOfSongs.sort {(song1: Song, song2: Song) -> Bool in
            if let index1 = song1.index {
                if let index2 = song2.index {
                   return index1 < index2
                }
            }
            return true
        }
        return arrayOfSongs
    }
    
    func generateArrayOfURL(_ isPlaylist: Bool) {
        arrayOfUrlPlaylist.removeAll()
        if isPlaylist {
            for index in playlistIndexes {
                if let Url = songs[index].URL {arrayOfUrlPlaylist.append(Url as URL)}
            }
        }
        print(arrayOfUrlPlaylist)
    }
    
    func generateBpmIndex() {
        for song in songs {
            guard let bpm = song.bpm else { print("no bpm yet"); continue}
            guard let index = song.index else {print(" no index "); continue}
            if var _ = bpmIndexDictionary[bpm] {
                bpmIndexDictionary[bpm]!.append(index)
            } else {
                bpmIndexDictionary[bpm] = [Int]()
                bpmIndexDictionary[bpm]!.append(index)
            }

        }
    }
    
    func getSongFromUrl(_ url: URL) -> Song? {
        for song in songs {
            if song.URL == url {
                return song
            }
        }
        return nil
    }
    
    //save array of Song to dictionary for storing in UserDefaults
    func copySongsInDictionary(_ arrayOfSongs: [Song]) -> [String : Int] {
        var dicOfSongs = [String : Int]()
        for song in arrayOfSongs {
            guard let songID = song.id else {
                continue
            }
            dicOfSongs[songID] = song.bpm
        }
        return dicOfSongs
    }
    
}
