//
//  DataForTable.swift
//  BeatForFit
//
//  Created by Grigory Bochkarev on 27.06.16.
//  Copyright © 2016 Grigory Bochkarev. All rights reserved.
//

import Foundation
import UIKit


class DataForTable: NSObject {
    
    let cellTableIdentifier : String
    let storage = Storage.sharedInstance
    
    init(cellTableIdentifier : String) {
        self.cellTableIdentifier = cellTableIdentifier
    }
}

extension DataForTable: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {return 1} else {
        return storage.songs.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as UITableViewCell
            cell.textLabel?.text = "Some songs may have double pace"
            cell.detailTextLabel?.text = "Do 2 steps at one beat"
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellTableIdentifier, for: indexPath) as! CellForLibrary
            //let song = storage.allSongs[indexPath.row]
           // let song = storage.allSongs.values[indexPath.row]
            //let song = storage.getSong(indexPath.row)
            let song = storage.songs[indexPath.row]
            cell.set(song)
            return cell
        
        }
    }
    
    //turn on deletion
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {return false}
        else {return true}
    }
    
    //deletion func
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            storage.delSong(indexPath.row)
            
            /*
            if let indexForPlaylist = storage.playlistSongs.indexOf(storage.allSongs[indexPath.row]) {
                storage.playlistSongs.removeAtIndex(indexForPlaylist)
            }
            storage.storedAllSongs.removeValueForKey(storage.allSongs[indexPath.row].id!)
            storage.allSongs.removeAtIndex(indexPath.row)
            
            */
            tableView.reloadData()
        }
    }


}
