//
//  SoundGyroBallView.swift
//  ScreamingRacing_iOS
//
//  Created by ChangChao-Tang on 2017/11/11.
//  Copyright © 2017年 ChangChao-Tang. All rights reserved.
//

import UIKit

class SoundGyroBallView: UIView {
    
    let gyroRegion:[CGFloat] = [0.05, 0.15, 0.25, 0.35, 0.45, 0.55, 0.65, 0.75, 0.85, 0.95, 1]
    let backgroundGradient = RadialGradientLayer()
    let backgroundMask = CAShapeLayer()
    var powerbarsUpper:[CAShapeLayer] = []
    var powerbarsLower:[CAShapeLayer] = []
    
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
        for _ in 0...gyroRegion.count {
            let upperBar = CAShapeLayer()
            powerbarsUpper.append(upperBar)
            layer.addSublayer(upperBar)
            let lowerBar = CAShapeLayer()
            powerbarsLower.append(lowerBar)
            layer.addSublayer(lowerBar)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundGradient.frame = bounds
        backgroundMask.frame = backgroundGradient.bounds
        let radialOptions = RadialGradientOption(colors: [AppColor.SpeedballBackgroundCenter.cgColor, AppColor.SpeedballBackgroundOuter!.cgColor], locations: [0.1, 1], startRadius: 0, endRadius: bounds.width * 0.5)
        backgroundGradient.options = radialOptions
        backgroundMask.path = UIBezierPath(ovalIn: bounds).cgPath
        
        let baseLineStart = CGPoint(x: bounds.maxX * 0.1, y: bounds.midY),
        baseLineEnd = CGPoint(x: bounds.maxX * 0.9, y: bounds.midY),
        baseLineWidth = baseLineEnd.x - baseLineStart.x, gapeWidth:CGFloat = 2,
        barWidth = (baseLineWidth - gapeWidth * CGFloat(gyroRegion.count - 1)) / CGFloat(gyroRegion.count),
        barHeight = bounds.height * 0.25
        for i in 0..<gyroRegion.count {
            let upper = powerbarsUpper[i], lower = powerbarsLower[i]
            upper.frame = CGRect(x: baseLineStart.x + CGFloat(i) * barWidth + CGFloat(i) * gapeWidth,
                                 y: baseLineStart.y - barHeight, width: barWidth, height: barHeight)
            lower.frame = CGRect(origin: CGPoint(x: upper.frame.origin.x, y: baseLineStart.y), size: upper.frame.size)
            let barBounds = CGRect(origin: CGPoint.zero, size: upper.bounds.size)
            let upperPath = UIBezierPath()
            upperPath.move(to: CGPoint(x: barBounds.midX, y: barBounds.maxY))
            upperPath.addLine(to: CGPoint(x: barBounds.midX, y: barBounds.minY))
            upper.path = upperPath.cgPath
            upper.fillColor = UIColor.clear.cgColor
            upper.strokeColor = AppColor.Soundbar!.cgColor
            upper.lineWidth = barWidth
            upper.strokeEnd = 0
            
            let lowerPath = UIBezierPath()
            lowerPath.move(to: CGPoint(x: barBounds.midX, y: barBounds.minY))
            lowerPath.addLine(to: CGPoint(x:barBounds.midX, y: barBounds.maxY))
            lower.path = lowerPath.cgPath
            lower.fillColor = UIColor.clear.cgColor
            lower.strokeColor = AppColor.Soundbar!.cgColor
            lower.lineWidth = barWidth
            lower.strokeEnd = 0
        }
    }
    
    func setSpeedRate(rate:CGFloat, andGyroRate gyroRate:CGFloat = 0.5) {
        let idx = gyroRegion.filter { (r) -> Bool in
            return r <= gyroRate
        }.count
        for i in 0..<gyroRegion.count {
            let step = abs(i - idx), maxSteps = gyroRegion.count
            var hRate = (rate * (CGFloat(maxSteps) - CGFloat(step)) / CGFloat(maxSteps))
            if idx != i {
                hRate = hRate * CGFloat(arc4random_uniform(50) + 50) / CGFloat(100)
            }
            powerbarsUpper[i].strokeEnd = hRate
            powerbarsLower[i].strokeEnd = hRate
        }
    }
    
}
