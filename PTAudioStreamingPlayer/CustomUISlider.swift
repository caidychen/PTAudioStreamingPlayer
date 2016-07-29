//
//  CustomUISlider.swift
//  SliderDemo
//
//  Created by Chunlin on 16/7/29.
//  Copyright © 2016年 com.putao. All rights reserved.
//

import UIKit

class CustomUISlider: UISlider {
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    override func trackRectForBounds(bounds: CGRect) -> CGRect {
        let rect = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.width, 10)
        return rect
    }
}
