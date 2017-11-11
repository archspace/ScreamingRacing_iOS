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
    let baseMask = CAShapeLayer()
    let gradient = ConicalGradientLayer()
    let gradientMask = CAShapeLayer()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI(){
        let baseAlpha:CGFloat = 0.1, startAngle = 0.75 * Double.pi, endAngle = 2.25 * Double.pi
        baseGradient.colors = [
            AppColor.ControllGradient1st!.withAlphaComponent(baseAlpha),
            AppColor.ControllGradient2nd!.withAlphaComponent(baseAlpha),
            AppColor.ControllGradient3rd!.withAlphaComponent(baseAlpha),
            AppColor.ControllGradient4th!.withAlphaComponent(baseAlpha),
            AppColor.ControllGradient5th!.withAlphaComponent(baseAlpha)
        ]
        baseGradient.startAngle = startAngle
        baseGradient.endAngle = endAngle
        baseGradient.mask = baseMask
        layer.addSublayer(baseGradient)
        
        gradient.colors = [
            AppColor.ControllGradient1st!,
            AppColor.ControllGradient2nd!,
            AppColor.ControllGradient3rd!,
            AppColor.ControllGradient4th!,
            AppColor.ControllGradient5th!
        ]
        gradient.startAngle = startAngle
        gradient.endAngle = endAngle
        gradient.mask = gradientMask
        layer.addSublayer(gradient)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        baseGradient.frame = bounds
        gradient.frame = baseGradient.frame
        baseMask.frame = baseGradient.bounds
        gradientMask.frame = gradient.bounds
        let path = UIBezierPath(arcCenter: CGPoint(x:bounds.midX, y:bounds.midY), radius: bounds.height * 0.45, startAngle: 0.75 * CGFloat.pi, endAngle: 2.25 * CGFloat.pi, clockwise: true)
        gradientMask.path = path.cgPath
        gradientMask.strokeEnd = 0
        gradientMask.lineWidth = 5
        gradientMask.fillColor = UIColor.clear.cgColor
        gradientMask.strokeColor = UIColor.black.cgColor
        
        baseMask.path = UIBezierPath(cgPath: path.cgPath).cgPath
        baseMask.lineWidth = 5
        baseMask.fillColor = UIColor.clear.cgColor
        baseMask.strokeColor = UIColor.black.cgColor
    }
    
    func setSpeedRate(speed:CGFloat) {
        gradientMask.strokeEnd = speed
    }

}
