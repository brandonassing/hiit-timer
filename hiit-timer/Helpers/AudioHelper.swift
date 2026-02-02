//
//  AudioHelper.swift
//  hiit-timer
//
//  Created by Brandon Assing on 2025-12-14.
//

import Foundation
import AVFoundation
import AudioToolbox

class AudioHelper {
    static func playBeep() {
        // Use system sound for beep (1054 is a standard beep sound)
        AudioServicesPlaySystemSound(1054)
    }
}

