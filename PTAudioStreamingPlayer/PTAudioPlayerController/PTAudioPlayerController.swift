//
//  PTAudioPlayerController.swift
//  PTAudioStreamingPlayer
//
//  Created by CHEN KAIDI on 29/7/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

import UIKit

class PTAudioPlayerController: NSObject {
    
    var _audioPlayerView:PTAudioPlayerView?
    var streamer:AudioStreamer?
    var timer:NSTimer?
    
    var downdingUpdater:NSTimer?
    
    var currentTime = 0
    var totalTime = 0.0
    var isPlaying:Bool = false
    var audioURL:String?
    
    init(audioURL:String) {
        super.init()
        self.audioURL = audioURL
    }
    
    func scheduleTimer(){
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(updateTimeline), userInfo: nil, repeats: true)
    }
    
    func setAttribute(totalTime:Double, progressColor:UIColor, loadingColor:UIColor){
        self.totalTime = totalTime
        self.audioPlayerView.setAttribute(totalTime, progressColor: progressColor, loadingColor: loadingColor)
    }
    
    func createStreamer(){
        self.reset()
        self.destroyStreamer()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PTAudioPlayerController.streamerNotification(_:)), name: ASStatusChangedNotification, object: self.streamer)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didEnterBackground), name: UIApplicationWillResignActiveNotification, object: nil)
        if let a = self.audioURL {
            streamer = AudioStreamer(URL: NSURL(string:a))
        }
        
        //        self.downdingUpdater = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(updateDownloadProgress), userInfo: nil, repeats: true)
    }
    
    func destroyStreamer(){
        if let a = streamer{
            NSNotificationCenter.defaultCenter().removeObserver(self, name: ASStatusChangedNotification, object: a)
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillResignActiveNotification, object: nil)
            a.stop()
        }
    }
    
    func reset(){
        self.isPlaying = false
        self.audioPlayerView.setPlayingState(self.isPlaying)
        self.currentTime = 0
        self.audioPlayerView.updateCurrentTime(currentTime)
        self.audioPlayerView.disableSlider(true)
    }
    
    func play(){
        if let a = self.streamer{
            if a.state == AS_PAUSED {
                // This is to avoid progress bar out of sync by snapping current timeline into Integer value
                a.seekToTime(Double(self.currentTime))
            }
            a.start()
        }else{
            print("Streamer not initialised. Please check if createStreamer() is called.")
        }
    }
    
    func pause(){
        if self.streamer?.state == AS_PLAYING {
            self.streamer?.pause()
        }
    }
    
    func updateTimeline(){
        if self.currentTime >= Int(self.totalTime){
            self.currentTime = Int(self.totalTime)
            self.timer!.invalidate()
            return
        }
        currentTime += 1
        self.audioPlayerView.updateCurrentTime(currentTime)
    }
    
    func updateDownloadProgress(){
        print("\(self.streamer?.duration)")
    }
    
    func didEnterBackground(){
        //        self.isPlaying = false
        //        self.audioPlayerView.setPlayingState(self.isPlaying)
        //        self.pause()
    }
    
    func streamerNotification(notification:NSNotification){
        if let streamer:AudioStreamer = notification.object as? AudioStreamer{
            print("\(streamer.state)")
            if streamer.state == AS_PLAYING {
                self.scheduleTimer()
                self.isPlaying = true
                self.audioPlayerView.setPlayingState(self.isPlaying)
                self.audioPlayerView.disableSlider(false)
                self.audioPlayerView.stopLoadingAnimation()
            }else{
                self.isPlaying = false
                self.audioPlayerView.setPlayingState(self.isPlaying)
                self.audioPlayerView.disableSlider(true)
                if streamer.state == AS_STOPPED {
                    // Reach the end of streaming, reset everything
                    self.reset()
                    
                }else{
                    if streamer.state != AS_PAUSED{
                        self.audioPlayerView.startLoadingAnimation()
                    }else{
                        self.audioPlayerView.disableSlider(false)
                    }
                    
                }
                
                if let a = self.timer {
                    a.invalidate()
                }
            }
        }
    }
    
    var audioPlayerView:PTAudioPlayerView{
        if _audioPlayerView == nil {
            _audioPlayerView = PTAudioPlayerView(frame:CGRectZero)
            _audioPlayerView?.buttonToggleClosure = {
                if !self.isPlaying {
                    self.play()
                }else{
                    self.pause()
                }
            }
            _audioPlayerView?.sliderTouchBeganClosure = { (slider:UISlider) in
                if let a = self.timer {
                    a.invalidate()
                }
            }
            _audioPlayerView?.sliderTouchEndedClosure = { (slider:UISlider) in
                self.audioPlayerView.disableSlider(true)
                if self.isPlaying {
                    self.scheduleTimer()
                }
                
                self.streamer?.seekToTime(Double(self.currentTime))
            }
            
            _audioPlayerView?.sliderValueChangedClosure = { (slider:UISlider) in
                self.currentTime = Int(slider.value)
                self.audioPlayerView.updateCurrentTime(self.currentTime)
            }
        }
        return _audioPlayerView!
    }
    
}
