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
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: self)
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
    /// 警告：开发者可以忽略
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        print(#function, warningCode.rawValue)
    }
    
    /// 错误：无法忽略
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        print(#function, errorCode.rawValue)
        if errorCode != .noError {
            callStatus = .hangupUnNormal
        } else {
            callStatus = .hangupNormal
        }
    }
    
    /// SDK 执行的方法
    func rtcEngine(_ engine: AgoraRtcEngineKit, didApiCallExecute error: Int, api: String, result: String) {
        print(#function, api, error, result)
    }
    
    /// 本地用户加入 channel, 与 joinSuccessBlock 一样
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        print(#function, channel, uid, elapsed)
    }
    
    /// 本地用户重新加入频道
    func rtcEngine(_ engine: AgoraRtcEngineKit, didRejoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        print(#function, channel, uid, elapsed)
    }
    
    /// 本地用户离开 channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didLeaveChannelWith stats: AgoraChannelStats) {
        print(#function, stats)
    }
    
    /// 本地注册了一个用户
    func rtcEngine(_ engine: AgoraRtcEngineKit, didRegisteredLocalUser userAccount: String, withUid uid: UInt) {
        print(#function, userAccount, uid)
    }
    
    /// 获取远端用户和ID时调用
    func rtcEngine(_ engine: AgoraRtcEngineKit, didUpdatedUserInfo userInfo: AgoraUserInfo, withUid uid: UInt) {
        print(#function, userInfo, uid)
    }
    
    /// 本地用户切换为 直播时 调用，（调用setClientRole时调用）
    func rtcEngine(_ engine: AgoraRtcEngineKit, didClientRoleChanged oldRole: AgoraClientRole, newRole: AgoraClientRole) {
        print(#function, oldRole, newRole)
    }
    
    /// 远端加入了 channel，或重新加入 channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print(#function, uid, elapsed)
        callStatus = .active
    }
    
    /// 远端离开了 channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid:UInt, reason:AgoraUserOfflineReason) {
        print(#function, uid, reason.rawValue)
        rtcEngineDidOfflineOfUidClosure?(engine, Int(uid), reason)
    }
    
    /// 连接状态改变
    func rtcEngine(_ engine: AgoraRtcEngineKit, connectionChangedTo state: AgoraConnectionStateType, reason: AgoraConnectionChangedReason) {
        print(#function, state.rawValue, reason.rawValue)
    }
    
    /// 本地网络连接状态改变
    func rtcEngine(_ engine: AgoraRtcEngineKit, networkTypeChangedTo type: AgoraNetworkType) {
        print(#function, type.rawValue)
    }
    
    ///
    func rtcEngineConnectionDidLost(_ engine: AgoraRtcEngineKit) {
        print(#function)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid:UInt, size:CGSize, elapsed:Int) {
        print(#function)
        rtcEngineFirstRemoteVideoDecodedOfUidClosure?(engine, uid)
    }
    
    
    
    
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportRtcStats stats: AgoraChannelStats) {
        print(#function, stats.duration)
        duration = stats.duration
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(autoAddOneSecond), object: nil)
        perform(#selector(autoAddOneSecond), with: nil, afterDelay: 1)
    }
}
