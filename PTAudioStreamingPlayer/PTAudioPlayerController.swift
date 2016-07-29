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
    
    var currentTime = 0
    var totalTime = 0.0
    var isPlaying:Bool = false
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PTAudioPlayerController.streamerNotification(_:)), name: ASStatusChangedNotification, object: self.streamer)
        
        self.createStreamer()
        self.reset()
    }
    
    func scheduleTimer(){
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(updateTimeline), userInfo: nil, repeats: true)
    }
    
    func setAttribute(totalTime:Double, progressColor:UIColor, loadingColor:UIColor){
        self.totalTime = totalTime
        self.audioPlayerView.setAttribute(totalTime, progressColor: progressColor, loadingColor: loadingColor)
    }
    
    func createStreamer(){
        self.destroyStreamer()
        streamer = AudioStreamer(URL: NSURL(string:"http://od.qingting.fm/vod/00/00/0000000000000000000025364530_24.m4a"))
    }
    
    func destroyStreamer(){
        if let a = streamer{
            NSNotificationCenter.defaultCenter().removeObserver(self, name: ASStatusChangedNotification, object: a)
            a.stop()
        }
    }
    
    func reset(){
        self.isPlaying = false
        self.audioPlayerView.setPlayingState(self.isPlaying)
        self.currentTime = 0
    }
    
    func play(){
        if self.streamer?.state == AS_PAUSED {
            // This is to avoid progress bar out of sync by snapping current timeline into Integer value
            self.streamer?.seekToTime(Double(self.currentTime))
        }
        self.streamer?.start()
        self.isPlaying = true
        self.audioPlayerView.setPlayingState(self.isPlaying)
    }
    
    func pause(){
        if self.streamer?.state == AS_PLAYING {
            self.isPlaying = false
            self.streamer?.pause()
            self.audioPlayerView.setPlayingState(self.isPlaying)
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
    
    
    
    func streamerNotification(notification:NSNotification){
        if let streamer:AudioStreamer = notification.object as? AudioStreamer{
            print("\(streamer.state)")
            if streamer.state == AS_PLAYING {
                self.scheduleTimer()
            }else{
                if streamer.state == AS_STOPPED {
                    // Reach the end of streaming, reset everything
                    self.reset()
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
        }
        return _audioPlayerView!
    }
    
}
