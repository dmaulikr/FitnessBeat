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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {return 1} else {
        return storage.songs.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("noteCell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = "Some songs may have double pace"
            cell.detailTextLabel?.text = "Do 2 steps at one beat"
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(cellTableIdentifier, forIndexPath: indexPath) as! CellForLibrary
            //let song = storage.allSongs[indexPath.row]
           // let song = storage.allSongs.values[indexPath.row]
            //let song = storage.getSong(indexPath.row)
            let song = storage.songs[indexPath.row]
            cell.set(song)
            return cell
        
        }
    }
    
    //turn on deletion
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 {return false}
        else {return true}
    }
    
    //deletion func
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
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