//
//  AgoraVideoCallManager.swift
//  AgoraSingleCall
//
//  Created by Macbook Pro on 2019/7/16.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import AgoraRtcEngineKit

class AgoraVideoCallManager: NSObject {
    static let shared = AgoraVideoCallManager()
    var agoraKit: AgoraRtcEngineKit!
    
    func setup() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId:  AgoraManager.shared.appId, delegate: self)
    }
    
    var rtcEngineFirstRemoteVideoDecodedOfUidClosure: ((AgoraRtcEngineKit, UInt) -> Void)?
    var rtcEngineDidOfflineOfUidClosure: ((AgoraRtcEngineKit, Int, AgoraUserOfflineReason) -> Void)?
    var rtcEnginedidVideoMutedClosure: ((AgoraRtcEngineKit, Bool, Int) -> Void)?
    
    var callStatusChangedClosure: ((AgoraCallStatus) -> Void)?
    
    var callStatus = AgoraCallStatus.dialing {
        didSet {
            if oldValue != callStatus {
                callStatusChangedClosure?(callStatus)
            }
            
            if callStatus == .hangupUnNormal || callStatus == .hangupNormal {
                duration = 0
            }
        }
    }
    
    var durationChangedClosure: ((Int) -> Void)?
    var duration: Int = 0 {
        didSet {
            durationChangedClosure?(duration)
        }
    }
}

extension AgoraVideoCallManager {
    func prepare() {
        agoraKit.enableVideo()
        agoraKit.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size: AgoraVideoDimension640x360,
                                                                             frameRate: .fps15,
                                                                             bitrate: AgoraVideoBitrateStandard,
                                                                             orientationMode: .adaptative))
    }
    
    func setLocalView(_ view: UIView?, uid: UInt) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = view
        videoCanvas.renderMode = .hidden
        agoraKit.setupLocalVideo(videoCanvas)
    }
    
    func setRemoteView(_ view: UIView?, uid: UInt) {
        print("setRemoteView", uid)
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = view
        videoCanvas.renderMode = .hidden
        agoraKit.setupRemoteVideo(videoCanvas)
    }
    
    func setMute(isMute: Bool) {
        agoraKit.muteAllRemoteAudioStreams(isMute)
    }
    
    func switchCamera() {
        agoraKit.switchCamera()
    }
    
    func joinChannel(account: String, channel: String, success: @escaping (String) -> Void) {
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        agoraKit.joinChannel(byUserAccount: account, token: nil, channelId: channel) { (channel, uid, _) in
            success(channel)
        }
        
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func joinChannel(uid: UInt, channel: String, success: @escaping (String) -> Void) {
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        agoraKit.joinChannel(byToken: nil, channelId: channel, info: nil, uid: uid) { (channel, uid, elapsed) in
            success(channel)
        }
        
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func leaveChannel() {
        agoraKit.leaveChannel(nil)
        UIApplication.shared.isIdleTimerDisabled = false
    }
}

extension AgoraVideoCallManager {
    @objc private func autoAddOneSecond() {
        duration += 1
    }
}

extension AgoraVideoCallManager: AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didApiCallExecute error: Int, api: String, result: String) {
        print(#function, api, result, error)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        print(#function, errorCode.rawValue)
        if errorCode != .noError {
            callStatus = .hangupUnNormal
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid:UInt, size:CGSize, elapsed:Int) {
        print(#function)
        rtcEngineFirstRemoteVideoDecodedOfUidClosure?(engine, uid)
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print(#function)
        callStatus = .active
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid:UInt, reason:AgoraUserOfflineReason) {
        print(#function)
        rtcEngineDidOfflineOfUidClosure?(engine, Int(uid), reason)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportRtcStats stats: AgoraChannelStats) {
        print(#function, stats.duration)
        duration = stats.duration
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(autoAddOneSecond), object: nil)
        perform(#selector(autoAddOneSecond), with: nil, afterDelay: 1)
    }
}
