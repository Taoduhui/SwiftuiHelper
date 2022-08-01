//
//  UIDeviceExtension.swift
//  test1
//
//  Created by kagarikoumei on 2022/6/6.
//

import Foundation
import AudioToolbox

class Vibration {
    static func Instance(){
        
    }
    
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
