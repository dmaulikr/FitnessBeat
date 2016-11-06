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
    
    let storage = Storage.sharedInstance
    let player = Player.sharedInstance
    
    override func viewDidLoad() {
        //SetUp Table
        table.register(CellForLibrary.self, forCellReuseIdentifier: cellTableIdentifier)
        let nib = UINib(nibName: "CellForLibraryTable", bundle: nil)
        table.register(nib,forCellReuseIdentifier: cellTableIdentifier)
        table.allowsSelection = false
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        table.reloadData()
    }
    
    //playlist table
    @IBOutlet var table: UITableView!
    let cellTableIdentifier = "CellForLibrary"
    var nubOfRows = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storage.playlistIndexes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellTableIdentifier, for: indexPath) as! CellForLibrary
       // let song = storage.playlistSongs[indexPath.row]
        let song = storage.songs[storage.playlistIndexes[indexPath.row]]
        cell.set(song)
        return cell
    }
    
    //turn on deletion
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //deletion songs from playlist
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete
            storage.playlistIndexes.remove(at: indexPath.row)
            table.reloadData()
        }
    }
    
    
    //play song
    @IBAction func playPlaylist(_ sender: AnyObject) {
        guard storage.playlistIndexes.count != 0 else {return}
        storage.generateArrayOfURL(true)
        player.setupPlayList(storage.arrayOfUrlPlaylist)
        player.setupAudioPlayer()
        player.playTrack()
        //TODO: highlight playing song
        //TODO: play selected song in playlist
    }
    
        
    
    //Clean playlist
    @IBAction func cleanPlaylist(_ sender: AnyObject) {
        storage.playlistIndexes.removeAll()
        storage.arrayOfUrlPlaylist.removeAll()
        table.reloadData()
    }
}
