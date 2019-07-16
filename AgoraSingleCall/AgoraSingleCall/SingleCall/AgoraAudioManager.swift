//
//  AgoraAudioManager.swift
//  AgoraSingleCall
//
//  Created by Macbook Pro on 2019/7/16.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import AVFoundation

class AgoraAudioManager: NSObject {
    static let shared = AgoraAudioManager()
    private override init() { }
    
    private var audioPlayer: AVAudioPlayer?
    
    /// 播放音乐
    func play() {
        stop()
        
        if let url = Bundle.main.url(forResource: "voip_calling_ring", withExtension: "mp3"), let audioPlayer = try? AVAudioPlayer(contentsOf: url) {
            self.audioPlayer = audioPlayer
            audioPlayer.numberOfLoops = -1
            audioPlayer.volume = 1
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
    }
    
    /// 停止播放
    func stop() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.triggerVibrate), object: nil)
        if audioPlayer != nil {
            audioPlayer?.stop()
            audioPlayer = nil
            
            try? AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
        }
    }
    
    /// 震动
    @objc func triggerVibrate() {
        if let version = Double(UIDevice.current.systemVersion), version >= 9 {
            AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate) {
                DispatchQueue.main.async {
                    self.perform(#selector(self.triggerVibrate), with: nil, afterDelay: 1.5)
                }
            }
        } else {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            perform(#selector(triggerVibrate), with: nil, afterDelay: 1.5)
        }
    }
}
