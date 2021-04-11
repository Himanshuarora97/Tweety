//
//  SoundHelper.swift
//  Tweety
//
//  Created by Himanshu Arora on 12/04/21.
//

import Foundation
import AVFoundation

class SoundHelper {
    
    // singleton instance
    static let sharedInstance = SoundHelper()
    
    private var audioPlayer: AVPlayer?
    
    func playTweetSound() {
        guard let url = Bundle.main.url(forResource: "birds", withExtension: "mp3") else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = AVPlayer(url: url)
            audioPlayer?.automaticallyWaitsToMinimizeStalling = false
            audioPlayer?.playImmediately(atRate: 1.0)
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
}
