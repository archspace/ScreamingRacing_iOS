//
//  SpeedBarView.swift
//  ScreamingRacing_iOS
//
//  Created by ChangChao-Tang on 2017/11/7.
//  Copyright © 2017年 ChangChao-Tang. All rights reserved.
//

import UIKit
import AEConicalGradient
import ChameleonFramework
import PinLayout

class SpeedBarView: UIView {
    
    let baseGradient = ConicalGradientLayer()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI(){
        let baseAlpha:CGFloat = 0.25
        baseGradient.colors = [
            AppColor.ControllGradient1st!.withAlphaComponent(baseAlpha),
            AppColor.ControllGradient2nd!.withAlphaComponent(baseAlpha),
            AppColor.ControllGradient3rd!.withAlphaComponent(baseAlpha),
            AppColor.ControllGradient4th!.withAlphaComponent(baseAlpha),
            AppColor.ControllGradient5th!.withAlphaComponent(baseAlpha)
        ]
        baseGradient.startAngle = 0.75 * Double.pi
        baseGradient.endAngle = 2.25 * Double.pi
        layer.addSublayer(baseGradient)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        baseGradient.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }
    
    
    
 

}
