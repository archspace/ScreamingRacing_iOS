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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        view.backgroundColor = AppColor.ControllBackground
        view.addSubview(speedbar)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        speedbar.pin.center().width(250).height(190)
    }


}
