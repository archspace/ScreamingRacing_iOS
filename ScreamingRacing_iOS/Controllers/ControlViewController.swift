//
//  ControlViewController.swift
//  ScreamingRacing_iOS
//
//  Created by ChangChao-Tang on 2017/11/7.
//  Copyright © 2017年 ChangChao-Tang. All rights reserved.
//

import UIKit
import PinLayout

class ControlViewController: UIViewController {
    
    let speedbar = SpeedBarView()
    let testControl = UISlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        view.backgroundColor = AppColor.ControllBackground
        view.addSubview(speedbar)
        view.addSubview(testControl)
        testControl.addTarget(self, action: #selector(testChange(sender:)), for: .valueChanged)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let w = view.bounds.width
        speedbar.pin.center().width(w * 0.9).height(w * 0.6)
        testControl.pin.width(250).below(of: speedbar, aligned: .center)
    }

    @objc func testChange(sender:UISlider) {
        speedbar.setSpeedRate(speed: CGFloat(sender.value))
    }
}
