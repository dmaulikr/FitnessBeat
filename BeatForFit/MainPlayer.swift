//
//  MainPlayer.swift
//  BeatForFit
//
//  Created by Grigory Bochkarev on 08.07.16.
//  Copyright © 2016 Grigory Bochkarev. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class MainPlayer : UIViewController, AVAudioPlayerDelegate {
    
    // audio player object
    var audioPlayer = AVAudioPlayer()
    
    // timer (used to show current track play time)
    var timer:Timer!
    
    
    // play list file and title list
    var playListFiles = [String]()
    var playListTitles = [String]()
    
    // total number of track
    var trackCount: Int = 0
    
    // currently playing track
    var currentTrack: Int = 0
    
    // is playing or not
    var isPlaying: Bool = false
    
    
    
    // outlet - track info label (e.g. Track 1/5)
    @IBOutlet var trackInfo: UILabel!
    
    // outlet - play duration label
    @IBOutlet var playDuration: UILabel!
    
    // outlet - track title label
    @IBOutlet var trackTitle: UILabel!
    
    
    
    // outlet & action - prev button
    @IBOutlet var prevButton: UIBarButtonItem!
    @IBAction func prevButtonAction(_ sender: UIBarButtonItem) {
        self.playPrevTrack()
    }
    
    // outlet & action - play button
    @IBOutlet var playButton: UIBarButtonItem!
    @IBAction func playButtonAction(_ sender: UIBarButtonItem) {
        self.playTrack()
    }
    
    // outlet & action - pause button
    @IBOutlet var pauseButton: UIBarButtonItem!
    @IBAction func pauseButtonAction(_ sender: UIBarButtonItem) {
        self.pauseTrack()
    }
    
    // outlet & action - forward button
    @IBOutlet var nextButton: UIBarButtonItem!
    @IBAction func nextButtonAction(_ sender: UIBarButtonItem) {
        self.playNextTrack()
    }
    
    
    
    
    // MARK: - View functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // setup play list
        self.setupPlayList()
        
        // setup audio player
        self.setupAudioPlayer()
        
        // set button status
        self.setButtonStatus()
        
        // play track
        self.playTrack()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // MARK: - AVAudio player delegate functions.
    
    // set status false and set button  when audio finished.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        // set playing off
        self.isPlaying = false
        
        // invalidate scheduled timer.
        self.timer.invalidate()
        
        self.setButtonStatus()
    }
    
    // show message if error occured while decoding the audio
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        // print friendly error message
        print(error!.localizedDescription)
    }
    
    
    
    // MARK: - Utility functions
    
    // setup playList
    fileprivate func setupPlayList() {
        
        // audio resource file list
        self.playListFiles = ["forest-bright-01","jungle-01","swamp-01","forest-bright-01","jungle-01"]
        
        // track title list
        self.playListTitles = ["1 - Forest Bright", "2 - Jungle", "3 - Swamp", "4 - Forest Bright", "5 - Jungle"]
        
        // total number of track
        self.trackCount = self.playListFiles.count
        
        // set current track
        self.currentTrack = 1
        
        // set playing status
        self.isPlaying = false
    }
    
    
    // setup audio player
    fileprivate func setupAudioPlayer() {
        
        // choose file from play list
        let fileURL:URL =  Bundle.main.url(forResource: self.playListFiles[self.currentTrack-1], withExtension: "mp3")!
        
        do {
            // create audio player with given file url
            self.audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            
            // set audio player delegate
            self.audioPlayer.delegate = self
            
            // set default volume level
            self.audioPlayer.volume = 0.7
            
            // make player ready (i.e. preload buffer)
            self.audioPlayer.prepareToPlay()
            
        } catch let error as NSError {
            // print error in friendly way
            print(error.localizedDescription)
        }
        
    }
    
    // play current track
    fileprivate func playTrack() {
        
        // set play status
        self.isPlaying = true
        
        // set timer, so it will update played time lable every second.
        //self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updatePlayedTimeLabel", userInfo: nil, repeats: true)
        
        // play currently loaded track
        self.audioPlayer.play()
        
        
        self.setButtonStatus()
    }
    
    // pause current track
    fileprivate func pauseTrack() {
        
        // invalidate scheduled timer.
        self.timer.invalidate()
        
        // set play status
        self.isPlaying = false
        
        // play currently loaded track
        self.audioPlayer.pause()
        
        self.setButtonStatus()
    }
    
    
    // play next track
    fileprivate func playNextTrack() {
        
        // pause current track
        self.pauseTrack()
        
        // change track
        if self.currentTrack < self.trackCount {
            self.currentTrack += 1
        }
        
        // stop player if currently playing
        if self.audioPlayer.isPlaying {
            self.audioPlayer.stop()
        }
        
        // setup player for updated track
        self.setupAudioPlayer()
        
        // play track
        self.playTrack()
    }
    
    
    // play prev track
    fileprivate func playPrevTrack() {
        
        // pause current track
        self.pauseTrack()
        
        // change track
        if self.currentTrack > 1 {
            self.currentTrack -= 1
        }
        
        // stop player if currently playing
        if self.audioPlayer.isPlaying {
            self.audioPlayer.stop()
        }
        
        // setup player for updated track
        self.setupAudioPlayer()
        
        // play track
        self.playTrack()
    }
    
    
    // enable / disable player button based on track
    fileprivate func setButtonStatus() {
        
        // set play/pause button based on playing status
        if isPlaying {
            self.playButton.isEnabled = false
            self.pauseButton.isEnabled = true
        }else {
            self.playButton.isEnabled = true
            self.pauseButton.isEnabled = false
        }
        
        // set prev/next button based on current track
        if self.currentTrack == 1  {
            self.prevButton.isEnabled = false
            if self.trackCount > 1 {
                self.nextButton.isEnabled = true
            }else{
                self.nextButton.isEnabled = false
            }
        }else if self.currentTrack == self.trackCount {
            self.prevButton.isEnabled = true
            self.nextButton.isEnabled = false
        }else {
            self.prevButton.isEnabled = true
            self.nextButton.isEnabled = true
        }
        
        // set track info
        self.trackInfo.text = "Track \(self.currentTrack) / \(self.trackCount)"
        
        // set track title
        self.trackTitle.text = self.playListTitles[self.currentTrack - 1]
    }
    
    // update currently played time label.
    func updatePlayedTimeLabel(){
        
        let currentTime = Int(self.audioPlayer.currentTime)
        let minutes = currentTime/60
        let seconds = currentTime - (minutes * 60)
        
        // update time within label
        self.playDuration.text = NSString(format: "%02d:%02d", minutes,seconds) as String
    }
    
}

