//
//  ViewController.swift
//  SoundClassificationTest
//
//  Created by Moon on 2019/9/1.
//  Copyright © 2019 MarvinLin.io. All rights reserved.
//

import UIKit
import CoreML
import AVFoundation
import SoundAnalysis

class ViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    
    lazy private var model: MLModel = {
        
        let mlModel = BabyIsCrying_1()
        let model: MLModel = mlModel.model
        return model
    }()
    
    private var audioEngine: AVAudioEngine?
    private var streamAnalyzer: SNAudioStreamAnalyzer?
    fileprivate var date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UI methods
    fileprivate func showBackgroundUI() {
        
        view.backgroundColor = .green
        resultLabel.text = "安全,嬰兒沒有在哭\n😇😇😇😇😇"
        
    }
    
    fileprivate func showBabyIsCryintUI() {
        view.backgroundColor = .red
        let cryingTime = Date().timeIntervalSince(date)
        let cryingText = String(format: "嬰兒在哭!嬰兒哭了 %.0f 秒~~~\n😱😱😱😱😱", cryingTime)
        resultLabel.text = cryingText
    }
    
    fileprivate func resetTime() {
        date = Date()
    }
    
    // MARK: - MLModel
    
    private func startAudioEngine() {
        // Create a new audio engine.
        
        date = Date(timeIntervalSinceNow: 0)
        
        audioEngine = AVAudioEngine()
        
        var inputFormat: AVAudioFormat
        
        do {
            
            // Get the native audio format of the engine's input bus.
            if let _inputFormat = audioEngine?.inputNode.inputFormat(forBus: 0) {

                // Create a new stream analyzer.
                streamAnalyzer = SNAudioStreamAnalyzer(format: _inputFormat)
                inputFormat = _inputFormat
                
                do {
                    // Prepare a new request for the trained model.
                    let request = try SNClassifySoundRequest(mlModel: model)
                    try streamAnalyzer?.add(request, withObserver: self)
                } catch {
                    print("Unable to prepare request: \(error.localizedDescription)")
                    return
                }
                
                let analysisQueue = DispatchQueue(label: "com.apple.AnalysisQueue")
                
                // Install an audio tap on the audio engine's input node.
                audioEngine?.inputNode.installTap(onBus: 0,
                                                 bufferSize: 8192, // 8k buffer
                                                 format: inputFormat) { [weak self] buffer, time in
                    
                    // Analyze the current audio buffer.
                    analysisQueue.async {
                        self?.streamAnalyzer?.analyze(buffer, atAudioFramePosition: time.sampleTime)
                    }
                }
                
                // Start the stream of audio data.
                try audioEngine?.start()
            }

        } catch {
            print("Unable to start AVAudioEngine: \(error.localizedDescription)")
        }
    }
    
    // MARK: - IBAction

    @IBAction func startButtonTapped(_ sender: Any) {

        startAudioEngine()
    }
    
}

extension ViewController: SNResultsObserving {
    
    func request(_ request: SNRequest, didProduce result: SNResult) {
        
        // Get the top classification.
        guard let result = result as? SNClassificationResult,
            let classification = result.classifications.first else { return }
        
        // Determine the time of this result.
        let formattedTime = String(format: "%.2f", result.timeRange.start.seconds)
        print("Analysis result for audio at time: \(formattedTime)")
        
        let confidence = classification.confidence * 100.0
        let percent = String(format: "%.2f%%", confidence)

        // Print the result as Instrument: percentage confidence.
        print("\(classification.identifier): \(percent) confidence.\n")
        
        DispatchQueue.main.async { [weak self] in
            if confidence > 85 {
                if classification.identifier == "BabyCrying" {
                    self?.showBabyIsCryintUI()
                } else {
                    self?.showBackgroundUI()
                    self?.resetTime()
                }
            } else {
                self?.showBackgroundUI()
                self?.resetTime()
            }
        }
        
    }
    
    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("The the analysis failed: \(error.localizedDescription)")
    }
    
    func requestDidComplete(_ request: SNRequest) {
        print("The request completed successfully!")
    }
    
}

