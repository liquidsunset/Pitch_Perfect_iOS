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

    var receivedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var audioPlayerNode: AVAudioPlayerNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }
    
    @IBAction func playAudioSlow(sender: UIButton) {
        playAudioWithVariablePitchOrRate(nil, rate: 0.5)
    }

    @IBAction func playAudioFast(sender: UIButton) {
        playAudioWithVariablePitchOrRate(nil, rate: 1.5)
    }
    
    @IBAction func playAudioChipmunk(sender: UIButton) {
        playAudioWithVariablePitchOrRate(1000, rate: nil)
    }
    
    @IBAction func playAudioDarthVader(sender: UIButton) {
        playAudioWithVariablePitchOrRate(-1000,   rate: nil)
    }
    
    
    private func playAudioWithVariablePitchOrRate(pitch: Float?, rate: Float?){
        reinitAudioEngine()
        
        let changePitchEffect = AVAudioUnitTimePitch()
        
        if  rate == nil {
            changePitchEffect.pitch = pitch!
        }else {
            changePitchEffect.rate = rate!
        }
        
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        playSoundWithEffect()
    }
    
    @IBAction func playAudioEcho(sender: UIButton) {
        reinitAudioEngine()
        
        let echoEffect = AVAudioUnitDelay()
        echoEffect.delayTime = NSTimeInterval(0.5)
        audioEngine.attachNode(echoEffect)
        
        audioEngine.connect(audioPlayerNode, to: echoEffect, format: nil)
        audioEngine.connect(echoEffect, to: audioEngine.outputNode, format: nil)
        
        playSoundWithEffect()
    }
    
    @IBAction func playAudioReverb(sender: UIButton) {
        reinitAudioEngine()
        
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverbEffect.wetDryMix = 50
        audioEngine.attachNode(reverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        playSoundWithEffect()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioEngine.stop()
        audioEngine.reset()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func reinitAudioEngine(){
        audioEngine.stop()
        audioEngine.reset()
        audioPlayerNode = AVAudioPlayerNode()

        audioEngine.attachNode(audioPlayerNode)
    }
    
    private func playSoundWithEffect(){
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        audioPlayerNode.play()
    }

}
