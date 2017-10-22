//
//  TextToSpeechService.swift
//  GrammarChecker
//
//  Created by Ahmed El-Kollaly on 10/17/17.
//  Copyright © 2017 Ahmed El-Kollaly. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class TextToSpeechService: UIViewController, AVSpeechSynthesizerDelegate  {
    
    static var speechVoice : AVSpeechSynthesisVoice?
    static let synthesizer = AVSpeechSynthesizer()
    static func textToSpeech(_ text: String){
        
        DispatchQueue.main.async {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            }
            catch let error as NSError {
                print("Error: Could not set audio category: \(error), \(error.userInfo)")
            }
            
            do {
                try AVAudioSession.sharedInstance().setActive(true)
            }
            catch let error as NSError {
                print("Error: Could not setActive to true: \(error), \(error.userInfo)")
            }
            let utten  = AVSpeechUtterance(string: text)
            
            utten.voice = AVSpeechSynthesisVoice(language: "en-US")
            //            utten.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Samantha-premium".raw)
            //            print(speechVoice?.language)
            utten.rate = 0.5
            let synth = synthesizer
            
            synth.speak(utten)
            
        }
        
        
        
    }
    static func getVoice(){
        let voices = AVSpeechSynthesisVoice.speechVoices()
        for voice in voices {
            if "Samantha" == voice.name {
                print(voice)
                self.speechVoice = voice
                break;
            }
        }
    }
}
