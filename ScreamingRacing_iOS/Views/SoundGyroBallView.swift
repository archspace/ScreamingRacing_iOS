//
//  SoundGyroBallView.swift
//  ScreamingRacing_iOS
//
//  Created by ChangChao-Tang on 2017/11/11.
//  Copyright © 2017年 ChangChao-Tang. All rights reserved.
//

import UIKit

class SoundGyroBallView: UIView {
    
    let gyroRegion = [0, 0.05, 0.15, 0.25, 0.35, 0.45, 0.55, 0.65, 0.75, 0.85, 0.95, 1]
    let backgroundGradient = RadialGradientLayer()
    let backgroundMask = CAShapeLayer()
    var powerbars:[CAShapeLayer] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI(){
        backgroundGradient.mask = backgroundMask
        layer.addSublayer(backgroundGradient)
        backgroundGradient.setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundGradient.frame = bounds
        backgroundMask.frame = backgroundGradient.bounds
        let radialOptions = RadialGradientOption(colors: [AppColor.SpeedballBackgroundCenter.cgColor, AppColor.SpeedballBackgroundOuter!.cgColor], locations: [0.1, 1], startRadius: 0, endRadius: bounds.width * 0.5)
        backgroundGradient.options = radialOptions
        backgroundMask.path = UIBezierPath(ovalIn: bounds).cgPath
    }
}
