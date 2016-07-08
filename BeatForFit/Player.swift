//
//  Player.swift
//  BeatForFit
//
//  Created by Grigory Bochkarev on 02.07.16.
//  Copyright © 2016 Grigory Bochkarev. All rights reserved.
//

import Foundation
import AVFoundation

class Player : NSObject, AVAudioPlayerDelegate {
    
    static let sharedInstance = Player()
    
    private override init() {
        super.init()
    }
    // audio player object
    var audioPlayer = AVAudioPlayer()
    
    // timer (used to show current track play time)
    //var timer:NSTimer!
    
    
    // play list file
    var playListURL = [NSURL]()
    
    // total number of track
    var trackCount: Int = 0
    
    // currently playing track
    var currentTrack: Int = 0
    var currentBpm : Int? = 0
    var currentSong : Song?
    
    // is playing or not
    var isPlaying: Bool = false
    
    // MARK: - AVAudio player delegate functions.
    
    // set status false and set button  when audio finished.
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        
        // set playing off
        self.isPlaying = false
        
        // invalidate scheduled timer.
        //self.timer.invalidate()
        
        //sent notificarion to update UI
    }
    
    // show message if error occured while decoding the audio
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        // print friendly error message
        print(error!.localizedDescription)
    }
    
    
    
    // MARK: - Utility functions
    
    // setup playList
    func setupPlayList(arrayOfUrls: [NSURL]) {
        
        // audio resource file list
        //self.playListFiles = ["forest-bright-01","jungle-01","swamp-01","forest-bright-01","jungle-01"]
        self.playListURL = arrayOfUrls
        
        // track title list
        //self.playListTitles = ["1 - Forest Bright", "2 - Jungle", "3 - Swamp", "4 - Forest Bright", "5 - Jungle"]
        
        // total number of track
        self.trackCount = self.playListURL.count
        
        // set current track
        self.currentTrack = 0
        
        // set playing status
        self.isPlaying = false
    }
    
    
    // setup audio player
    func setupAudioPlayer() {
        
        // choose file from play list
        //let fileURL:NSURL =  NSBundle.mainBundle().URLForResource(self.playListFiles[self.currentTrack-1], withExtension: "mp3")!
        
        do {
            // create audio player with given file url
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: playListURL[currentTrack])
            
            // set audio player delegate
            self.audioPlayer.delegate = self
            
            // set default volume level
            
            // make player ready (i.e. preload buffer)
            self.audioPlayer.prepareToPlay()
            
        } catch let error as NSError {
            // print error in friendly way
            print(error.localizedDescription)
        }
        
    }
    
    // play current track
    func playTrack() {
        
        // set play status
        self.isPlaying = true
        
        // set timer, so it will update played time lable every second.
        //self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(MainPlayer.updatePlayedTimeLabel), userInfo: nil, repeats: true)
        
        // play currently loaded track
        self.audioPlayer.play()
        
        currentSong = Storage.sharedInstance.getSongFromUrl(playListURL[currentTrack])
        currentBpm = currentSong?.bpm
        
        
        // self.setButtonStatus()
        //update UI
    }
    
    // pause current track
    func pauseTrack() {
        
        // invalidate scheduled timer.
        //self.timer.invalidate()
        
        // set play status
        self.isPlaying = false
        
        // play currently loaded track
        self.audioPlayer.pause()
        
        //self.setButtonStatus()
        //update UI
    }
    
    
    // play next track
    func playNextTrack() {
        
        // pause current track
        self.pauseTrack()
        
        // change track
        if self.currentTrack < self.trackCount-1 {
            self.currentTrack += 1
        }
        
        
        // stop player if currently playing
        if self.audioPlayer.playing {
            self.audioPlayer.stop()
        }
        
        // setup player for updated track
        self.setupAudioPlayer()
        
        // play track
        self.playTrack()
    }
    
    
    // play prev track
    func playPrevTrack() {
        
        // pause current track
        self.pauseTrack()
        
        // change track
        if self.currentTrack > 0 {
            self.currentTrack -= 1
        }
        
        // stop player if currently playing
        if self.audioPlayer.playing {
            self.audioPlayer.stop()
        }
        
        // setup player for updated track
        self.setupAudioPlayer()
        
        // play track
        self.playTrack()
    }
}