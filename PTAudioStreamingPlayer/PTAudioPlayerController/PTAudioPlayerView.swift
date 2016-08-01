//
//  PTAudioPlayerView.swift
//  PTAudioStreamingPlayer
//
//  Created by CHEN KAIDI on 29/7/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

import UIKit

typealias ButtonToggleClosure = () -> ()
typealias SliderTouchBeganClosure = (slider:UISlider) -> ()
typealias SliderTouchEndedClosure = (slider:UISlider) -> ()
typealias SliderValueChangeClosure = (slider:UISlider) -> ()

let kTimelineControlHeight:CGFloat = 30.0

class PTAudioPlayerView: UIView {
    
    var _currentTimeLabel:UILabel?
    var _totalTimeLabel:UILabel?
    var _slider: CustomUISlider?
    var _progressBar: CustomProgressBar?
    var _playButton:UIButton?
    var _loadingView:UIActivityIndicatorView?
    var buttonToggleClosure:ButtonToggleClosure?
    var sliderTouchBeganClosure:SliderTouchBeganClosure?
    var sliderTouchEndedClosure:SliderTouchEndedClosure?
    var sliderValueChangedClosure:SliderValueChangeClosure?
    var currentTime:Int = 0
    var totalTime:Double = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.currentTimeLabel)
        self.addSubview(self.totalTimeLabel)
        self.addSubview(self.progressBar)
        self.addSubview(self.slider)
        self.addSubview(self.playButton)
        //        self.addSubview(self.loadingView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttribute(totalTime:Double, progressColor:UIColor, loadingColor:UIColor){
        self.totalTime = totalTime
        self.slider.minimumValue = 0.0
        self.slider.maximumValue = Float(totalTime)
        self.updateTimelineLabel()
        self.currentTimeLabel.textColor = loadingColor
        self.totalTimeLabel.textColor = loadingColor
        self.slider.thumbTintColor = progressColor
        self.progressBar.setProgressBarTintColor(loadingColor)
        self.progressBar.layer.borderColor = loadingColor.CGColor
        self.layoutSubviews()
    }
    
    func updateCurrentTime(currentTime:Int){
        self.currentTime = currentTime
        self.updateTimelineLabel()
        self.slider.value = Float(currentTime)
    }
    
    func updateTimelineLabel(){
        let (ch,cm,cs) = secondsToHoursMinutesSeconds(Int(self.currentTime))
        let (th,tm,ts) = secondsToHoursMinutesSeconds(Int(self.totalTime))
        self.currentTimeLabel.text = String.init(format: "%02d:%02d",cm,cs)
        self.totalTimeLabel.text = String.init(format: "%02d:%02d",tm,ts)
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.currentTimeLabel.frame = CGRectMake(0, 0, 60, kTimelineControlHeight)
        self.totalTimeLabel.frame = CGRectMake(self.bounds.size.width-60, 0, 60, kTimelineControlHeight)
        self.progressBar.frame = CGRectMake(self.currentTimeLabel.frame.size.width, kTimelineControlHeight/2-5, self.bounds.size.width-60*2, 10)
        self.slider.frame = CGRectMake(self.currentTimeLabel.frame.size.width, kTimelineControlHeight/2-5,  self.bounds.size.width-60*2, kTimelineControlHeight)
        self.playButton.center = CGPointMake(self.frame.size.width/2, kTimelineControlHeight+(self.frame.size.height-kTimelineControlHeight)/2)
    }
    
    func startLoadingAnimation(){
        self.loadingView.center = CGPointMake(self.progressBar.bounds.size.width*(CGFloat(self.slider.value/Float(self.totalTime)))+self.progressBar.frame.origin.x, self.progressBar.center.y)
        self.loadingView.hidden = false
        self.loadingView.startAnimating()
    }
    
    func stopLoadingAnimation(){
        self.loadingView.stopAnimating()
    }
    
    func disableSlider(state:Bool){
        self.slider.userInteractionEnabled = !state
    }
    
    func setPlayingState(state:Bool){
        if state {
            // set to pause view
            _playButton?.setImage(UIImage(named:"btn_60_song_pause_nor"), forState: .Normal)
            _playButton?.setImage(UIImage(named:"btn_60_song_pause_sel"), forState: .Highlighted)
        }else{
            _playButton?.setImage(UIImage(named:"btn_60_song_play_nor"), forState: .Normal)
            _playButton?.setImage(UIImage(named:"btn_60_song_play_sel"), forState: .Highlighted)
        }
    }
    
    func sliderTouchBegan(){
        print("Slider touch began")
        if let a = self.sliderTouchBeganClosure {
            a(slider: self.slider)
        }
    }
    
    func sliderTouchEnded(){
        print("Slider touch Ended")
        if let a = self.sliderTouchEndedClosure {
            a(slider: self.slider)
        }
    }
    
    func sliderValueDidChange(){
        if let a = self.sliderValueChangedClosure {
            a(slider: self.slider)
        }
    }
    
    func togglePlayButton(){
        if let a = self.buttonToggleClosure {
            a()
        }
    }
    
    var currentTimeLabel:UILabel{
        if _currentTimeLabel == nil {
            _currentTimeLabel = UILabel(frame: CGRectZero)
            _currentTimeLabel?.textAlignment = .Center
            _currentTimeLabel?.font = UIFont.systemFontOfSize(12)
        }
        return _currentTimeLabel!
    }
    
    var totalTimeLabel:UILabel{
        if _totalTimeLabel == nil {
            _totalTimeLabel = UILabel(frame: CGRectZero)
            _totalTimeLabel?.textAlignment = .Center
            _totalTimeLabel?.font = UIFont.systemFontOfSize(12)
        }
        return _totalTimeLabel!
    }
    
    var slider:CustomUISlider{
        if _slider == nil {
            _slider = CustomUISlider(frame: CGRectZero)
            _slider?.minimumTrackTintColor = UIColor.whiteColor()
            _slider?.maximumTrackTintColor = UIColor.clearColor()
            _slider?.thumbTintColor = UIColor.whiteColor()
            _slider?.currentThumbImage
            _slider?.addTarget(self, action: #selector(sliderTouchBegan), forControlEvents: .TouchDown)
            _slider?.addTarget(self, action: #selector(sliderTouchEnded), forControlEvents: .TouchUpInside)
            _slider?.addTarget(self, action: #selector(sliderValueDidChange), forControlEvents: .ValueChanged)
        }
        return _slider!
    }
    
    var progressBar:CustomProgressBar{
        if _progressBar == nil {
            _progressBar = CustomProgressBar(frame: CGRectZero)
            
        }
        return _progressBar!
    }
    
    var playButton:UIButton{
        if _playButton == nil {
            _playButton = UIButton(frame: CGRectMake(0, 0, 60, 60))
            _playButton?.setTitle("Play", forState: .Normal)
            _playButton?.setImage(UIImage(named:"btn_60_song_play_nor"), forState: .Normal)
            _playButton?.setImage(UIImage(named:"btn_60_song_play_sel"), forState: .Highlighted)
            _playButton?.addTarget(self, action: #selector(togglePlayButton), forControlEvents: .TouchUpInside)
        }
        return _playButton!
    }
    
    var loadingView:UIActivityIndicatorView{
        if _loadingView == nil {
            _loadingView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            _loadingView?.hidesWhenStopped = true
            _loadingView?.hidden = true
        }
        return _loadingView!
    }
}
