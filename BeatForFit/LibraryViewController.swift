//
//  LibraryViewController.swift
//  FitnessBeat
//
//  Created by Grigory Bochkarev on 13.06.16.
//  Copyright © 2016 Grigory Bochkarev. All rights reserved.
//

import UIKit
import MediaPlayer

class LibraryViewController : UIViewController { //, UITableViewDataSource, UITableViewDelegate {
    
    //general
    private let semaphore = Semaphore(value: 0)
    private let defaults = NSUserDefaults.standardUserDefaults()

    //progress bar
    @IBOutlet var progress: UIProgressView!
    var progressBar: ProgressBar?

    //Identifiers
    let defaultSongs = "Songs"
    let defaultPlaylist = "Playlistsongs"
    let cellTableIdentifier = "CellForLibrary"
    
    //storage
    var storage : Storage
    
    //Media Picker
    var songPicker : SongPicker?
    
    //table 
    let dataSource : DataForTable
    let tableDelegate : TableWithSongs
    @IBOutlet var table : UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        self.storage = Storage()
        self.dataSource = DataForTable(storage: storage, defaultSongs: defaultSongs, cellTableIdentifier: cellTableIdentifier)
        self.tableDelegate = TableWithSongs(storage: storage)
        super.init(coder: aDecoder)
    }
}

extension LibraryViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        progressBar = ProgressBar(progress: progress)
        songPicker = SongPicker(storage: storage, progressBar: progressBar!, sender: self)
        //Set up table
        table.registerClass(CellForLibrary.self, forCellReuseIdentifier: cellTableIdentifier)
        let nib = UINib(nibName: "CellForLibraryTable", bundle: nil)
        table.registerNib(nib,forCellReuseIdentifier: cellTableIdentifier)
        table.allowsSelection = true
        table.allowsMultipleSelection = true
        table.dataSource = dataSource
        table.delegate = tableDelegate
        table.reloadData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LibraryViewController.loadList(_:)),name:"load", object: nil)
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //save songs for playlist before changing view
    override func viewWillDisappear(animated: Bool) {
        defaults.setObject(storage.selectedSongs, forKey: defaultPlaylist)
        if table.indexPathsForSelectedRows != nil {
            for row in table.indexPathsForSelectedRows! {
                self.table.deselectRowAtIndexPath(row, animated: false)
            }
        }
        storage.selectedSongs.removeAll()
    }
    
    //media picker
    @IBAction func presentPicker (sender:AnyObject) {
        let picker = MPMediaPickerController(mediaTypes:.Music)
        picker.delegate = songPicker
        picker.allowsPickingMultipleItems = true
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func loadList(notification: NSNotification){
        //load data here
        self.table.reloadData()
    }
    
}