class Player1 : NSObject, AVAudioPlayerDelegate {
    
    static let sharedInstance = Player1()
    
    fileprivate override init() {
        super.init()
    }
    
    
    // audio player object
    var audioPlayer = AVAudioPlayer()
    
    // timer (used to show current track play time)
    var timer:Timer!
    
    
    // play list file and title list
   // var playListFiles = [String]()
   // var playListTitles = [String]()
    var playListURL = [URL]()
    
    // total number of track
    var trackCount: Int = 0
    
    // currently playing track
    var currentTrack: Int = 0
    
    // is playing or not
    var isPlaying: Bool = false
    
    // MARK: - AVAudio player delegate functions.
    
    // set status false and set button  when audio finished.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        // set playing off
        self.isPlaying = false
        
        // invalidate scheduled timer.
        self.timer.invalidate()
        
        //sent notificarion to update UI
    }
    
    // show message if error occured while decoding the audio
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        // print friendly error message
        print(error!.localizedDescription)
    }
    
    
    
    // MARK: - Utility functions
    
    // setup playList
    fileprivate func setupPlayList(_ arrayOfUrls: [URL]) {
        
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
    fileprivate func setupAudioPlayer() {
        
        // choose file from play list
        //let fileURL:NSURL =  NSBundle.mainBundle().URLForResource(self.playListFiles[self.currentTrack-1], withExtension: "mp3")!
        
        do {
            // create audio player with given file url
            self.audioPlayer = try AVAudioPlayer(contentsOf: playListURL[currentTrack])
            
            // set audio player delegate
            self.audioPlayer.delegate = self
            
            // set default volume level
            self.audioPlayer.volume = 1
            
            // make player ready (i.e. preload buffer)
            self.audioPlayer.prepareToPlay()
            
        } catch let error as NSError {
            // print error in friendly way
            print(error.localizedDescription)
        }
        
    }
    
    // play current track
    fileprivate func playTrack() {
        
        // set play status
        self.isPlaying = true
        
        // set timer, so it will update played time lable every second.
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(MainPlayer.updatePlayedTimeLabel), userInfo: nil, repeats: true)
        
        // play currently loaded track
        self.audioPlayer.play()
        
        
       // self.setButtonStatus()
        //update UI
    }
    
    // pause current track
    fileprivate func pauseTrack() {
        
        // invalidate scheduled timer.
        self.timer.invalidate()
        
        // set play status
        self.isPlaying = false
        
        // play currently loaded track
        self.audioPlayer.pause()
        
        //self.setButtonStatus()
        //update UI
    }
    
    
    // play next track
    fileprivate func playNextTrack() {
        
        // pause current track
        self.pauseTrack()
        
        // change track
        if self.currentTrack < self.trackCount {
            self.currentTrack += 1
        }
        
        // stop player if currently playing
        if self.audioPlayer.isPlaying {
            self.audioPlayer.stop()
        }
        
        // setup player for updated track
        self.setupAudioPlayer()
        
        // play track
        self.playTrack()
    }
    
    
    // play prev track
    fileprivate func playPrevTrack() {
        
        // pause current track
        self.pauseTrack()
        
        // change track
        if self.currentTrack > 1 {
            self.currentTrack -= 1
        }
        
        // stop player if currently playing
        if self.audioPlayer.isPlaying {
            self.audioPlayer.stop()
        }
        
        // setup player for updated track
        self.setupAudioPlayer()
        
        // play track
        self.playTrack()
    }

    

}
