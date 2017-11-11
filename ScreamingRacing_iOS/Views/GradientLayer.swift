//
//  GradientLayer.swift
//  ScreamingRacing_iOS
//
//  Created by ChangChao-Tang on 2017/11/11.
//  Copyright © 2017年 ChangChao-Tang. All rights reserved.
//

import UIKit

struct RadialGradientOption {
    var colors:[CGColor] = []
    var locations:[CGFloat] = []
    var startRadius:CGFloat = 0
    var endRadius:CGFloat = 0
}

class RadialGradientLayer: CALayer {
    
    var options:RadialGradientOption = RadialGradientOption()
    override class func needsDisplay(forKey key:String)->Bool{
        return key == "options"
    }
    
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: options.colors as CFArray, locations: options.locations)
        ctx.drawRadialGradient(gradient!, startCenter: CGPoint(x:bounds.midX, y: bounds.midY), startRadius: options.startRadius, endCenter: CGPoint(x:bounds.midX, y:bounds.midY), endRadius: options.endRadius, options: .drawsAfterEndLocation)
    }
}
