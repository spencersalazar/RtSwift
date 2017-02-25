//
//  RtSwift.swift
//  RtSwift
//
//  Created by Spencer Salazar on 2/6/17.
//  Copyright © 2017 Spencer Salazar. All rights reserved.
//

import Foundation

struct Math {
    let PI = 3.14159265359
}

public class RtSwift {
    
    public static var sampleRate: Int = 48000
    static var bridge: RtSwiftBridge! = nil
    
    public static func start(process: @escaping (_ left: UnsafeMutableBufferPointer<Float>, _ right: UnsafeMutableBufferPointer<Float>, _ numFrames: Int) -> Void) {
        bridge = RtSwiftBridge()
        bridge.sampleRate = sampleRate
        bridge?.start({ (_left, _right, nFrames) in
            let left = UnsafeMutableBufferPointer<Float>(_left)
            let right = UnsafeMutableBufferPointer<Float>(_right)
            process(left, right, Int(nFrames))
        })
    }
}
