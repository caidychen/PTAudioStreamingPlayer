//
//  HomeViewController.swift
//  PTAudioStreamingPlayer
//
//  Created by CHEN KAIDI on 29/7/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        
        let playerController = PTAudioPlayerController(audioURL: "http://od.qingting.fm/vod/00/00/0000000000000000000025364530_24.m4a")
        
        playerController.audioPlayerView.frame = CGRectMake(0, 200, UIScreen.mainScreen().bounds.size.width, 100)
        self.view.addSubview(playerController.audioPlayerView)
        playerController.setAttribute(146, progressColor: UIColor.whiteColor(), loadingColor: UIColor.grayColor())
        playerController.createStreamer()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
