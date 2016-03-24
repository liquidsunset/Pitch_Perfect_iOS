//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Daniel Brand on 23.03.16.
//  Copyright © 2016 Liquidsunset. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true

    }
    
    @IBAction func playAudioSlow(sender: UIButton) {
        playAudioWithVariableRate(0.5)
    }

    @IBAction func playAudioFast(sender: UIButton) {
        playAudioWithVariableRate(1.5)
    }
    
    private func playAudioWithVariableRate(rate: Float){
        audioPlayer.stop()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func playAudioChipmunk(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playAudioDarthVader(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    
    private func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        audioPlayerNode.play()
    }
    
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
