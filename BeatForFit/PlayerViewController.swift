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
    var isShuffle = false
    
    @IBOutlet var playButton: UIButton!
    @IBOutlet var songLabel: UILabel!
    @IBOutlet var artistLable: UILabel!
    @IBOutlet var bpmLabel: UILabel!
    @IBOutlet var repeatButtonOutlet: UIButton!
    @IBAction func playButtonPushed(sender: UIButton) {
        if player.isPlaying {
            player.pauseTrack()
            playButton.setImage(UIImage(named: "Play"), forState: .Normal)
        } else if player.isPoused {
            player.playTrack()
            playButton.setImage(UIImage(named: "pause"), forState: .Normal)
        } else {
        playCurrentBpm()
        playButton.setImage(UIImage(named: "pause"), forState: .Normal)
        }
    }
    
    @IBAction func repetTouched(sender: UIButton) {
        player.isRepeat = !player.isRepeat
        if player.isRepeat {
            sender.setImage(UIImage(named: "hightRep"), forState: .Normal)
        } else {
            sender.setImage(UIImage(named: "repeat"), forState: .Normal)
        }
        
    }
    @IBAction func repeatButton(sender: AnyObject) {
       // player.isRepeat = !player.isRepeat
//        if player.isRepeat {
//            repeatButtonOutlet.selected = true
//            sender.selected = true
//            //repeatButtonOutlet.setTitle("🔁", forState: UIControlState.Normal)
//        } else {
//            repeatButtonOutlet.selected = false
//            sender.selected = false
//        //repeatButtonOutlet.setTitle("↪️", forState: UIControlState.Normal)
//        }
    }
    func playCurrentBpm() {
        var arrayOfUrl = [NSURL]()
        if let bpm = Int(bpmLabel.text!) {
            if let arrayOfIndexes = storage.bpmIndexDictionary[bpm] {
                for index in arrayOfIndexes {
                    if let url = storage.songs[index].URL {
                        arrayOfUrl.append(url)
                    }
                }
            }
        }
        player.setupPlayList(arrayOfUrl)
        player.setupAudioPlayer()
        player.playTrack()
        setTitle()
    }
    
    func setTitle() {
        guard let song = player.currentSong else {return}
        let artist = song.artist
        let name = song.name
        if artist != nil {
            artistLable.text = artist!
        }
        if name != nil {
            songLabel.text = name!
        }
    }
    
    @IBAction func suffleTouched(sender: UIButton) {
        if isShuffle {
            sender.setImage(UIImage(named: "hightShuffle" ), forState: .Normal)
        } else {
            sender.setImage(UIImage(named: "shuffle" ), forState: .Normal)
        }
        isShuffle = !isShuffle
    }
    
    @IBAction func nextSong(sender: UIButton) {
        player.playNextTrack()
        bpmLabel.text = player.currentBpm?.description
        setTitle()
    }
    @IBAction func previousSong(sender: AnyObject) {
        player.playPrevTrack()
        bpmLabel.text = player.currentBpm?.description
        setTitle()
    }
    @IBAction func doSlow(sender: AnyObject) {
        currentBpmIndex -= 1
        guard currentBpmIndex >= 0 else {currentBpmIndex = 0; return}
        print(currentBpmIndex)
        bpmLabel.text = allBpm[currentBpmIndex].description
        playCurrentBpm()
        setTitle()
    }
    @IBAction func doFast(sender: AnyObject) {
        currentBpmIndex += 1
        guard currentBpmIndex < allBpm.count else {currentBpmIndex = allBpm.count - 1; return}
        print(currentBpmIndex)
        bpmLabel.text = allBpm[currentBpmIndex].description
        playCurrentBpm()
        setTitle()
    }
}

extension PlayerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        repeatButtonOutlet.setImage(UIImage(named: "hightRep"), forState: .Normal)
        let mpic = MPNowPlayingInfoCenter.defaultCenter()
        if let song = player.currentSong {
            var artist = song.artist
            var name = song.name
            if artist == nil {
                artist = ""
            }
            if name == nil {
                name = ""
            }
            mpic.nowPlayingInfo = [
                MPMediaItemPropertyTitle: name!,
                MPMediaItemPropertyArtist: artist!
            ]
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        //playArray(storage.arrayOfUrlPlaylist)
        getAllBpm(storage.bpmIndexDictionary)
        if player.isPlaying {
            bpmLabel.text = player.currentBpm?.description
            playButton.setImage(UIImage(named: "pause"), forState: .Normal)
        } else {
            bpmLabel.text = allBpm.first?.description
            playButton.setImage(UIImage(named: "Play"), forState: .Normal)
        }
        setTitle()
        //for displaying information about the song in RemoteControlCentre
    }
 
    func getAllBpm(bpmDictionary : [Int : [Int]]) {
        allBpm = bpmDictionary.keys.sort({ $0 < $1 }).flatMap({ $0 })
        print(allBpm)
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) {
        let rc = event!.subtype
        switch rc {
        case .RemoteControlTogglePlayPause:
            if player.isPlaying {
                player.pauseTrack()
            } else if player.isPoused {
                player.playTrack()
            } else {
                playCurrentBpm()
            }
        case .RemoteControlPlay:
            if player.isPoused {
                player.playTrack()
            } else {
                playCurrentBpm()
            }

        case .RemoteControlPause:
            player.pauseTrack()
            
        case .RemoteControlNextTrack:
            player.playNextTrack()
            bpmLabel.text = player.currentBpm?.description
            setTitle()
        case .RemoteControlPreviousTrack:
            player.playPrevTrack()
            bpmLabel.text = player.currentBpm?.description
            setTitle()
        default:break
        }
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