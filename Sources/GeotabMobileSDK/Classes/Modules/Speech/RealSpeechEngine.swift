//
//  RealSpeechEngine.swift
//  GeotabDriveSDK
//
//  Created by Chet Chhom on 2020-01-20.
//

import AVFoundation

class RealSpeechEngine: SpeechEngine {
    public func speak(text: String, rate: Float = 0.5, language: String = "en-US") {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = rate

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}