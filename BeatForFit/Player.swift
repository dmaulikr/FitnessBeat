//
//  Player.swift
//  BeatForFit
//
//  Created by Grigory Bochkarev on 02.07.16.
//  Copyright © 2016 Grigory Bochkarev. All rights reserved.
//

import Foundation
import AVFoundation

class Player : NSObject {
    
    static let sharedInstance = Player()
    
    private override init() {
        super.init()
    }

    // The player.
    var avPlayer:AVAudioPlayer!
    var isPrepared = false
    var arrayOfUrl = [NSURL]()
    var songNumb = 0
    var storage = Storage.sharedInstance
    
    
    /**
     Uses AvAudioPlayer to play a sound file.
     The player instance needs to be an instance variable. Otherwise it will disappear before playing.
     */
    
    func playNext() {
        songNumb += 1
        if songNumb != arrayOfUrl.count {
            playQueue()
        } else {
            songNumb = 0
        }
    }
    
    func playArray(arrayOfUrl : [NSURL]) {
        setQueue(arrayOfUrl)
        stopAVPLayer()
        playQueue()
    }
    
    func playWithBpm(bpm: Int) {
        if let indexes = storage.bpmIndexDictionary[bpm] {
            for index in indexes {
                if let url = storage.songs[index].URL {
                    arrayOfUrl.append(url)
                }
            }
        }
        stopAVPLayer()
        playQueue()
    }
    
    func setQueue(arrayOfUrl : [NSURL]) {
        self.arrayOfUrl = arrayOfUrl
    }
    
    func playQueue() {
        do {
            self.avPlayer = try AVAudioPlayer(contentsOfURL: arrayOfUrl[songNumb])
        } catch {
            print("couldn't load the file")
        }
        avPlayer.delegate = self
        isPrepared = avPlayer.prepareToPlay()
        avPlayer.play()
    }
    
    func readFileIntoAVPlayer(fileURL: NSURL) {
        if !isPrepared {
            do {
                self.avPlayer = try AVAudioPlayer(contentsOfURL: fileURL)
            } catch {
                print("couldn't load the file")
            }
            print("playing \(fileURL)")
            avPlayer.delegate = self
            isPrepared = avPlayer.prepareToPlay()
            avPlayer.play()
        }
        else {
            toggleAVPlayer()
        }
    }
    
    func stopAVPLayer() {
        if isPrepared {
            if avPlayer.playing {
                avPlayer.stop()
            }
        }
    }
    
    func toggleAVPlayer() {
        if avPlayer.playing {
            avPlayer.pause()
        } else {
            avPlayer.play()
        }
    }
    
    func audioPlayerBeginInterruption(player: AVAudioPlayer) {
        print("interrapted")
    }
    
    func audioPlayerEndInterruption(player: AVAudioPlayer) {
        print("recover")
    }
}

extension Player : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            songNumb += 1
            if songNumb != arrayOfUrl.count {
                playQueue()
            } else {
                songNumb = 0
            }
        }
    }
    
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        if (error != nil) { print("\(error!.localizedDescription)")}
    }
    
}