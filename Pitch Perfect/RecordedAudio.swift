//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Daniel Brand on 24.03.16.
//  Copyright © 2016 Liquidsunset. All rights reserved.
//

import Foundation
import AVFoundation;

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
    func getAudioLengthInSec() -> Double {
        let asset = AVURLAsset(URL: filePathUrl, options: nil)
        let audioDuration = asset.duration
        let audioDurationInSeconds = CMTimeGetSeconds(audioDuration)
        let roundSeconds = round(audioDurationInSeconds * 10) / 10
        
        return roundSeconds
    }
}