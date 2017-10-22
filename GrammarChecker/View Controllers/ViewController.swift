//
//  ViewController.swift
//  GrammarChecker
//
//  Created by Ahmed El-Kollaly on 10/10/17.
//  Copyright © 2017 Ahmed El-Kollaly. All rights reserved.
//

import UIKit
import Speech
import AVFoundation

public class ViewController: UIViewController, SFSpeechRecognizerDelegate ,SFSpeechRecognitionTaskDelegate{
    // MARK: Properties
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    var text = ""
    @IBOutlet var textView : UITextView!
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet var recordButton : UIButton!
    @IBOutlet weak var resultTextLabel: UILabel!
    
    @IBOutlet weak var correctionLabel: UILabel!
    // MARK: UIViewController
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable the record buttons until authorization has been granted.
        recordButton.isEnabled = false
//        correctionLabel.isHidden = true
        resultTextLabel.isHidden = true
        activityIndicator.isHidden = true
        
       
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            /*
             The callback may not be called on the main thread. Add an
             operation to the main queue to update the record button's state.
             */
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.recordButton.isEnabled = true
                    
                case .denied:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("User denied access to speech recognition", for: .disabled)
                    
                case .restricted:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition restricted on this device", for: .disabled)
                    
                case .notDetermined:
                    self.recordButton.isEnabled = false
                    self.recordButton.setTitle("Speech recognition not yet authorized", for: .disabled)
                }
            }
        }
    }
    public func speechRecognizer(_ completationHandler: () -> Void){
        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do{
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
            
            
            try audioSession.setMode(AVAudioSessionModeMeasurement)
        }catch{
            return
        }
       
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        //        guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                self.textLabel.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
                
                
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do{
            try audioEngine.start()
        }catch{
            return
        }
        
        
        textLabel.text = "I'm listening"
    }
    private func startRecording() throws {
        
        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)


        try audioSession.setMode(AVAudioSessionModeMeasurement)

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

//        guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }

        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true

        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false

            if let result = result {
                self.textLabel.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }

            if error != nil || isFinal {

                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil

                self.recordButton.isEnabled = true


            }
        }

        

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()

        try audioEngine.start()

        textLabel.text = "I'm listening"
        
    }
    
    // MARK: SFSpeechRecognizerDelegate
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            
            recordButton.isEnabled = true

        } else {
            recordButton.isEnabled = false
            
        }
    }
    
    // MARK: Interface Builder actions
    
    @IBAction func recordButtonTapped() {
        if audioEngine.isRunning {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.isEnabled = false
            
            OperationQueue.main.addOperation {
                self.speakText()
            }
            


        } else {
            OperationQueue.main.addOperation {
                TextToSpeechService.stopTextToSpeech()
            }
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            try! startRecording()

        }
      
    }
    
    
    public func speakText(){
        
        
        if let text = self.textLabel.text {
            
            let words = TextProcessingService.textProcessing(text)
            let checker = GrammarCheckingService.grammarChecking(words)
            
            
            self.textLabel.text = checker.0
            self.resultTextLabel.text = checker.1
            //                        self.correctionLabel.isHidden = false
            self.resultTextLabel.isHidden = false
            if checker.0 == checker.1 {
                TextToSpeechService.textToSpeech("no mistakes")
            }else{
                
                TextToSpeechService.textToSpeech("The correction is \(checker.1)")
            }
        }
    }
    
}

