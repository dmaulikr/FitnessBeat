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
   
    let storage = Storage.sharedInstance
    let player = Player.sharedInstance
    var currentBpmIndex = 0
    var currentSongInBpmIndex = 0
    var allBpm = [Int]()
    var isShuffle = false
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var songLabel: UILabel!
    @IBOutlet var artistLable: UILabel!
    @IBOutlet var bpmLabel: UILabel!
    @IBOutlet var repeatButtonOutlet: UIButton!
    @IBAction func playButtonPushed(_ sender: AnyObject) {
        if player.isPlaying {
            player.pauseTrack()
            playButton.setImage(UIImage(named: "Play"), for: UIControlState())
        } else if player.isPoused {
            player.playTrack()
            playButton.setImage(UIImage(named: "pause"), for: UIControlState())
        } else {
        playButton.setImage(UIImage(named: "pause"), for: UIControlState())
        playCurrentBpm()
        }
    }
    
    @IBAction func repetTouched(_ sender: UIButton) {
        player.isRepeat = !player.isRepeat
        if player.isRepeat {
            sender.setImage(UIImage(named: "hightRep"), for: UIControlState())
        } else {
            sender.setImage(UIImage(named: "repeat"), for: UIControlState())
        }
        
    }
    @IBAction func repeatButton(_ sender: AnyObject) {
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
    func playCurrentBpm(playSong: Bool = true) {
        var arrayOfUrl = [URL]()
        if let bpmText = bpmLabel.text {
            if let currentBpm = Int(bpmText) {
                if let arrayOfIndexes = storage.bpmIndexDictionary[currentBpm] {
                    for index in arrayOfIndexes {
                        if let url = storage.songs[index].URL {
                            arrayOfUrl.append(url as URL)
                        }
                    }
                }
                player.setupPlayList(arrayOfUrl)
                player.setupAudioPlayer()
                if playSong {
                    player.playTrack()
                }
                setTitle()
            } else {
                showNoSongAlert()
            }
        } else {
            showNoSongAlert()
        }
    }
    
    func setTitle() {
        let mpic = MPNowPlayingInfoCenter.default()
        guard let song = player.currentSong else {print("no song for setting title");return}
        let artist = song.artist
        let name = song.name
        if artist != nil {
            artistLable.text = artist!
        }
        if name != nil {
            songLabel.text = name!
        }
        if name != nil && artist != nil {
            mpic.nowPlayingInfo = [
                MPMediaItemPropertyTitle: name!,
                MPMediaItemPropertyArtist: artist!
            ]
        }
    }
    
    @IBAction func suffleTouched(_ sender: UIButton) {
        if isShuffle {
            sender.setImage(UIImage(named: "hightShuffle" ), for: UIControlState())
        } else {
            sender.setImage(UIImage(named: "shuffle" ), for: UIControlState())
        }
        isShuffle = !isShuffle
    }
    
    @IBAction func nextSong(_ sender: AnyObject) {
        if player.isPlaying || player.isPoused {
            player.playNextTrack()
            playButton.setImage(UIImage(named: "pause"), for: UIControlState())
        } else {
            playButton.setImage(UIImage(named: "pause"), for: UIControlState())
            playCurrentBpm()
            player.playNextTrack()
        }
        bpmLabel.text = player.currentBpm?.description
        setTitle()
    }
    @IBAction func previousSong(_ sender: AnyObject) {
        if player.isPlaying || player.isPoused {
            player.playPrevTrack()
            playButton.setImage(UIImage(named: "pause"), for: UIControlState())
        } else {
            playButton.setImage(UIImage(named: "pause"), for: UIControlState())
            playCurrentBpm()
            player.playPrevTrack()
        }

        bpmLabel.text = player.currentBpm?.description
        setTitle()
    }
    @IBAction func doSlow(_ sender: AnyObject) {
        currentBpmIndex -= 1
        guard currentBpmIndex >= 0 else {currentBpmIndex = 0; return}
        bpmLabel.text = allBpm[currentBpmIndex].description
        if player.isPlaying {
            playCurrentBpm()
            playButton.setImage(UIImage(named: "pause"), for: UIControlState())
        } else {
            playCurrentBpm(playSong: false)
        }
        setTitle()
    }
    @IBAction func doFast(_ sender: AnyObject) {
        currentBpmIndex += 1
        guard currentBpmIndex < allBpm.count else {currentBpmIndex = allBpm.count - 1; return}
        bpmLabel.text = allBpm[currentBpmIndex].description
        if player.isPlaying {
            playCurrentBpm()
            playButton.setImage(UIImage(named: "pause"), for: UIControlState())
        } else {
            playCurrentBpm(playSong: false)
        }
        setTitle()
    }
    
    func showNoSongAlert() {
        let alert = UIAlertController(title: "No songs", message: "Add some songs to the application library", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        playButton.setImage(UIImage(named: "Play"), for: UIControlState())
        self.present(alert, animated: true, completion: nil)
    }
}

extension PlayerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        repeatButtonOutlet.setImage(UIImage(named: "hightRep"), for: UIControlState())
//        let mpic = MPNowPlayingInfoCenter.default()
//        if let song = player.currentSong {
//            var artist = song.artist
//            var name = song.name
//            if artist == nil {
//                artist = ""
//            }
//            if name == nil {
//                name = ""
//            }
//            mpic.nowPlayingInfo = [
//                MPMediaItemPropertyTitle: name!,
//                MPMediaItemPropertyArtist: artist!
//            ]
//        }
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bar"), for: .default)    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //playArray(storage.arrayOfUrlPlaylist)
        getAllBpm(storage.bpmIndexDictionary)
        if player.isPlaying {
            bpmLabel.text = player.currentBpm?.description
            playButton.setImage(UIImage(named: "pause"), for: UIControlState())
        } else if player.isPoused {
            bpmLabel.text = player.currentBpm?.description
            playButton.setImage(UIImage(named: "Play"), for: UIControlState())
        }
        else {
            bpmLabel.text = allBpm.first?.description
            playButton.setImage(UIImage(named: "Play"), for: UIControlState())
        }
        if !player.isPlaying && !player.isPoused {
            playCurrentBpm(playSong: false)
        }
        setTitle()
    }
 
    func getAllBpm(_ bpmDictionary : [Int : [Int]]) {
        allBpm = bpmDictionary.keys.sorted(by: { $0 < $1 }).flatMap({ $0 })
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        let rc = event!.subtype
        switch rc {
        case .remoteControlTogglePlayPause:
//            if player.isPlaying {
//                player.pauseTrack()
//            } else if player.isPoused {
//                player.playTrack()
//            } else {
//                playCurrentBpm()
//            }
            self.playButtonPushed(Int() as AnyObject)
        case .remoteControlPlay:
            self.playButtonPushed(Int() as AnyObject)
//            if player.isPoused {
//                player.playTrack()
//            } else {
//                playCurrentBpm()
//            }

        case .remoteControlPause:
            player.pauseTrack()
            
        case .remoteControlNextTrack:
            self.nextSong(Int() as AnyObject)
//            player.playNextTrack()
//            bpmLabel.text = player.currentBpm?.description
//            setTitle()
        case .remoteControlPreviousTrack:
            self.previousSong(Int() as AnyObject)
//            player.playPrevTrack()
//            bpmLabel.text = player.currentBpm?.description
//            setTitle()
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
