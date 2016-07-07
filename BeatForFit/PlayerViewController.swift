//
//  PlayerViewController.swift
//  BeatForFit
//
//  Created by Grigory Bochkarev on 25.06.16.
//  Copyright © 2016 Grigory Bochkarev. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

class PlayerViewController: UIViewController {
   
    //var audioPlayer: AVAudioPlayer?
   // var audioPlayerDelegate = Player()
    let storage = Storage.sharedInstance
    let player = Player.sharedInstance
    var currentBpmIndex = 0
    var allBpm = [Int]()
    
    @IBOutlet var songLabel: UILabel!
    @IBOutlet var bpmLabel: UILabel!
    @IBAction func playButtonPushed(sender: UIButton) {
        if player.isPrepared {
            if player.avPlayer.playing {
                player.avPlayer.pause()
            } else {
                player.playWithBpm((storage.bpmIndexDictionary.first?.0)!)
            }
        } else {
            player.playWithBpm((storage.bpmIndexDictionary.first?.0)!)
        }
    }
    @IBAction func nextSong(sender: UIButton) {
        //implement next song
        player.playNext()
//        currentBpmIndex.1 += 1
//        if storage.bpmIndexDictionary[allBpm[currentBpmIndex.0]]?.count > currentBpmIndex.1 {
//            player.playNext()
//        } else {
//            currentBpmIndex.1 = 0
//            currentBpmIndex.0 += 1
//            if currentBpmIndex.0 < allBpm.count {
//                player.playWithBpm(allBpm[currentBpmIndex.0])
//            } else {
//                currentBpmIndex.0 -= 1
//                player.playWithBpm(allBpm[currentBpmIndex.0])
//            }
//        }
    }
    @IBAction func previousSong(sender: AnyObject) {
        player.toggleAVPlayer()
    }
    @IBAction func doSlow(sender: AnyObject) {
    }
    @IBAction func doFast(sender: AnyObject) {
        currentBpmIndex += 1
        if currentBpmIndex < allBpm.count {
            player.playWithBpm(allBpm[currentBpmIndex])
        } else {
            player.playWithBpm(allBpm[currentBpmIndex-1])
        }
        
    }
}

extension PlayerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        //playArray(storage.arrayOfUrlPlaylist)
        getAllBpm(storage.bpmIndexDictionary)
        bpmLabel.text = allBpm.first?.description
    }
    
    func getAllBpm(bpmDictionary : [Int : [Int]]) {
        allBpm = bpmDictionary.keys.sort({ $0 < $1 }).flatMap({ $0 })
        print(allBpm)
    }
}

    /* The delegate message that will let us know that the player has finished playing an audio file
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("Finished playing the song")
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        /*
         for displaying information about the song in RemoteControlCentre
        let mpic = MPNowPlayingInfoCenter.defaultCenter()
        mpic.nowPlayingInfo = [
            MPMediaItemPropertyTitle: self.titleLabel!.text!,
            MPMediaItemPropertyArtist: self.authorLabel!.text!
        ]
 
 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.observer = NSNotificationCenter.defaultCenter().addObserverForName(
//        AVAudioSessionInterruptionNotification, object: nil, queue: nil) {
//            [weak self](n:NSNotification) in
//            guard let why =
//                n.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt
//                else {return}
//            guard let type = AVAudioSessionInterruptionType(rawValue: why)
//                else {return}
//            if type == .Ended {
//                guard let opt =
//                    n.userInfo![AVAudioSessionInterruptionOptionKey] as? UInt
//                    else {return}
//                let opts = AVAudioSessionInterruptionOptions(rawValue: opt)
//                if opts.contains(.ShouldResume) {
//                    self?.player.prepareToPlay()
//                    self?.player.play()
//                }
//            }
//        }
        /*
        let dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(dispatchQueue, {[weak self] in
                //let mainBundle = NSBundle.mainBundle()
                /* Find the location of our file to feed to the audio player */
                let filePath = self!.storage.allSongs[1].URL?.description
                if let path = filePath{
                    let fileData = NSData(contentsOfFile: path)
                    /* Start the audio player */
                    self!.audioPlayer = try? AVAudioPlayer(data: fileData!)    //(data: fileData, error: &error)
                    /* Did we get an instance of AVAudioPlayer? */
                    if let player = self!.audioPlayer{
                        /* Set the delegate and start playing */
                        player.delegate = self
                        if player.prepareToPlay() && player.play(){
                            /* Successfully started playing */
                        }else{
                            /* Failed to play */
                        } }else{
                        /* Failed to instantiate AVAudioPlayer */
                    } }
                })
    }
 */

    /*
    func remoteControlReceivedWithEvent(event: UIEvent?) {
        let rc = event!.subtype
        let p = audioPlayer  // our AVAudioPlayer
        switch rc {
        case .RemoteControlTogglePlayPause:
            if p.playing { p.pause() } else { p.play() }
        case .RemoteControlPlay:
            p.play()
        case .RemoteControlPause:
            p.pause()
        default:break
        }
    }
    */
}*/*/