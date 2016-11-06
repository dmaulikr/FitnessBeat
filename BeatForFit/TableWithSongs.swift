//
//  TableWithSongs.swift
//  BeatForFit
//
//  Created by Grigory Bochkarev on 27.06.16.
//  Copyright © 2016 Grigory Bochkarev. All rights reserved.
//

import Foundation
import UIKit

class TableWithSongs: NSObject {
    
    let storage = Storage.sharedInstance
}

extension TableWithSongs : UITableViewDelegate {
    
    //remove song from playlist when deselecting 
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let indexInPlaylist = storage.playlistIndexes.index(of: indexPath.row) {
            storage.playlistIndexes.remove(at: indexInPlaylist)
        }
        /*
        if let indexOfSong = storage.playlistSongs.indexOf(storage.allSongs[indexPath.row]) {
            storage.playlistSongs.removeAtIndex(indexOfSong)
        }
        */
    }
    
        
    //add selected songs in playlist dictionary
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //storage.playlistSongs.append(storage.allSongs[indexPath.row])
        storage.playlistIndexes.append(indexPath.row)
    }
}

