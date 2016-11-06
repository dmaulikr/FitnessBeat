//
//  LibraryViewController.swift
//  FitnessBeat
//
//  Created by Grigory Bochkarev on 13.06.16.
//  Copyright © 2016 Grigory Bochkarev. All rights reserved.
//

import UIKit
import MediaPlayer

class LibraryViewController : UIViewController {
    
    //general
    fileprivate let semaphore = Semaphore(value: 0)
    fileprivate let defaults = UserDefaults.standard

    //progress bar
    @IBOutlet var progress: UIProgressView!
    var progressBar: ProgressBar?

    //Identifiers
    let cellTableIdentifier = "CellForLibrary"
    
    //storage
    let storage = Storage.sharedInstance
    
    //Media Picker
    var songPicker : SongPicker?
    
    //table 
    let dataSource : DataForTable
    let tableDelegate : TableWithSongs
    @IBOutlet var table : UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        self.dataSource = DataForTable(cellTableIdentifier: cellTableIdentifier)
        self.tableDelegate = TableWithSongs()
        super.init(coder: aDecoder)
    }
}

extension LibraryViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        progressBar = ProgressBar(progress: progress)
        songPicker = SongPicker(progressBar: progressBar!, sender: self)
        //Set up table
        table.register(CellForLibrary.self, forCellReuseIdentifier: cellTableIdentifier)
        let nib = UINib(nibName: "CellForLibraryTable", bundle: nil)
        table.register(nib,forCellReuseIdentifier: cellTableIdentifier)
        table.allowsSelection = true
        table.allowsMultipleSelection = true
        table.dataSource = dataSource
        table.delegate = tableDelegate
        table.reloadData()
        //reload data when notificate
        NotificationCenter.default.addObserver(self, selector: #selector(LibraryViewController.loadList(_:)),name:NSNotification.Name(rawValue: "load"), object: nil)
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //save songs for playlist before changing view
    override func viewWillDisappear(_ animated: Bool) {
        if table.indexPathsForSelectedRows != nil {
            for row in table.indexPathsForSelectedRows! {
                self.table.deselectRow(at: row, animated: false)
            }
        }
    }
    
    //media picker
    @IBAction func presentPicker (_ sender:AnyObject) {
        let picker = MPMediaPickerController(mediaTypes:.music)
        picker.delegate = songPicker
        picker.allowsPickingMultipleItems = true
        self.present(picker, animated: true, completion: nil)
    }
    
    func loadList(_ notification: Notification){
        //load data here
        self.table.reloadData()
    }
    
    func showAnalyzeAlert() {
        let alert = UIAlertController(title: "Keep calm", message: "We are analyzing your songs. It will take awhile", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}

