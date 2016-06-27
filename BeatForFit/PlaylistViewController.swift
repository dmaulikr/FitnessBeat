//
//  PlaylistViewController.swift
//  BeatForFit
//
//  Created by Grigory Bochkarev on 25.06.16.
//  Copyright © 2016 Grigory Bochkarev. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

class PlaylistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let defaultPlaylist = "Playlistsongs"
    
    override func viewDidLoad() {
        //SetUp Table
        table.registerClass(CellForLibrary.self, forCellReuseIdentifier: cellTableIdentifier)
        let nib = UINib(nibName: "CellForLibraryTable", bundle: nil)
        table.registerNib(nib,forCellReuseIdentifier: cellTableIdentifier)
        table.allowsSelection = false
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        defaults.setObject(playlistSongsList, forKey: defaultPlaylist)
    }
    
    //set up playlist every time view appear
    /*
    override func viewWillAppear(animated: Bool) {
        playlistSongsList = defaults.objectForKey(defaultPlaylist) as? [String: Float] ?? [String: Float]()
        if playlistSongsList.count > 0 {
            print("tring to find")
            print(playlistSongsList)
            findSongWithPersistentIdString(playlistSongsList)
        }
        table.reloadData()
    }
    */
    
    override func viewDidAppear(animated: Bool) {
        playlistSongsList = defaults.objectForKey(defaultPlaylist) as? [String: Float] ?? [String: Float]()
        if playlistSongsList.count > 0 {
            print(playlistSongsList)
            findSongWithPersistentIdString(playlistSongsList)
        }
        table.reloadData()
    }
    
    //Collections
    var playlistSongs = [Song]()
    var playlistSongsList = [String: Float]()
    
    //playlist table
    @IBOutlet var table: UITableView!
    let cellTableIdentifier = "CellForLibrary"
    var nubOfRows = 0
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistSongs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellTableIdentifier, forIndexPath: indexPath) as! CellForLibrary
        let song = playlistSongs[indexPath.row]
        cell.set(song)
        return cell
    }
    
    //turn on deletion
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //deletion songs from playlist
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            playlistSongsList.removeValueForKey(playlistSongs[indexPath.row].id!)
            playlistSongs.removeAtIndex(indexPath.row)
            table.reloadData()
        }
    }
    
    
    //play song
    @IBAction func playPlaylist(sender: AnyObject) {
        
    }
    
    
    //Clean playlist
    @IBAction func cleanPlaylist(sender: AnyObject) {
        playlistSongs.removeAll()
        playlistSongsList.removeAll()
        table.reloadData()
        defaults.setObject(playlistSongsList, forKey: defaultPlaylist)
    }
    
    func findSongWithPersistentIdString(persistentIDString: [String : Float]) {
        playlistSongs.removeAll()
        for songs in persistentIDString{
            let predicate = MPMediaPropertyPredicate(value: songs.0, forProperty: MPMediaItemPropertyPersistentID)
            let songQuery = MPMediaQuery()
            songQuery.addFilterPredicate(predicate)
            if let items = songQuery.items where items.count > 0 {
                playlistSongs.append(Song.init(item: items[0], bpm: songs.1))
            }
        }
        //sort by bpm
        playlistSongs.sortInPlace {(song1: Song, song2: Song) -> Bool in
            song1.bpm > song2.bpm
        }
    }
}
