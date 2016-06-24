//
//  LibraryViewController.swift
//  FitnessBeat
//
//  Created by Grigory Bochkarev on 13.06.16.
//  Copyright © 2016 Grigory Bochkarev. All rights reserved.
//

import UIKit
import MediaPlayer
//import RealmSwift



class LibraryViewController: UIViewController,MPMediaPickerControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //general
    let semaphore = Semaphore(value: 0)
    let defaults = NSUserDefaults.standardUserDefaults()

    //progress bar
    @IBOutlet var progress: UIProgressView!
    var amountOFAnalizingSongs : Int = 0
    var counter: Int = 0 {
        didSet {
            let fractionalProgress = Float(counter) / Float(amountOFAnalizingSongs)
            let animated = counter != 0
            dispatch_async(dispatch_get_main_queue(),{
                if fractionalProgress == 1 {self.table.reloadData()}
                self.progress.setProgress(fractionalProgress, animated: animated)
            })
        }
    }
    
    

    

    
    //storage
    var allSongs = [Song]() //during execution
    var storedSongs = [String : Float]() //UserDefaults
    //var storedBPMs = [Float]()  //UserDefaults
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SetUp Table
        table.registerClass(CellForLibrary.self, forCellReuseIdentifier: cellTableIdentifier)
        let nib = UINib(nibName: "CellForLibraryTable", bundle: nil)
        table.registerNib(nib,forCellReuseIdentifier: cellTableIdentifier)
        table.allowsSelection = false
        
        //set up progress bar
        progress.setProgress(0, animated: true)
        
        //retrive data
        storedSongs = defaults.objectForKey("Songs") as? [String: Float] ?? [String: Float]()
        if storedSongs.count>0 {
            findSongWithPersistentIdString(storedSongs)
            }
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //table view
    @IBOutlet var table : UITableView!
    let cellTableIdentifier = "CellForLibrary"
    var nubOfRows = 0
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSongs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellTableIdentifier, forIndexPath: indexPath) as! CellForLibrary
        let song = allSongs[indexPath.row]
        cell.set(song)
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            storedSongs.removeValueForKey(allSongs[indexPath.row].id!)
            allSongs.removeAtIndex(indexPath.row)
            table.reloadData()
            defaults.setObject(storedSongs, forKey: "Songs")
        }
    }
    
    @IBAction func presentPicker (sender:AnyObject) {
        let picker = MPMediaPickerController(mediaTypes:.Music)
        picker.delegate = self
        picker.allowsPickingMultipleItems = true
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController,
                     didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        self.dismissViewControllerAnimated(true, completion: {
            self.setCollectinOfSongs(mediaItemCollection)
            self.nubOfRows = mediaItemCollection.count
        })
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private let beatDetector: TempiBeatDetector = TempiBeatDetector()
    
    func detect(inSong: Song) {
       // let startTime = CFAbsoluteTimeGetCurrent()
        
        
        beatDetector.fileAnalysisCompletionHandler =
        {(
            bpms: [(timeStamp: Double, bpm: Float)],
            mean: Float,
            median: Float,
            mode: Float
            ) in self.setBpm(median, song: inSong)//print(mean, median, mode, CFAbsoluteTimeGetCurrent() - startTime)
            
        }
        
        beatDetector.startFromFile(url: inSong.URL! )
        
    }
    
    func setBpm(bpm: Float, song: Song) {
        song.bpm = bpm
        semaphore.signal()
        storedSongs[song.id!] = bpm
    }

    
    func setCollectinOfSongs (mediaItemCollection: MPMediaItemCollection) {
        for songs in mediaItemCollection.items {
            let exist = storedSongs[songs.persistentID.description] != nil
            if (songs.assetURL != nil && !exist) {
                allSongs.append(Song.init(item: songs, bpm:nil))
                amountOFAnalizingSongs += 1
            }
            else {
                print("nil songs.assetURL or already exist")
            }
        }
        self.table.reloadData()
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            self.analize()
        }
        //defaults.setObject(storedSongs, forKey: "Songs")
    }
    
    func analize() {
        for songs in allSongs {
            if songs.bpm == nil {
                detect(songs)
                semaphore.wait()
                if (counter<amountOFAnalizingSongs) {
                    counter += 1
                } else {
                    counter -= 1
                }
            }
        }
        counter = 0
        amountOFAnalizingSongs = 0
        defaults.setObject(storedSongs, forKey: "Songs")
    }
    
    func findSongWithPersistentIdString(persistentIDString: [String : Float]) {
        for songs in persistentIDString{
            let predicate = MPMediaPropertyPredicate(value: songs.0, forProperty: MPMediaItemPropertyPersistentID)
            let songQuery = MPMediaQuery()
            songQuery.addFilterPredicate(predicate)
            if let items = songQuery.items where items.count > 0 {
                allSongs.append(Song.init(item: items[0], bpm: songs.1))
            }
        }
    }

}

