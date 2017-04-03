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
    
    public static var sampleRate: Int = 44100
    public static var enableInput: Bool = false
    static var bridge: RtSwiftBridge! = nil
    
    public static func start(process: @escaping (
        _ left: UnsafeMutableBufferPointer<Float>,
        _ right: UnsafeMutableBufferPointer<Float>,
        _ numFrames: Int) -> Void) {
        bridge = RtSwiftBridge()
        
        bridge.sampleRate = sampleRate
        bridge.enableInput = enableInput
        Stk.setSampleRate(Float(sampleRate));
        
        bridge?.start({ (_left, _right, nFrames) in
            let left = UnsafeMutableBufferPointer<Float>(_left)
            let right = UnsafeMutableBufferPointer<Float>(_right)
            process(left, right, Int(nFrames))
        })
    }
    
    public static func start(process: @escaping (
        _ input: UnsafeBufferPointer<Float>,
        _ left: UnsafeMutableBufferPointer<Float>,
        _ right: UnsafeMutableBufferPointer<Float>,
        _ numFrames: Int) -> Void) {
        bridge = RtSwiftBridge()
        
        bridge.sampleRate = sampleRate
        bridge.enableInput = enableInput
        Stk.setSampleRate(Float(sampleRate));
        
        bridge?.startFullDuplex({ (_input, _left, _right, nFrames) in
            let input = UnsafeBufferPointer<Float>(_input)
            let left = UnsafeMutableBufferPointer<Float>(_left)
            let right = UnsafeMutableBufferPointer<Float>(_right)
            process(input, left, right, Int(nFrames))
        })
    }
}
