//
//  Storage.swift
//  BeatForFit
//
//  Created by Grigory Bochkarev on 27.06.16.
//  Copyright © 2016 Grigory Bochkarev. All rights reserved.
//

import Foundation
import MediaPlayer

struct Constants {
    enum Settings : String {
        case louchedBefore
    }
    enum Data : String {
        case allSongs
        case playlist
        case persistanceIndex
    }
}

class Storage: NSObject {
    
    //SINGLETON Contains all data
    static let sharedInstance = Storage()
    let defaults = UserDefaults.standard
    
    //Data
    var playlistIndexes : [Int] //Indexes in 'songs' for playlist. The song oject stored only in 'songs' and avaliable by index for playlist
    var bpmIndexDictionary  : [Int : [Int]] //All bpms for playing in player ex. 2 songs of 132bpm, 3 songs of 145bpm
    //TODO: make a range of bpm category like from 120-130bpm,130-140,  etc.
    var songs : [Song] //All songs are stored here
    var persistanceidIndex : [String : Int] //the permanent id of songs in local library
    var arrayOfUrlPlaylist : [URL] //plaulist songs URL for using it in player.
    var storedSongs : [String : Int] //songs for storing it in UserDefaults, then convert it to [Song]
    
    
    //Settings
    var lounchedBefore : Bool
    
    
    //set up and load
    fileprivate override init() {
        songs = [Song]()
        bpmIndexDictionary = [Int : [Int]]()
        arrayOfUrlPlaylist = [URL]()
        
        lounchedBefore = defaults.bool(forKey: Constants.Settings.louchedBefore.rawValue)
        playlistIndexes = defaults.array(forKey: Constants.Data.playlist.rawValue) as? [Int] ?? [Int]()
        storedSongs = defaults.object(forKey: Constants.Data.allSongs.rawValue) as? [String: Int] ?? [String: Int]()
        persistanceidIndex = defaults.object(forKey: Constants.Data.persistanceIndex.rawValue) as? [String : Int] ?? [String : Int]()
        
        super.init()
        
        if storedSongs.count > 0 {
            songs = findSongWithPersistentIdString1(storedSongs)
        }
        generateBpmIndex()
    }
    
    //save all data to USERDEFAULTS
    func saveALL() {
        storedSongs = copySongsInDictionary(songs)
        defaults.set(storedSongs, forKey: Constants.Data.allSongs.rawValue)
        defaults.set(playlistIndexes, forKey: Constants.Data.playlist.rawValue)
        defaults.set(persistanceidIndex, forKey: Constants.Data.persistanceIndex.rawValue)
    }
    
    //delete Song by index
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
    
    //convert saved in UserDefaults dictionaries to array of Songs
    func findSongWithPersistentIdString1(_ persistentIDString: [String : Int]) -> [Song] {
        var arrayOfSongs = [Song]()
        for songs in persistentIDString {
            let predicate = MPMediaPropertyPredicate(value: songs.0, forProperty: MPMediaItemPropertyPersistentID)
            let songQuery = MPMediaQuery()
            songQuery.addFilterPredicate(predicate)
            if let items = songQuery.items, items.count > 0 {
                arrayOfSongs.append(Song(item: items[0], bpm: songs.1, index: persistanceidIndex[songs.0]))
            }
        }
        //sort by index
        arrayOfSongs.sort(by: {(song1: Song, song2: Song) -> Bool in
        if let index1 = song1.index {
            if let index2 = song2.index {
                return index1 < index2
            }
        }
        return true
        })
        return arrayOfSongs
    }
    
    //Player uses URL for playing songs, so retrieve URL from 'songs : [Song]'
    func generateArrayOfURL(_ isPlaylist: Bool) {
        arrayOfUrlPlaylist.removeAll()
        if isPlaylist {
            for index in playlistIndexes {
                if let Url = songs[index].URL {arrayOfUrlPlaylist.append(Url as URL)}
            }
        }
    }
    
    //make a list of all bpm's like: 2 songs of 132 bpm, 5 of 145bpm
    //TODO: make a range of bpm like: 120-130bpm, 140-150 etc
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
    
    //make Song from URL if it contains in App's library
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
