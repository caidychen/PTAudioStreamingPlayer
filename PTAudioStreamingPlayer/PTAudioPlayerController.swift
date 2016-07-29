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
    }
    
    func scheduleTimer(){
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(updateTimeline), userInfo: nil, repeats: true)
    }
    
    func setAttribute(totalTime:Double, progressColor:UIColor, loadingColor:UIColor){
        self.totalTime = totalTime
        self.audioPlayerView.setAttribute(totalTime, progressColor: progressColor, loadingColor: loadingColor)
    }
    
    func play(){
        if self.streamer?.state == AS_PAUSED {
            self.streamer?.seekToTime(Double(self.currentTime))
        }
        self.streamer?.start()
    }
    
    func pause(){
        self.streamer?.pause()
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
    
    func createStreamer(){
        self.destroyStreamer()
        streamer = AudioStreamer(URL: NSURL(string:"http://od.qingting.fm/vod/00/00/0000000000000000000025364530_24.m4a"))
    }
    
    func streamerNotification(notification:NSNotification){
        if let streamer:AudioStreamer = notification.object as? AudioStreamer{
            print("\(streamer.state)")
        }
        if streamer?.state == AS_PLAYING {
            self.scheduleTimer()
        }else{
            if let a = self.timer {
                a.invalidate()
            }
        }
    }
    
    func destroyStreamer(){
        if let a = streamer{
            NSNotificationCenter.defaultCenter().removeObserver(self, name: ASStatusChangedNotification, object: a)
            a.stop()
        }
    }
    
    var audioPlayerView:PTAudioPlayerView{
        if _audioPlayerView == nil {
            _audioPlayerView = PTAudioPlayerView(frame:CGRectZero)
            _audioPlayerView?.buttonToggleClosure = {
                self.isPlaying = !self.isPlaying
                self.audioPlayerView.setPlayingState(self.isPlaying)
                if self.isPlaying {
                    self.play()
                }else{
                    self.pause()
                }
            }
        }
        return _audioPlayerView!
    }
    
}
