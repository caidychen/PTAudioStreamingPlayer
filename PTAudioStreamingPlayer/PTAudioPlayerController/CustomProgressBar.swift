//
//  CustomProgressBar.swift
//  PTAudioStreamingPlayer
//
//  Created by CHEN KAIDI on 29/7/2016.
//  Copyright © 2016 Putao. All rights reserved.
//

import UIKit

class CustomProgressBar: UIView {
    
    var _baseView:UIView?
    var _progressView:UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.baseView)
        self.baseView.addSubview(self.progressView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.baseView.frame = self.bounds
    }
    
    func setProgressBarTintColor(color:UIColor){
        self.progressView.backgroundColor = color
        self.baseView.layer.borderColor = color.CGColor
    }
    
    func setProgress(ratio:CGFloat){
        self.progressView.frame = CGRectMake(0, 0, self.bounds.size.width*ratio, self.bounds.size.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var baseView:UIView{
        if _baseView == nil{
            _baseView = UIView()
            _baseView?.backgroundColor = UIColor.clearColor()
            _baseView?.layer.borderWidth = 1
            _baseView?.layer.cornerRadius = 5
            _baseView?.layer.masksToBounds = true
        }
        return _baseView!
    }
    
    var progressView:UIView{
        if _progressView == nil {
            _progressView = UIView()
        }
        return _progressView!
    }
}
