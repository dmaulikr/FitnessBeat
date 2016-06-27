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
    
    let storage : Storage
    
    init(storage: Storage) {
        self.storage = storage
    }
}

extension TableWithSongs : UITableViewDelegate {
        
        
        //selecting for playlist
        //TODO: alert message about bpm
        func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
            if ((tableView.indexPathsForSelectedRows?.contains(indexPath)) != nil) {
                //unselect when double tap
                if tableView.indexPathsForSelectedRows!.contains(indexPath) == true{
                    tableView.deselectRowAtIndexPath(indexPath, animated:false)
                    storage.selectedSongs.removeValueForKey(storage.allSongs[indexPath.row].id!)
                    return nil
                }
            }
            return indexPath
        }
        
        //add selected songs in playlist dictionary
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            storage.selectedSongs[storage.allSongs[indexPath.row].id!] = storage.allSongs[indexPath.row].bpm
            //print(selectedSongs)
        }
        
        
        
        func newLabelWithTitle(title: String) -> UILabel {
            
            let label = UILabel()
            label.text = title
            label.backgroundColor = UIColor.clearColor()
            label.sizeToFit()
            return label
        }
        
        func newViewForHeaderOrFooterWithText(text: String) -> UIView{
            
            let headerLabel = newLabelWithTitle(text)
            
            /* Move the label 10 points to the right */
            headerLabel.frame.origin.x += 10
            
            /* Go 5 points down in y axis */
            headerLabel.frame.origin.y = 5
            
            /* Give the container view 10 points more in width than our label because the label needs a 10 extra points left-margin */
            let resultFrame = CGRect(x: 0,
                                     y: 0,
                                     width: headerLabel.frame.size.width + 10,
                                     height: headerLabel.frame.size.height)
            let headerView = UIView(frame: resultFrame)
            headerView.addSubview(headerLabel)
            return headerView
        }
        
        func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 30
        }
        func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            return newViewForHeaderOrFooterWithText("For some songs BPMx2 = 2 steps for one beat")
        }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return newViewForHeaderOrFooterWithText("For some songs BPMx2 = 2 steps for one beat")
    }

    }

