//
//  AppMediator.swift
//  ScreamingRacing_iOS
//
//  Created by ChangChao-Tang on 2017/11/7.
//  Copyright © 2017年 ChangChao-Tang. All rights reserved.
//

import UIKit

class AppMediator: NSObject {
    
    weak var window:UIWindow?
    
    func start(window:UIWindow) {
        self.window = window
        window.rootViewController = ControlViewController()
        window.makeKeyAndVisible()
    }
}
