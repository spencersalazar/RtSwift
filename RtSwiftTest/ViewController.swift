//
//  ViewController.swift
//  RtSwiftTest
//
//  Created by Spencer Salazar on 2/6/17.
//  Copyright © 2017 Spencer Salazar. All rights reserved.
//

import UIKit
import RtSwift

class ViewController: UIViewController {
    
    var phase1: Float = 0
    var phase2: Float = 0
    var freq1: Float = 220
    var freq2: Float = 221
    
    var file: FileWvIn! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        file = FileWvIn()
        file.openFile(Bundle.main.path(forResource: "snare_01.wav", ofType: ""))
        
        RtSwift.start(process: { (left, right, numFrames) in
            for i in 0..<Int(numFrames) {
                let samp1 = sinf(self.phase1*2*Float(M_PI))
                let samp2 = sinf(self.phase2*2*Float(M_PI)) + self.file.tick()
                left[i] = samp2
                right[i] = left[i]
                self.phase1 += Float(self.freq1)/Float(RtSwift.sampleRate)
                if self.phase1 > 1 {
                    self.phase1 -= 1
                }
                self.phase2 += Float(self.freq2+samp1*1000)/Float(RtSwift.sampleRate)
                if self.phase2 > 1 {
                    self.phase2 -= 1
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func slider1(_ slider: UISlider) {
        freq1 = slider.value
    }
    
    @IBAction func slider2(_ slider: UISlider) {
        freq2 = slider.value
    }
}

