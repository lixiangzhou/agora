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
    
    var callStatus = AgoraCallStatus.dialing {
        didSet {
            if oldValue != callStatus {
                NotificationCenter.default.post(name: Notification.Name.YGXQ.VideoCallStatusChanged, object: callStatus)
            }
            
            if callStatus == .hangupUnNormal || callStatus == .hangupNormal || callStatus == .active {
                duration = 0
            }
            
            if callStatus == .active {
                startTimer()
            } else {
                stopTimer()
            }
        }
    }
    
    var duration: Int = 0 {
        didSet {
            if oldValue != duration {
                NotificationCenter.default.post(name: Notification.Name.YGXQ.VideoCallDurationChanged, object: duration)
            }
        }
    }
    
    private var timer: Timer?
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
    
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(autoAddOneSecond), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

extension AgoraVideoCallManager: AgoraRtcEngineDelegate {
    // MARK: - Core Delegate Methods
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
        NotificationCenter.default.post(name: Notification.Name.YGXQ.DidRegisteredLocalUser, object: uid)
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
        if reason == .quit {
            callStatus = .hangupNormal
        } else {
            callStatus = .hangupUnNormal
        }
    }
    
    /// 连接状态改变
    func rtcEngine(_ engine: AgoraRtcEngineKit, connectionChangedTo state: AgoraConnectionStateType, reason: AgoraConnectionChangedReason) {
        print(#function, state.rawValue, reason.rawValue)
    }
    
    /// 本地网络连接状态改变
    func rtcEngine(_ engine: AgoraRtcEngineKit, networkTypeChangedTo type: AgoraNetworkType) {
        print(#function, type.rawValue)
    }
    
    /// 超过10s 没有连接会调用
    func rtcEngineConnectionDidLost(_ engine: AgoraRtcEngineKit) {
        print(#function)
    }
    
    /// token 超时30s
    func rtcEngine(_ engine: AgoraRtcEngineKit, tokenPrivilegeWillExpire token: String) {
        print(#function)
    }
    
    /// token 超时时调用，SDK 失去连接后，token会超时，需要一个新的token来重连服务，此回调通知app重新生成一个token重连服务
    func rtcEngineRequestToken(_ engine: AgoraRtcEngineKit) {
        print(#function)
    }
    
    // MARK: - Media Delegate Methods
    /// 本地麦克风是否可用
    func rtcEngine(_ engine: AgoraRtcEngineKit, didMicrophoneEnabled enabled: Bool) {
        print(#function, enabled)
    }
    
    /// 说话声音大小的回调
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportAudioVolumeIndicationOfSpeakers speakers: [AgoraRtcAudioVolumeInfo], totalVolume: Int) {
        print(#function, speakers, totalVolume)
    }
    
    /// 最近说话的用户
    func rtcEngine(_ engine: AgoraRtcEngineKit, activeSpeaker speakerUid: UInt) {
        print(#function, speakerUid)
    }
    
    /// 本地发送第一帧声音时
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstLocalAudioFrame elapsed: Int) {
        print(#function, elapsed)
    }
    
    /// 收到指定用户的第一帧声音时
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteAudioFrameOfUid uid: UInt, elapsed: Int) {
        print(#function, uid, elapsed)
    }
    
    /// 解析远端第一帧声音时
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteAudioFrameDecodedOfUid uid: UInt, elapsed: Int) {
        print(#function, uid, elapsed)
    }
    
    /// 发送第一帧视频数据时
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstLocalVideoFrameWith size: CGSize, elapsed: Int) {
        print(#function, size, elapsed)
    }
    
    /// 第一帧远端视频解析时
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid:UInt, size:CGSize, elapsed:Int) {
        print(#function, uid, size, elapsed)
        NotificationCenter.default.post(name: Notification.Name.YGXQ.FirstRemoteVideoDecoded, object: uid)
    }
    
    /// 第一帧远端视频渲染时
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoFrameOfUid uid: UInt, size: CGSize, elapsed: Int) {
        print(#function, uid, size, elapsed)
    }
    
    /// 远端特定用户静音调整
    func rtcEngine(_ engine: AgoraRtcEngineKit, didAudioMuted muted: Bool, byUid uid: UInt) {
        print(#function, muted, uid)
    }
    
    /// 远端特定用户暂停还是播放
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted: Bool, byUid uid: UInt) {
        print(#function, muted, uid)
    }
    
    /// 远端用户是否开启视频
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoEnabled enabled: Bool, byUid uid: UInt) {
        print(#function, enabled, uid)
    }
    
    /// 本地用户是否开启视频
    func rtcEngine(_ engine: AgoraRtcEngineKit, didLocalVideoEnabled enabled: Bool, byUid uid: UInt) {
        print(#function, enabled, uid)
    }
    
    /// 远端用户的视频大小或方向改变时
    func rtcEngine(_ engine: AgoraRtcEngineKit, videoSizeChangedOfUid uid: UInt, size: CGSize, rotation: Int) {
        print(#function, uid, size, rotation)
    }
    
    /// 远端视频流状态改变
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteVideoStateChangedOfUid uid: UInt, state: AgoraVideoRemoteState) {
        print(#function, uid, state.rawValue)
    }
    
    /// 本地视频流状态改变
    func rtcEngine(_ engine: AgoraRtcEngineKit, localVideoStateChange state: AgoraLocalVideoStreamState, error: AgoraLocalVideoStreamError) {
        print(#function, state.rawValue, error.rawValue)
    }
    
    
    // MARK: - Statistics Delegate Methods
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportRtcStats stats: AgoraChannelStats) {
        print(#function, stats.duration)
    }
    
    /// 在用户加入channel 前，用户最后1公里的网络质量，每2s一次
    func rtcEngine(_ engine: AgoraRtcEngineKit, lastmileQuality quality: AgoraNetworkQuality) {
        print(#function, quality.rawValue)
    }
    
    /// 每2s一次，报告每个用户的网络质量
    func rtcEngine(_ engine: AgoraRtcEngineKit, networkQuality uid: UInt, txQuality: AgoraNetworkQuality, rxQuality: AgoraNetworkQuality) {
        print(#function, uid, txQuality.rawValue, rxQuality.rawValue)
    }
    
    /// 30s一次
    func rtcEngine(_ engine: AgoraRtcEngineKit, lastmileProbeTest result: AgoraLastmileProbeResult) {
        print(#function, result)
    }
    
    /// 2s一次，本地视频流的统计
    func rtcEngine(_ engine: AgoraRtcEngineKit, localVideoStats stats: AgoraRtcLocalVideoStats) {
        print(#function, stats)
    }
    
    /// 2s一次，远端视频流的统计
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteVideoStats stats: AgoraRtcRemoteVideoStats) {
        print(#function, stats)
    }
    
    /// 2s一次，远端音频流的统计
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteAudioStats stats: AgoraRtcRemoteAudioStats) {
        print(#function, stats)
    }
    
    /// 2s一次，远端音频流传输层的统计
    func rtcEngine(_ engine: AgoraRtcEngineKit, audioTransportStatsOfUid uid: UInt, delay: UInt, lost: UInt, rxKBitRate: UInt) {
        print(#function, uid, delay, lost, rxKBitRate)
    }
    
    /// 2s一次，远端视频流传输层的统计
    func rtcEngine(_ engine: AgoraRtcEngineKit, videoTransportStatsOfUid uid: UInt, delay: UInt, lost: UInt, rxKBitRate: UInt) {
        print(#function, uid, delay, lost, rxKBitRate)
    }
    
    // MARK: - Audio Player Delegate Methods
    /// 本地音频混合文件播放完成
    func rtcEngineLocalAudioMixingDidFinish(_ engine: AgoraRtcEngineKit) {
        print(#function)
    }
    
    /// 本地音频混合文件播放状态改变
    func rtcEngine(_ engine: AgoraRtcEngineKit, localAudioMixingStateDidChanged state: AgoraAudioMixingStateCode, errorCode: AgoraAudioMixingErrorCode) {
        print(#function, state.rawValue, errorCode.rawValue)
    }
    
    /// 远端开始音频混合
    func rtcEngineRemoteAudioMixingDidStart(_ engine: AgoraRtcEngineKit) {
        print(#function)
    }
    
    /// 远端音频混合文件播放完成
    func rtcEngineRemoteAudioMixingDidFinish(_ engine: AgoraRtcEngineKit) {
        print(#function)
    }
    
    /// 本地音频 effect 播放完成
    func rtcEngineDidAudioEffectFinish(_ engine: AgoraRtcEngineKit, soundId: Int) {
        print(#function)
    }
    
    // MARK: - Stream Message Delegate Methods
    /// 5s内本地用户收到远端用户的数据流
    func rtcEngine(_ engine: AgoraRtcEngineKit, receiveStreamMessageFromUid uid: UInt, streamId: Int, data: Data) {
        print(#function, uid, streamId, data)
    }
    
    /// 5s内本地用户没有收到远端用户的数据流
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurStreamMessageErrorFromUid uid: UInt, streamId: Int, error: Int, missed: Int, cached: Int) {
        print(#function, uid, streamId, error, missed, cached)
    }
    
    // MARK: - Miscellaneous Delegate Methods
    /// 加载媒体引擎时
    func rtcEngineMediaEngineDidLoaded(_ engine: AgoraRtcEngineKit) {
        print(#function)
    }
    
    /// 媒体引擎开启的时候
    func rtcEngineMediaEngineDidStartCall(_ engine: AgoraRtcEngineKit) {
        print(#function)
    }
}
