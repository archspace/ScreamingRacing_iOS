//
//  CarCommands.swift
//  ScreamingRacing_iOS
//
//  Created by ChangChao-Tang on 2017/11/21.
//  Copyright © 2017年 ChangChao-Tang. All rights reserved.
//

import Foundation

protocol BluetoothValueProtocol {
    init?(withValue value:Data)
    func data() -> Data
}

extension Data {
    func valueInRange<T>(range:Range<Data.Index>, constructor:(_ buffer:[UInt8])->T)->T {
        var buffer = [UInt8].init(repeating: 0, count: range.count)
        self.copyBytes(to: &buffer, from: range)
        return constructor(buffer)
    }
}

struct CarCammand {
    let F_LED_L:UInt8
    let F_LED_R:UInt8
    let M_LED_L:UInt8
    let M_LED_R:UInt8
    let Motor_L_D:UInt8
    let Motor_L_S:UInt8
    let Motor_R_D:UInt8
    let Motor_R_S:UInt8
    
    
    init(F_LED_L:UInt8, F_LED_R:UInt8, M_LED_L:UInt8, M_LED_R:UInt8, Motor_L_D:UInt8, Motor_L_S:UInt8, Motor_R_D:UInt8, Motor_R_S:UInt8) {
        self.F_LED_L = F_LED_L
        self.F_LED_R = F_LED_R
        self.M_LED_L = M_LED_L
        self.M_LED_R = M_LED_R
        self.Motor_L_D = Motor_L_D
        self.Motor_L_S = Motor_L_S
        self.Motor_R_D = Motor_R_D
        self.Motor_R_S = Motor_R_S
    }
    
    func data() -> Data {
        return Data(bytes: [F_LED_L, F_LED_R, M_LED_L, M_LED_R, Motor_L_D, Motor_L_S, Motor_R_D, Motor_R_S])
    }
}
