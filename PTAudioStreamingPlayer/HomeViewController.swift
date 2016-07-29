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
        
        let playerController = PTAudioPlayerController()
        //        playerController.audioPlayerView.layer.borderColor = UIColor.redColor().CGColor
        //        playerController.audioPlayerView.layer.borderWidth = 1
        
        playerController.audioPlayerView.frame = CGRectMake(0, 200, UIScreen.mainScreen().bounds.size.width, 100)
        self.view.addSubview(playerController.audioPlayerView)
        playerController.setAttribute(146, progressColor: UIColor.whiteColor(), loadingColor: UIColor.grayColor())
        
        //        playerController.audioPlayerView.progressBar.setProgress(0.7)
        
        //        playerController.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
