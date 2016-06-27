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
    let defaultSongs : String
    let defaults = NSUserDefaults.standardUserDefaults()
    let storage : Storage
    
    
    
    init(storage: Storage, defaultSongs : String, cellTableIdentifier : String) {
        self.storage = storage
        self.cellTableIdentifier = cellTableIdentifier
        self.defaultSongs = defaultSongs
    }
}

extension DataForTable: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storage.allSongs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellTableIdentifier, forIndexPath: indexPath) as! CellForLibrary
        let song = storage.allSongs[indexPath.row]
        cell.set(song)
        return cell
    }
    
    //turn on deletion
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //deletion func
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            storage.storedSongs.removeValueForKey(storage.allSongs[indexPath.row].id!)
            storage.selectedSongs.removeValueForKey(storage.allSongs[indexPath.row].id!)
            storage.allSongs.removeAtIndex(indexPath.row)
            tableView.reloadData()
            defaults.setObject(storage.storedSongs, forKey: defaultSongs)
        }
    }


}