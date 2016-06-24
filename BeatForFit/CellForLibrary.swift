//
//  CellForLibrary.swift
//  FitnessBeat
//
//  Created by Grigory Bochkarev on 19.06.16.
//  Copyright © 2016 Grigory Bochkarev. All rights reserved.
//

import UIKit

class CellForLibrary: UITableViewCell {
    
    @IBOutlet var title: UILabel?
    @IBOutlet var artist: UILabel?
    @IBOutlet var albumImage: UIImageView?
    @IBOutlet var tempo: UILabel?
    
    func set(song: Song) {
        title?.text = song.name
        var subtitle = ""
        if song.artist != nil { subtitle = song.artist! }
        if song.album != nil { subtitle.appendContentsOf(" - \(song.album!)") }
        artist?.text = subtitle
        albumImage?.image = song.image
        if song.bpm != nil {
            tempo?.text = Int((song.bpm)!).description
        } else {
            tempo?.text = song.bpm?.description
        }
    }
    
    
}
