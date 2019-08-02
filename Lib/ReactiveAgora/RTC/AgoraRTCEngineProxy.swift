//
//  AgoraRTCEngineProxy.swift
//  ReactiveAgora
//
//  Created by lixiangzhou on 2019/7/20.
//Copyright © 2019 LXZ. All rights reserved.
//

import Foundation
import AgoraRtcEngineKit
import ReactiveSwift

class AgoraRTCEngineProxy: NSObject {
    
    /// 创建 AgoraRtcEngineKit Proxy
    ///
    /// - Parameter delegate: AgoraRtcEngineDelegate，如果为nil，则默认代理为自己
    convenience init(delegate: AgoraRtcEngineDelegate? = nil) {
        self.init()
        rtcEngineKit = AgoraRtcEngineKit.sharedEngine(withAppId: agoraAppID, delegate: delegate ?? self)
        
    }
    
    /// AgoraRtcEngineKit 提供了需要的所有方法，AgoraRtcEngineKit是SDK的基本接口类，一个AgoraRtcEngineKit只能使用一个AppID，如果需要修改AppID，先调用 destroy 方法释放当前实例，然后再调用 AgoraRtcEngineKit.sharedEngine(withAppId:delegate:) 方法创建新的实例

    var rtcEngineKit: AgoraRtcEngineKit!
    
    // ------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------
    // MARK: - Method CallBack Signal
    
    // MARK: - Core Service Methods Signal
    
    /// 用户加入频道方法 信号量
    ///
    /// func joinChannel(byToken: String?, channelId: String, info: String?, uid: UInt, joinSuccess: ((String, UInt, Int) -> Void)?) -> Int32
    let (joinChannelByTokenSignal, joinChannelByTokenObserver) = Signal<((String?, String, String?, UInt), (String, UInt, Int)), Never>.pipe()
    
    /// 用户加入频道方法 信号量
    ///
    /// func joinChannel(byUserAccount: String, token: String?, channelId: String, joinSuccess: ((String, UInt, Int) -> Void)?) -> Int32
    let (joinChannelByAccountSignal, joinChannelByAccountObserver) = Signal<((String, String?, String), (String, UInt, Int)), Never>.pipe()

    /// 用户离开频道
    ///
    /// func leaveChannel(_ leaveChannelBlock: ((AgoraChannelStats) -> Void)?) -> Int32
    let (leaveChannelSignal, leaveChannelObserver) = Signal<AgoraChannelStats, Never>.pipe()
    
    
    // ------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------
    // MARK: - Delegate Signal
    
    // MARK: - Core Delegate Methods Signal
    
    /// 报告SDK运行时警告时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode)
    let (didOccurWarningSignal, didOccurWarningObserver) = Signal<(AgoraRtcEngineKit, AgoraWarningCode), Never>.pipe()

    /// 报告SDK运行时错误时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode)
    let (didOccurErrorSignal, didOccurErrorObserver) = Signal<(AgoraRtcEngineKit, AgoraErrorCode), Never>.pipe()
    
    /// SDK执行了一个方法时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, didApiCallExecute error: Int, api: String, result: String)
    let (didApiCallExecuteSignal, didApiCallExecuteObserver) = Signal<(AgoraRtcEngineKit, Int, String, String), Never>.pipe()
    
    /// 本地用户加入一个频道时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int)
    let (didJoinChannelSignal, didJoinChannelObserver) = Signal<(AgoraRtcEngineKit, String, UInt, Int), Never>.pipe()
    
    /// 本地用户重新加入一个频道时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, didRejoinChannel channel: String, withUid uid: UInt, elapsed: Int)
    let (didRejoinChannelSignal, didRejoinChannelObserver) = Signal<(AgoraRtcEngineKit, String, UInt, Int), Never>.pipe()
    
    /// 本地用户离开一个频道时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, didLeaveChannelWith stats: AgoraChannelStats)
    let (didLeaveChannelSignal, didLeaveChannelObserver) = Signal<(AgoraRtcEngineKit, AgoraChannelStats), Never>.pipe()
    
    /// 本地用户调用 AgoraRtcEngineKit.registerLocalUserAccount(_:appId:) 或 AgoraRtcEngineKit.joinChannel(byUserAccount:token:channelId:joinSuccess:) 成功时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, didRegisteredLocalUser userAccount: String, withUid uid: UInt)
    let (didRegisteredLocalUserSignal, didRegisteredLocalUserObserver) = Signal<(AgoraRtcEngineKit, String, UInt), Never>.pipe()
    
    /// 远端用户加入了频道后，SDK获取到远端用户的UID和account缓存到表对象userInfo中时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, didUpdatedUserInfo userInfo: AgoraUserInfo, withUid uid: UInt)
    let (didUpdatedUserInfoSignal, didUpdatedUserInfoObserver) = Signal<(AgoraRtcEngineKit, AgoraUserInfo, UInt), Never>.pipe()
    
    ///  在本地用户加入频道并转换角色后 AgoraRtcEngineKit.setClientRole(_:) 会触发此方法【直播频道配置文件下】 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, didClientRoleChanged oldRole: AgoraClientRole, newRole: AgoraClientRole)
    let (didClientRoleChangedSignal, didClientRoleChangedObserver) = Signal<(AgoraRtcEngineKit, AgoraClientRole, AgoraClientRole), Never>.pipe()
    
    /// 远端用户或主机加入通道时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int)
    let (didJoinedSignal, didJoinedObserver) = Signal<(AgoraRtcEngineKit, UInt, Int), Never>.pipe()
    
    /// 远端用户(通讯)/主机(直播)离开频道时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason)
    let (didOfflineSignal, didOfflineObserver) = Signal<(AgoraRtcEngineKit, UInt, AgoraUserOfflineReason), Never>.pipe()
    
    /// 网络连接状态改变时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, connectionChangedTo state: AgoraConnectionStateType, reason: AgoraConnectionChangedReason)
    let (connectionChangedSignal, connectionChangedObserver) = Signal<(AgoraRtcEngineKit, AgoraConnectionStateType, AgoraConnectionChangedReason), Never>.pipe()
    
    /// 本地网络类型改变时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, networkTypeChangedTo type: AgoraNetworkType)
    let (networkTypeChangedSignal, networkTypeChangedObserver) = Signal<(AgoraRtcEngineKit, AgoraNetworkType), Never>.pipe()
    
    /// 当SDK到服务器的连接中断10秒后，SDK无法重新连接到Agora的edge服务器时 代理方法信号量
    ///
    /// func rtcEngineConnectionDidLost(_ engine: AgoraRtcEngineKit)
    let (connectionDidLostSignal, connectionDidLostObserver) = Signal<(AgoraRtcEngineKit), Never>.pipe()
    
    /// token在30秒内过期时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, tokenPrivilegeWillExpire token: String)
    let (tokenPrivilegeWillExpireSignal, tokenPrivilegeWillExpireObserver) = Signal<(AgoraRtcEngineKit, String), Never>.pipe()
    
    /// token过期时 代理方法信号量
    ///
    /// func rtcEngineRequestToken(_ engine: AgoraRtcEngineKit)
    let (requestTokenSignal, requestTokenObserver) = Signal<(AgoraRtcEngineKit), Never>.pipe()
    
    // ------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------
    // MARK: - Media Delegate Methods Signal
    
    /// 本地用户通过调用 AgoraRtcEngineKit.enableLocalAudio(_:) 方法恢复或停止捕获本地音频流时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, didMicrophoneEnabled enabled: Bool)
    let (didMicrophoneEnabledSignal, didMicrophoneEnabledObserver) = Signal<(AgoraRtcEngineKit, Bool), Never>.pipe()
    
    /// 报告哪些用户正在说话，以及说话者当前的音量时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, reportAudioVolumeIndicationOfSpeakers speakers: [AgoraRtcAudioVolumeInfo], totalVolume: Int)
    let (reportAudioVolumeIndicationOfSpeakersSignal, reportAudioVolumeIndicationOfSpeakersObserver) = Signal<(AgoraRtcEngineKit, [AgoraRtcAudioVolumeInfo], Int), Never>.pipe()
    
    /// 报告一段时间内哪个用户是最大的说话者时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, activeSpeaker speakerUid: UInt)
    let (activeSpeakerSignal, activeSpeakerObserver) = Signal<(AgoraRtcEngineKit, UInt), Never>.pipe()
    
    /// 引擎发送第一帧本地音频时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, firstLocalAudioFrame elapsed: Int)
    let (firstLocalAudioFrameSignal, firstLocalAudioFrameObserver) = Signal<(AgoraRtcEngineKit, Int), Never>.pipe()
    
    /// 引擎从指定的远端用户接收到第一个音频帧时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteAudioFrameOfUid uid: UInt, elapsed: Int)
    let (firstRemoteAudioFrameSignal, firstRemoteAudioFrameObserver) = Signal<(AgoraRtcEngineKit, UInt, Int), Never>.pipe()
    
    /// SDK解码第一个远端音频帧以进行回放时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteAudioFrameDecodedOfUid uid: UInt, elapsed: Int)
    let (firstRemoteAudioFrameDecodedSignal, firstRemoteAudioFrameDecodedObserver) = Signal<(AgoraRtcEngineKit, UInt, Int), Never>.pipe()
    
    /// 引擎发送第一帧本地视频时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, firstLocalVideoFrameWith size: CGSize, elapsed: Int)
    let (firstLocalVideoFrameSignal, firstLocalVideoFrameObserver) = Signal<(AgoraRtcEngineKit, CGSize, Int), Never>.pipe()
    
    /// 接收和解码第一个远端视频帧时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int)
    let (firstRemoteVideoDecodedSignal, firstRemoteVideoDecodedObserver) = Signal<(AgoraRtcEngineKit, UInt, CGSize, Int), Never>.pipe()
    
    /// 第一帧远端视频帧渲染时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoFrameOfUid uid: UInt, size: CGSize, elapsed: Int)
    let (firstRemoteVideoFrameSignal, firstRemoteVideoFrameObserver) = Signal<(AgoraRtcEngineKit, UInt, CGSize, Int), Never>.pipe()

    /// 远程用户的音频流被静音/非静音时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, didAudioMuted muted: Bool, byUid uid: UInt)
    let (didAudioMutedSignal, didAudioMutedObserver) = Signal<(AgoraRtcEngineKit, Bool, UInt), Never>.pipe()
    
    /// 远端用户的视频流回放暂停/恢复时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted: Bool, byUid uid: UInt)
    let (didVideoMutedSignal, didVideoMutedObserver) = Signal<(AgoraRtcEngineKit, Bool, UInt), Never>.pipe()
    
    /// 远端用户开启/禁用视频模块时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoEnabled enabled: Bool, byUid uid: UInt)
    let (didVideoEnabledSignal, didVideoEnabledObserver) = Signal<(AgoraRtcEngineKit, Bool, UInt), Never>.pipe()
    
    /// 远端用户开启/禁用本地视频捕获方法时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, didLocalVideoEnabled enabled: Bool, byUid uid: UInt)
    let (didLocalVideoEnabledSignal, didLocalVideoEnabledObserver) = Signal<(AgoraRtcEngineKit, Bool, UInt), Never>.pipe()
    
    /// 远端用户的视频大小或方向改变时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, videoSizeChangedOfUid uid: UInt, size: CGSize, rotation: Int)
    let (videoSizeChangedSignal, videoSizeChangedObserver) = Signal<(AgoraRtcEngineKit, UInt, CGSize, Int), Never>.pipe()
    
    /// 远端视频流状态改变时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, remoteVideoStateChangedOfUid uid: UInt, state: AgoraVideoRemoteState)
    let (remoteVideoStateChangedSignal, remoteVideoStateChangedObserver) = Signal<(AgoraRtcEngineKit, UInt, AgoraVideoRemoteState), Never>.pipe()
    
    /// 本地用户视频流状态改变时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, localVideoStateChange state: AgoraLocalVideoStreamState, error: AgoraLocalVideoStreamError)
    let (localVideoStateChangeSignal, localVideoStateChangeObserver) = Signal<(AgoraRtcEngineKit, AgoraLocalVideoStreamState, AgoraLocalVideoStreamError), Never>.pipe()
    
    // ------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------
    // MARK: - Fallback Delegate Methods Signal
    
    /// 当已发布的视频流由于不可靠的网络条件而返回到只包含音频的流，或在网络条件改善时切换回视频流时调用时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, didLocalPublishFallbackToAudioOnly isFallbackOrRecover: Bool)
    let (didLocalPublishFallbackToAudioOnlySignal, didLocalPublishFallbackToAudioOnlyObserver) = Signal<(AgoraRtcEngineKit, Bool), Never>.pipe()
    
    /// 当远端视频流由于不可靠的网络条件而退回到音频流或在网络条件改善后切换回视频时调用时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, didRemoteSubscribeFallbackToAudioOnly isFallbackOrRecover: Bool, byUid uid: UInt)
    let (didRemoteSubscribeFallbackToAudioOnlySignal, didRemoteSubscribeFallbackToAudioOnlyObserver) = Signal<(AgoraRtcEngineKit, Bool, UInt), Never>.pipe()
    
    // ------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------
    // MARK: - Device Delegate Methods Signal
    
    /// 当本地音频路由发生更改时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, didAudioRouteChanged routing: AgoraAudioOutputRouting)
    let (didAudioRouteChangedSignal, didAudioRouteChangedObserver) = Signal<(AgoraRtcEngineKit, AgoraAudioOutputRouting), Never>.pipe()
    
    /// 相机焦点区域改变时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, cameraFocusDidChangedTo rect: CGRect)
    let (cameraFocusDidChangedSignal, cameraFocusDidChangedObserver) = Signal<(AgoraRtcEngineKit, CGRect), Never>.pipe()
    
    /// 当相机曝光区域发生变化时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, cameraExposureDidChangedTo rect: CGRect)
    let (cameraExposureDidChangedSignal, cameraExposureDidChangedObserver) = Signal<(AgoraRtcEngineKit, CGRect), Never>.pipe()
    
    // ------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------
    // MARK: - Statistics Delegate Methods Signal
    
    /// 每两秒报告一次当前调用会话的统计信息时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, reportRtcStats stats: AgoraChannelStats)
    let (reportRtcStatsSignal, reportRtcStatsObserver) = Signal<(AgoraRtcEngineKit, AgoraChannelStats), Never>.pipe()
    
    /// 在用户加入通道之前，每两秒报告一次本地用户的最后一英里网络质量时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, lastmileQuality quality: AgoraNetworkQuality)
    let (lastmileQualitySignal, lastmileQualityObserver) = Signal<(AgoraRtcEngineKit, AgoraNetworkQuality), Never>.pipe()
    
    /// 每两秒报告一次通道中每个用户的最后一英里网络质量时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, networkQuality uid: UInt, txQuality: AgoraNetworkQuality, rxQuality: AgoraNetworkQuality)
    let (networkQualitySignal, networkQualityObserver) = Signal<(AgoraRtcEngineKit, UInt, AgoraNetworkQuality, AgoraNetworkQuality), Never>.pipe()
    
    /// 报告最后一英里网络探测结果时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, lastmileProbeTest result: AgoraLastmileProbeResult)
    let (lastmileProbeTestSignal, lastmileProbeTestObserver) = Signal<(AgoraRtcEngineKit, AgoraLastmileProbeResult), Never>.pipe()
    
    /// 每2s报告本地视频流的统计数据时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, localVideoStats stats: AgoraRtcLocalVideoStats)
    let (localVideoStatsSignal, localVideoStatsObserver) = Signal<(AgoraRtcEngineKit, AgoraRtcLocalVideoStats), Never>.pipe()
    
    /// 报告来自每个远端用户/主机的视频流的统计数据时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, remoteVideoStats stats: AgoraRtcRemoteVideoStats)
    let (remoteVideoStatsSignal, remoteVideoStatsObserver) = Signal<(AgoraRtcEngineKit, AgoraRtcRemoteVideoStats), Never>.pipe()
    
    /// 报告来自每个远端用户/主机的音频流的统计数据时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, remoteAudioStats stats: AgoraRtcRemoteAudioStats)
    let (remoteAudioStatsSignal, remoteAudioStatsObserver) = Signal<(AgoraRtcEngineKit, AgoraRtcRemoteAudioStats), Never>.pipe()
    
    /// 报告每个音频流传输层的统计信息时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, audioTransportStatsOfUid uid: UInt, delay: UInt, lost: UInt, rxKBitRate: UInt)
    let (audioTransportStatsSignal, audioTransportStatsObserver) = Signal<(AgoraRtcEngineKit, UInt, UInt, UInt, UInt), Never>.pipe()
    
    /// 报告每个视频流传输层的统计信息时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, videoTransportStatsOfUid uid: UInt, delay: UInt, lost: UInt, rxKBitRate: UInt)
    let (videoTransportStatsSignal, videoTransportStatsObserver) = Signal<(AgoraRtcEngineKit, UInt, UInt, UInt, UInt), Never>.pipe()
    
    // ------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------
    // MARK: - Audio Player Delegate Methods Signal
    
    /// 当音频混合文件播放结束时 代理方法信号量
    ///
    /// func rtcEngineLocalAudioMixingDidFinish(_ engine: AgoraRtcEngineKit)
    let (localAudioMixingDidFinishSignal, localAudioMixingDidFinishObserver) = Signal<(AgoraRtcEngineKit), Never>.pipe()
    
    /// 当本地用户的音频混合文件的状态发生更改时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, localAudioMixingStateDidChanged state: AgoraAudioMixingStateCode, errorCode: AgoraAudioMixingErrorCode)
    let (localAudioMixingStateDidChangedSignal, localAudioMixingStateDidChangedObserver) = Signal<(AgoraRtcEngineKit, AgoraAudioMixingStateCode, AgoraAudioMixingErrorCode), Never>.pipe()
    
    /// 当远程用户启动音频混合时 代理方法信号量
    ///
    /// func rtcEngineRemoteAudioMixingDidStart(_ engine: AgoraRtcEngineKit)
    let (remoteAudioMixingDidStartSignal, remoteAudioMixingDidStartObserver) = Signal<(AgoraRtcEngineKit), Never>.pipe()
    
    /// 当远程用户结束音频混合时 代理方法信号量
    ///
    /// func rtcEngineRemoteAudioMixingDidFinish(_ engine: AgoraRtcEngineKit)
    let (remoteAudioMixingDidFinishSignal, remoteAudioMixingDidFinishObserver) = Signal<(AgoraRtcEngineKit), Never>.pipe()
    
    /// 当本地音频效果回放结束时 代理方法信号量
    ///
    /// func rtcEngineDidAudioEffectFinish(_ engine: AgoraRtcEngineKit, soundId: Int)
    let (didAudioEffectFinishSignal, didAudioEffectFinishObserver) = Signal<(AgoraRtcEngineKit, Int), Never>.pipe()
    
    // ------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------
    // MARK: - CDN Publisher Delegate Methods Signal
    
    /// 当RTMP流的状态发生更改时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, rtmpStreamingChangedToState url: String, state: AgoraRtmpStreamingState, errorCode: AgoraRtmpStreamingErrorCode)
    let (rtmpStreamingChangedToStateSignal, rtmpStreamingChangedToStateObserver) = Signal<(AgoraRtcEngineKit, String, AgoraRtmpStreamingState, AgoraRtmpStreamingErrorCode), Never>.pipe()
    
    /// 报告调用 AgoraRtcEngineKit.addPublishStreamUrl(_:transcodingEnabled:) 的结果 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, streamPublishedWithUrl url: String, errorCode: AgoraErrorCode)
    let (streamPublishedWithUrlSignal, streamPublishedWithUrlObserver) = Signal<(AgoraRtcEngineKit, String, AgoraErrorCode), Never>.pipe()
    
    /// 报告调用 AgoraRtcEngineKit.removePublishStreamUrl(_:) 的结果 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, streamUnpublishedWithUrl url: String)
    let (streamUnpublishedWithUrlSignal, streamUnpublishedWithUrlObserver) = Signal<(AgoraRtcEngineKit, String), Never>.pipe()
    
    /// 当更新CDN实时流媒体设置时 代理方法信号量
    ///
    /// func rtcEngineTranscodingUpdated(_ engine: AgoraRtcEngineKit)
    let (transcodingUpdatedSignal, transcodingUpdatedObserver) = Signal<(AgoraRtcEngineKit), Never>.pipe()
    
    // ------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------
    // MARK: - Inject Stream URL Delegate Methods Signal
    
    /// 报告向直播注入在线流的状态时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, streamInjectedStatusOfUrl url: String, uid: UInt, status: AgoraInjectStreamStatus)
    let (streamInjectedStatusOfUrlSignal, streamInjectedStatusOfUrlObserver) = Signal<(AgoraRtcEngineKit, String, UInt, AgoraInjectStreamStatus), Never>.pipe()
    
    
    // ------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------
    // MARK: - Stream Message Delegate Methods Signal
    
    /// 当本地用户在5秒内从远程用户接收到数据流时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, receiveStreamMessageFromUid uid: UInt, streamId: Int, data: Data)
    let (receiveStreamMessageSignal, receiveStreamMessageObserver) = Signal<(AgoraRtcEngineKit, UInt, Int, Data), Never>.pipe()
    
    /// 当本地用户在5秒内没有接收到来自远程用户的数据流时 代理方法信号量
    ///
    /// func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurStreamMessageErrorFromUid uid: UInt, streamId: Int, error: Int, missed: Int, cached: Int)
    let (didOccurStreamMessageErrorSignal, didOccurStreamMessageErrorObserver) = Signal<(AgoraRtcEngineKit, UInt, Int, Int, Int, Int), Never>.pipe()
    
    // ------------------------------------------------------------------------------------
    // ------------------------------------------------------------------------------------
    // MARK: - Miscellaneous Delegate Methods Signal
    
    /// 媒体引擎加载时 代理方法信号量
    ///
    /// func rtcEngineMediaEngineDidLoaded(_ engine: AgoraRtcEngineKit)
    let (mediaEngineDidLoadedSignal, mediaEngineDidLoadedObserver) = Signal<(AgoraRtcEngineKit), Never>.pipe()
    
    /// 媒体引擎调用启动时 代理方法信号量
    ///
    /// func rtcEngineMediaEngineDidStartCall(_ engine: AgoraRtcEngineKit)
    let (mediaEngineDidStartCallSignal, mediaEngineDidStartCallObserver) = Signal<(AgoraRtcEngineKit), Never>.pipe()
}


// MARK: - Method Proxy
// MARK: - Core Service
extension AgoraRTCEngineProxy {
    
    /// 销毁RtcEngine实例，并释放SDK使用的所有资源。该方法对于偶尔进行视频、语音通话很有用，可以在不通话时为其他操作释放资源。一旦调用该方法，该实例的所有回调和代理都不会被调用。为了再次重启通信，调用 AgoraRtcEngineKit.sharedEngine(withAppId:delegate:) 创建一个新的AgoraRtcEngineKit实例。**注意：在子线程调用改方法；该方法是同步的，不能在该SDK的回调中调用，否则会造成死锁**
    @objc func destroy() {
        AgoraRtcEngineKit.destroy()
    }
    
    /// 设置频道配置文件
    ///
    /// SDK需要了解应用程序场景，以便设置适当的通道配置文件来应用不同的优化方法
    ///
    /// Agora原生SDK支持以下通道配置文件:
    /// - 通讯（Communication）
    /// - 直播（Live Broadcast）
    /// - 游戏（Gaming (for the Agora Gaming SDK only)）
    ///
    /// **注意：在相同频道的用户必须使用相同的频道配置文件；调用该方法前，销毁（destroy）当前引擎并创建一个新的引擎（AgoraRtcEngineKit.sharedEngine(withAppId:delegate:)）；在用户加入该频道（AgoraRtcEngineKit.joinChannel(byToken:channelId:info:uid:joinSuccess:)）前调用此方法，因为在频道被用户使用的时候不能配置频道配置文件；在Communication配置文件下，SDK只支持原始数据编码，不支持文本编码**
    ///
    /// - Parameter profile: 频道配置文件
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setChannelProfile(_ profile: AgoraChannelProfile) -> Int {
        let result = rtcEngineKit.setChannelProfile(profile)
        return Int(result)
    }
    
    /// 设置用户的角色
    ///
    /// 该方法只适合直播配置文件。在加入频道之前，设置用户的角色，如 host 或 audience (default)。此方法可用于在用户加入通道后切换用户角色。当用户在加入通道后切换用户角色时，成功的方法调用会触发以下回调:
    /// - 本地用户：AgoraRtcEngineDelegate.rtcEngine(_:didClientRoleChanged:newRole:)
    /// - 远端用户：AgoraRtcEngineDelegate.rtcEngine(_:didJoinedOfUid:elapsed:) 或者 AgoraRtcEngineDelegate.rtcEngine(_:didOfflineOfUid:reason:)
    ///
    /// - Parameter role: 用户的角色
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setClientRole(_ role: AgoraClientRole) -> Int {
        let result = rtcEngineKit.setClientRole(role)
        return Int(result)
    }
    
    /// 用户加入频道
    ///
    /// 同一频道中的用户可以相互交谈，同一频道中的多个用户可以开始群组聊天。使用不同应用app id的用户不能相互呼叫，即使他们加入了相同的通道
    ///
    /// 在进入另一个通道之前，必须调用 AgoraRtcEngineKit.leaveChannel(_:) 方法退出当前调用。这个方法调用是异步的，因此，您可以在主用户界面线程中调用此方法
    ///
    /// SDK使用iOS的AVAudioSession共享对象进行音频录制和回放。使用此对象可能会影响SDK的音频功能
    ///
    /// 如果 AgoraRtcEngineKit.joinChannel(byToken:channelId:info:uid:joinSuccess:) 调用成功，会触发 joinSuccess 回调。如果同时实现了 joinSuccess 和 AgoraRtcEngineDelegate.rtcEngine(_:didJoinChannel:withUid:elapsed:)，joinSuccess 的优先级更高。推荐设置 joinSuccess = nil， 使用AgoraRtcEngineDelegate.rtcEngine(_:didJoinChannel:withUid:elapsed:)
    ///
    /// AgoraRtcEngineKit.joinChannel(byToken:channelId:info:uid:joinSuccess:) 调用成功会触发：
    /// - 本地用户 AgoraRtcEngineDelegate.rtcEngine(_:didJoinChannel:withUid:elapsed:)
    /// - 远端用户 AgoraRtcEngineDelegate.rtcEngine(_:didJoinedOfUid:elapsed:)【在通讯配置文件和直播配置文件】
    ///
    /// 当客户和Agora服务器之间的连接由于网络条件不好而中断时，SDK会尝试重新连接到服务器。当本地客户端成功地重新加入频道时，SDK将在本地客户端上触发AgoraRtcEngineDelegate.rtcEngine(_:didRejoinChannel:withUid:elapsed:)回调
    ///
    /// **注意：**
    /// - 频道不接受重复的uid。如果您将 uid 设置为0，系统将自动分配一个 uid。如果希望在不同的设备上连接相同的频道，请确保为每个设备使用不同的uid。
    /// - 加入频道时，SDK调用 AVAudioSession.setCategory(_:) 设置为 AVAudioSession.Category.playAndRecord  模式，此时，播放的声音(例如铃声)将被中断。应用程序不应将 AVAudioSession 设置为任何其他模式
    ///
    /// - Parameters:
    ///   - byToken: 服务器生成的token，在大多数情况下，静态app id 就足够了。为了增加安全性，使用token（静态app id，token是可选的，可以设置为nil；使用token，Agora发出一个附加的应用程序证书，让您根据算法生成一个token，并为服务器上的用户身份验证提供应用程序证书；确保用于创建 token 的 app id 与用于初始化RTC引擎的 AgoraRtcEngineKit.sharedEngine(withAppId:delegate:) 使用的 app id相同。否则，CDN直播可能会失败）
    ///   - channelId: 频道的名字。字符串的长度必须小于64字节，可用的字符如下：26个英文字母（大小写都行）；数字0-9；空格；"!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ","
    ///   - info: 有关频道的附加信息。此参数可以设置为nil或包含通道相关信息。通道中的其他用户不接收此消息
    ///   - uid: 一个32位无符号整数，其值从1到 2^32 - 1。 uid 必须是惟一的。如果没有分配 uid (或设置为0)，SDK将在 joinSuccessBlock中分配并返回一个 uid。您的应用程序必须记录并维护返回的 uid，因为SDK不这样做。
    ///   - joinSuccess: 成功加入频道的回调。同 AgoraRtcEngineDelegate.rtcEngine(_:didJoinChannel:withUid:elapsed:)
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func joinChannel(byToken: String?, channelId: String, info: String?, uid: UInt, joinSuccess: ((String, UInt, Int) -> Void)?) -> Int32 {
        let result = rtcEngineKit.joinChannel(byToken: byToken, channelId: channelId, info: info, uid: uid) { [weak self] (channel, uid2, elapsed) in
            joinSuccess?(channel, uid, elapsed)
            self?.joinChannelByTokenObserver.send(value: ((byToken, channelId, info, uid), (channelId, uid2, elapsed)))
        }
        return result
    }
    
    /// 使用用户账号加入频道
    ///
    /// 在用户成功加入频道后，SDK会触发如下回调：
    /// - 本地用户 AgoraRtcEngineDelegate.rtcEngine(_:didRegisteredLocalUser:withUid:) 和 AgoraRtcEngineDelegate.rtcEngine(_:didJoinChannel:withUid:elapsed:)
    /// - 远端用户 AgoraRtcEngineDelegate.rtcEngine(_:didJoinedOfUid:elapsed:) 和 AgoraRtcEngineDelegate.rtcEngine(_:didUpdatedUserInfo:withUid:)【在通讯配置文件和直播配置文件】
    ///
    /// **注意：** 为确保通信顺畅，请使用相同的参数类型来标识用户。例如，如果用户使用用户ID加入频道，则确保所有其他用户也使用该用户ID。这同样适用于用户帐户。如果用户使用Agora Web SDK加入频道，请确保将用户的uid设置为相同的参数类型
    /// - Parameters:
    ///   - byUserAccount: 用户账号。最大长度是256字节。确保设置了该参数，而没有将其设置为null。可用的字符如下：26个英文字母（大小写都行）；数字0-9；空格；"!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ","
    ///   - token: 服务器生成的token。（对于低安全性要求：您可以使用仪表板上生成的临时token。有关详细信息，请参见(https://docs.agora.io/en/voice/token? platform= all%20platform # Get -a- temporarytoken)；对于高安全性要求:将其设置为在服务器上生成的token。有关详细信息，请参见[Get a token](https://docs.agora.io/en/voice/token? platform= all%20platform # Get -a-token)）
    ///   - channelId: 频道的名字。字符串的长度必须小于64字节，可用的字符如下：26个英文字母（大小写都行）；数字0-9；空格；"!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ","
    ///   - joinSuccess: 成功加入频道的回调。同 AgoraRtcEngineDelegate.rtcEngine(_:didJoinChannel:withUid:elapsed:)
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func joinChannel(byUserAccount: String, token: String?, channelId: String, joinSuccess: ((String, UInt, Int) -> Void)?) -> Int32 {
        let result = rtcEngineKit.joinChannel(byUserAccount: byUserAccount, token: token, channelId: channelId) { [weak self] (channel, uid, elapsed) in
            joinSuccess?(channel, uid, elapsed)
            self?.joinChannelByAccountObserver.send(value: ((byUserAccount, token, channelId), (channelId, uid, elapsed)))
        }
        return result
    }
    
    /// 注册一个用户账号
    ///
    /// 注册后，用户帐户可用于在用户加入频道时标识本地用户。在用户成功注册用户帐户之后，SDK在本地客户机上触发 AgoraRtcEngineDelegate.rtcEngine(_:didRegisteredLocalUser:withUid:) 回调，报告本地用户的用户ID和用户帐户
    ///
    /// 为了使用用户账户加入频道，可以使用如下方式：
    /// - 调用AgoraRtcEngineKit.registerLocalUserAccount(_:appId:)创建用户账号，然后使用AgoraRtcEngineKit.joinChannel(byUserAccount:token:channelId:joinSuccess:)加入频道
    /// - 调用 AgoraRtcEngineKit.joinChannel(byUserAccount:token:channelId:joinSuccess:)加入频道
    ///
    /// 两者的区别在于前者的 AgoraRtcEngineKit.joinChannel(byUserAccount:token:channelId:joinSuccess:) 的 elapsed 比后者的短
    /// - Parameters:
    ///   - userAccount: 用户账号。最大长度是256字节。确保设置了该参数，而没有将其设置为null。可用的字符如下：26个英文字母（大小写都行）；数字0-9；空格；"!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ","
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func registerLocalUserAccount(_ userAccount: String, appId: String) -> Int32 {
        let result = rtcEngineKit.registerLocalUserAccount(userAccount, appId: appId)
        return result
    }
    
    /// 通过用户账号获取用户信息
    ///
    /// 远端用户连接频道后，SDK获取远端用户的UID和用户帐户，缓存在映射表缓存对象(“AgoraUserInfo”)中，并触发 AgoraRtcEngineDelegate.rtcEngine(_:didUpdatedUserInfo:withUid:)回调
    ///
    /// 在接收到 AgoraRtcEngineDelegate.rtcEngine(_:didUpdatedUserInfo:withUid:) 回调之后，您可以调用这个方法，通过传入用户帐户来从'userInfo'对象获取远端用户的UID
    @objc func getUserInfo(byUserAccount: String, withError: UnsafeMutablePointer<AgoraErrorCode>?) -> AgoraUserInfo? {
        let userInfo = rtcEngineKit.getUserInfo(byUserAccount: byUserAccount, withError: withError)
        return userInfo
    }
    
    /// 通过UID获取用户信息
    ///
    /// 远端用户连接频道后，SDK获取远端用户的UID和用户帐户，缓存在映射表缓存对象(“AgoraUserInfo”)中，并触发 AgoraRtcEngineDelegate.rtcEngine(_:didUpdatedUserInfo:withUid:)回调
    ///
    /// 在接收到 AgoraRtcEngineDelegate.rtcEngine(_:didUpdatedUserInfo:withUid:) 回调之后，您可以调用这个方法，通过传入UID来从'userInfo'对象获取远端用户的用户账户
    @objc func getUserInfo(byUid: UInt, withError: UnsafeMutablePointer<AgoraErrorCode>?) -> AgoraUserInfo? {
        let userInfo = rtcEngineKit.getUserInfo(byUid: byUid, withError: withError)
        return userInfo
    }
    
    /// 允许用户离开频道，例如挂起或退出呼叫
    ///
    /// 在加入通道之后，用户必须在加入另一个频道之前调用leaveChannel方法来结束调用
    ///
    /// 如果用户离开频道并释放与调用相关的所有资源，此方法将返回0
    ///
    /// 这个方法调用是异步的，当方法调用返回时，用户还没有退出频道
    ///
    /// 成功离开频道会触发如下回调：
    /// - 本地用户 AgoraRtcEngineDelegate.rtcEngine(_:didLeaveChannelWith:)
    /// - 远端用户 AgoraRtcEngineDelegate.rtcEngine(_:didOfflineOfUid:reason:)【在通讯配置文件和直播配置文件】
    ///
    /// **注意：**
    /// - 如果调用 AgoraRtcEngineKit.leaveChannel(_:) 后立即调用 AgoraRtcEngineKit.destroy， AgoraRtcEngineKit.leaveChannel(_:)会被打断，SDK不会触发 AgoraRtcEngineDelegate.rtcEngine(_:didLeaveChannelWith:)
    /// - 如果在CDN直播调用此方法，SDK会触发 AgoraRtcEngineKit.removePublishStreamUrl(_:)
    /// - 当调用此方法时，SDK默认情况下会关闭iOS上的音频会话，并可能影响其他应用程序。如果你不想要这种默认行为,使用 AgoraRtcEngineKit.setAudioSessionOperationRestriction(_:) 设置 为 AgoraAudioSessionOperationRestriction.deactivateSession，所以当你调用 AgoraRtcEngineKit.leaveChannel(_:)方法，SDK不停用音频会话
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func leaveChannel(_ leaveChannelBlock: ((AgoraChannelStats) -> Void)?) -> Int32 {
        let result = rtcEngineKit.leaveChannel { (stats) in
            leaveChannelBlock?(stats)
        }
        return result
    }
    
    /// 当前token过期后获取新token
    ///
    /// 在token模式下，过了一段时间token过期了：
    /// - 会触发 AgoraRtcEngineDelegate.rtcEngine(_:tokenPrivilegeWillExpire:) 或者
    /// - AgoraRtcEngineDelegate.rtcEngine(_:connectionChangedTo:reason:)
    ///
    /// **注意：** 推荐使用 AgoraRtcEngineDelegate.rtcEngineRequestToken(_:)，而不是 AgoraRtcEngineDelegate.rtcEngine(_:didOccurError:)
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func renewToken(_ token: String) -> Int32 {
        let result = rtcEngineKit.renewToken(token)
        return result
    }
    
    
    /// 开启与Agora Web SDK的互操作性
    ///
    /// 此方法只适用于直播配置文件。通讯配置文件下，默认是与Agora Web SDK有互操作性
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func enableWebSdkInteroperability(_ enabled: Bool) -> Int32 {
        let result = rtcEngineKit.enableWebSdkInteroperability(enabled)
        return result
    }
    
    /// 获取app的连接状态
    @objc func getConnectionState() -> AgoraConnectionStateType {
        let result = rtcEngineKit.getConnectionState()
        return result
    }
}


// MARK: - Core Audio
extension AgoraRTCEngineProxy {
    
    /// 开启音频模块
    ///
    /// 音频模块默认开启
    ///
    /// **注意：**
    /// - 这种方法影响内部引擎，可以在 AgoraRtcEngineKit.leaveChannel(_:)方法之后调用。可以在加入频道之前或之后调用此方法
    /// - 此方法重置内部引擎并需要一些时间才能生效。Agora推荐使用以下API方法分别控制音频引擎模块:
    ///     - AgoraRtcEngineKit.enableLocalAudio(_:)：是否启用麦克风创建本地音频流
    ///     - AgoraRtcEngineKit.muteLocalAudioStream(_:)：是否发布本地音频流
    ///     - AgoraRtcEngineKit.muteRemoteAudioStream(_:mute:)：是否订阅并播放远端音频流
    ///     - AgoraRtcEngineKit.muteAllRemoteAudioStreams(_:)：是否订阅并播放所有的远端音频流
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func enableAudio() -> Int32 {
        let result = rtcEngineKit.enableAudio()
        return result
    }
    
    /// 禁用音频模块
    ///
    /// **注意：**
    /// - 这种方法影响内部引擎，可以在 AgoraRtcEngineKit.leaveChannel(_:)方法之后调用。可以在加入频道之前或之后调用此方法
    /// - 此方法重置内部引擎并需要一些时间才能生效。Agora推荐使用以下API方法分别控制音频引擎模块:
    ///     - AgoraRtcEngineKit.enableLocalAudio(_:)：是否启用麦克风创建本地音频流
    ///     - AgoraRtcEngineKit.muteLocalAudioStream(_:)：是否发布本地音频流
    ///     - AgoraRtcEngineKit.muteRemoteAudioStream(_:mute:)：是否订阅并播放远端音频流
    ///     - AgoraRtcEngineKit.muteAllRemoteAudioStreams(_:)：是否订阅并播放所有的远端音频流
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func disableAudio() -> Int32 {
        let result = rtcEngineKit.disableAudio()
        return result
    }
    
    /// 设置音频参数和应用场景
    ///
    /// **注意：**
    /// - 在 AgoraRtcEngineKit.joinChannel(byToken:channelId:info:uid:joinSuccess:) 之前必须调用此方法
    /// - 在通讯配置文件下，可以设置profile，不能设置scenario
    /// - 在通讯配置文件和直播配置文件下，由于网络自适应，比特率可能与您的设置不同
    /// - 在涉及音乐教育的场景中，Agora推荐将配置文件设置为 AgoraAudioProfile.musicHighQuality 与 AgoraAudioScenario.gameStreaming
    ///
    /// - Parameters:
    ///   - profile: 设置采样速率、比特率、编码模式和通道数。查看 AgoraAudioProfile
    ///   - scenario: 设置音频应用程序场景。查看 AgoraAudioScenario。在不同的音频场景下，设备使用不同的音量轨道，即呼叫内音量或媒体音量。有关详细信息，请参见(https://docs.agora.io/en/Agora%20Platform/audio_how_to#audioscenario)
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setAudioProfile(profile: AgoraAudioProfile, scenario: AgoraAudioScenario) -> Int32 {
        let result = rtcEngineKit.setAudioProfile(profile, scenario: scenario)
        return result
    }
    
    /// 调整录音音量
    ///
    /// - Parameter volume: 录音音量。（范围是：0~4001。0：静音；100：原始音量；400：最大声，四倍的原始音量与信号剪辑保护）
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func adjustRecordingSignalVolume(_ volume: Int) -> Int32 {
        let result = rtcEngineKit.adjustRecordingSignalVolume(volume)
        return result
    }
    
    /// 调整播放音量
    ///
    /// - Parameter volume: 播放音量。（范围是：0~4001。0：静音；100：原始音量；400：最大声，四倍的原始音量与信号剪辑保护）
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func adjustPlaybackSignalVolume(_ volume: Int) -> Int32 {
        let result = rtcEngineKit.adjustPlaybackSignalVolume(volume)
        return result
    }
    
    /// 使SDK能够定期向应用程序报告说话者和说话者的音量
    ///
    /// - Parameters:
    ///   - interval: 设置两个连续音量指示之间的时间间隔（<0：禁用音量指示；>0：两个连续的音量指示之间的时间间隔(ms)。Agora建议设置 interval≥200 ms。一旦启用了这个方法，SDK返回体积指标的设置时间间隔AgoraRtcEngineDelegate.rtcEngine(_:reportAudioVolumeIndicationOfSpeakers:totalVolume:)回调，无论哪个用户在频道说话）
    ///   - smooth: 平滑因子设置音频音量指示器的灵敏度。值的范围在0到10之间。值越大，表示指标越敏感。推荐值为3
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func enableAudioVolumeIndication(_ interval: Int, smooth: Int) -> Int32 {
        let result = rtcEngineKit.enableAudioVolumeIndication(interval, smooth: smooth)
        return result
    }
    
    /// 启用/禁用本地音频捕获
    ///
    /// 当应用程序加入频道时，默认情况下启用了音频模块。此方法禁用或重新启用本地音频捕获，即停止或重启本地音频捕获和处理
    ///
    /// 一旦本地音频模块被禁用或重新启用，SDK将触发AgoraRtcEngineDelegate.rtcEngine(_:didMicrophoneEnabled:)回调
    ///
    /// **注意：**
    /// 在AgoraRtcEngineKit.joinChannel(byToken:channelId:info:uid:joinSuccess:)后调用此方法
    ///
    /// 此方法与AgoraRtcEngineKit.muteLocalAudioStream(_:)不同：
    /// - AgoraRtcEngineKit.enableLocalAudio(_:)：禁止/重启本地音频捕获和处理
    /// - AgoraRtcEngineKit.muteLocalAudioStream(_:)：发送/停止发送本地音频流
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func enableLocalAudio(_ enabled: Bool) -> Int32 {
        let result = rtcEngineKit.enableLocalAudio(enabled)
        return result
    }
    
    /// 发送/停止发送本地音频流
    ///
    /// 使用此方法停止/开始发送本地音频流。成功的调用此方法会触发远程客户端的 AgoraRtcEngineDelegate.rtcEngine(_:didAudioMuted:byUid:)回调
    ///
    /// **注意：** 当mute = true时，此方法不会禁用麦克风，因此不会影响任何正在进行的录制。
    /// - Parameter mute: 是否静音。默认false
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func muteLocalAudioStream(_ mute: Bool) -> Int32 {
        let result = rtcEngineKit.muteLocalAudioStream(mute)
        return result
    }
    
    /// 接收/停止接收指定远程用户的音频流
    ///
    /// 可以调用 AgoraRtcEngineKit.muteAllRemoteAudioStreams(_:) 设置mute = true 来静音所有远端音频流，在调用此方法前，再次调用 AgoraRtcEngineKit.muteAllRemoteAudioStreams(_:) 设置mute = false。当 AgoraRtcEngineKit.muteRemoteAudioStream(_:mute:) 设置了指定的流，AgoraRtcEngineKit.muteAllRemoteAudioStreams(_:)设置所有远端用户
    ///
    /// - Parameters:
    ///   - mute: 设置是否接收/停止接收指定远程用户的音频流。默认为false
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func muteRemoteAudioStream(_ uid: UInt, mute: Bool) -> Int32 {
        let result = rtcEngineKit.muteRemoteAudioStream(uid, mute: mute)
        return result
    }
    
    /// 接收/停止接收所有远端用户的音频流
    ///
    /// - Parameter mute: 设置是否接收/停止接收所有远端用户的音频流。默认为false
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func muteAllRemoteAudioStreams(_ mute: Bool) -> Int32 {
        let result = rtcEngineKit.muteAllRemoteAudioStreams(mute)
        return result
    }
    
    /// 默认是否接受所有的远端音频流
    ///
    /// 可以在加入频道之前或之后调用此方法。如果在加入频道后调用此方法，则不会接收随后加入的所有用户的音频流
    ///
    /// - Parameter mute: 默认是否接受所有的远端音频流。默认为false
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setDefaultMuteAllRemoteAudioStreams(_ mute: Bool) -> Int32 {
        let result = rtcEngineKit.setDefaultMuteAllRemoteAudioStreams(mute)
        return result
    }
}


// MARK: - Core Video
extension AgoraRTCEngineProxy {
    
    /// 开启视频模块
    ///
    /// 可以在进入频道之前或调用期间调用此方法。如果在进入频道之前调用此方法，服务将以视频模式启动。如果在音频调用期间调用此方法，音频模式将切换到视频模式
    ///
    /// 成功的调用此方法会在远端触发 AgoraRtcEngineDelegate.rtcEngine(_:didVideoEnabled:byUid:)
    ///
    /// **注意：**
    /// - 这种方法影响内部引擎，可以在 AgoraRtcEngineKit.leaveChannel(_:)方法之后调用
    /// - 此方法重置内部引擎并需要一些时间才能生效。Agora推荐使用以下API方法分别控制视频引擎模块:
    ///     - AgoraRtcEngineKit.enableLocalVideo(_:)：是否启用相机创建本地视频流
    ///     - AgoraRtcEngineKit.muteLocalVideoStream(_:)：是否发布本地视频流
    ///     - AgoraRtcEngineKit.muteRemoteVideoStream(_:mute:)：是否订阅并播放远端视频流
    ///     - AgoraRtcEngineKit.muteAllRemoteVideoStreams(_:)：是否订阅并播放所有的远端视频流
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func enableVideo() -> Int32 {
        let result = rtcEngineKit.enableVideo()
        return result
    }
    
    /// 禁用视频模块
    ///
    /// 可以在进入频道之前或调用期间调用此方法。如果在进入频道之前调用此方法，服务将以音频模式启动。如果在视频调用期间调用此方法，则视频模式将切换到音频模式。要启用视频模块，请调用 AgoraRtcEngineKit.enableVideo 方法
    ///
    /// 成功的调用此方法会在远端触发 AgoraRtcEngineDelegate.rtcEngine(_:didVideoEnabled:byUid:)
    ///
    /// **注意：**
    /// - 这种方法影响内部引擎，可以在 AgoraRtcEngineKit.leaveChannel(_:)方法之后调用
    /// - 此方法重置内部引擎并需要一些时间才能生效。Agora推荐使用以下API方法分别控制视频引擎模块:
    ///     - AgoraRtcEngineKit.enableLocalVideo(_:)：是否启用相机创建本地视频流
    ///     - AgoraRtcEngineKit.muteLocalVideoStream(_:)：是否发布本地视频流
    ///     - AgoraRtcEngineKit.muteRemoteVideoStream(_:mute:)：是否订阅并播放远端视频流
    ///     - AgoraRtcEngineKit.muteAllRemoteVideoStreams(_:)：是否订阅并播放所有的远端视频流
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func disableVideo() -> Int32 {
        let result = rtcEngineKit.disableVideo()
        return result
    }
    
    /// 设置视频编码配置
    ///
    /// 每个视频编码器配置对应一组视频参数，包括分辨率、帧速率、比特率和视频方向
    ///
    /// 该方法所规定的参数是理想网络条件下的最大值。如果视频引擎由于不可靠的网络条件而无法使用指定的参数呈现视频，则在找到成功的配置之前，将考虑列表下面的参数
    ///
    /// 如果在加入通道后不需要设置视频编码器配置，可以在调用enableVideo方法之前调用此方法，以减少第一个视频帧的呈现时间
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setVideoEncoderConfiguration(_ config: AgoraVideoEncoderConfiguration) -> Int32 {
        let result = rtcEngineKit.setVideoEncoderConfiguration(config)
        return result
    }
    
    /// 设置本地机器上显示的本地视图和配置视频显示
    ///
    /// app 调用此方法绑定本地视频流的每个视频窗口(视图)并配置视频显示设置。在初始化后调用此方法，以在进入频道之前配置本地视频显示设置。在用户离开频道后绑定仍然有效，这意味着窗口仍然显示。要解除绑定视图，请将AgoraRtcVideoCanvas中的 view 设置为nil
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setupLocalVideo(_ local: AgoraRtcVideoCanvas) -> Int32 {
        let result = rtcEngineKit.setupLocalVideo(local)
        return result
    }
    
    /// 设置远端视频视图
    ///
    /// 此方法将远端用户绑定到视频显示窗口(设置指定的 uid 用户的视图)
    ///
    /// 在用户加入通道之前，app 在这个方法调用中指定远程视频的 uid
    ///
    /// 如果app不知道远程 uid，请在应用程序接收到 AgoraRtcEngineDelegate.rtcEngine(_:didJoinedOfUid:elapsed:) 回调之后设置它
    ///
    /// 如果启用了视频录制功能，那么视频录制服务将作为一个虚拟客户机加入频道，从而使其他客户机也接收到AgoraRtcEngineDelegate.rtcEngine(_:didJoinedOfUid:elapsed:)回调。不要将虚拟客户端绑定到app视图，因为虚拟客户端不会发送任何视频流。如果app不识别虚拟客户机，当SDK触发 AgoraRtcEngineDelegate.rtcEngine(_:firstRemoteVideoDecodedOfUid:size:elapsed:) 回调时，将远程用户绑定到视图
    ///
    /// 要将远端用户从视图中解绑定，请将AgoraRtcVideoCanvas中的 view 设置为nil。一旦远端用户离开频道，SDK就会释放远程用户
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setupRemoteVideo(_ remote: AgoraRtcVideoCanvas) -> Int32 {
        let result = rtcEngineKit.setupRemoteVideo(remote)
        return result
    }
    
    /// 设置本地视频显示模式
    ///
    /// 在调用期间可以多次调用此方法来更改显示模式
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setLocalRenderMode(_ mode: AgoraVideoRenderMode) -> Int32 {
        let result = rtcEngineKit.setLocalRenderMode(mode)
        return result
    }
    
    /// 设置远端视频显示模式
    ///
    /// 在调用期间可以多次调用此方法来更改显示模式
    /// - Parameters:
    ///     - uid: 远端用户的UID
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setRemoteRenderMode(_ uid: UInt, _ mode: AgoraVideoRenderMode) -> Int32 {
        let result = rtcEngineKit.setRemoteRenderMode(uid, mode: mode)
        return result
    }
    
    /// 在加入频道之前启动本地视频预览
    ///
    /// 默认情况下，本地预览启用镜像模式
    ///
    /// 在调用此方法前，必须：
    /// - 调用 AgoraRtcEngineKit.setupLocalVideo(_:) 设置本地预览窗口并配置属性
    /// - 调用 AgoraRtcEngineKit.enableVideo 开启视频
    ///
    /// **注意：** 一旦调用此方法来启动本地视频预览，如果通过调用 AgoraRtcEngineKit.leaveChannel(_:) 方法离开频道，本地视频预览将一直保留，直到您调用 AgoraRtcEngineKit.stopPreview 方法来禁用它
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func startPreview() -> Int32 {
        let result = rtcEngineKit.startPreview()
        return result
    }
    
    /// 停止本地视频预览和视频
    ///
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func stopPreview() -> Int32 {
        let result = rtcEngineKit.stopPreview()
        return result
    }
    
    /// 禁用本地视频
    ///
    /// 此方法禁用本地视频，只有当用户希望观看远端视频而不向其他用户发送任何视频流时才设置 AgoraRtcEngineKit.enableLocalVideo(_:)为false
    ///
    /// 在调用 AgoraRtcEngineKit.enableVideo 方法之后调用此方法。否则，此方法可能无法正常工作
    ///
    /// 调用 AgoraRtcEngineKit.enableVideo 方法后，默认情况下启用了本地视频。可以使用此方法禁用本地视频，而远程视频不受影响。
    ///
    /// 成功的调用此方法会触发远端客户机上的 AgoraRtcEngineDelegate.rtcEngine(_:didLocalVideoEnabled:byUid:) 回调
    ///
    /// **注意：** 该方法启用内部引擎，并且可以在调用 AgoraRtcEngineKit.leaveChannel(_:) 方法后调用
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func enableLocalVideo(_ enabled: Bool) -> Int32 {
        let result = rtcEngineKit.enableLocalVideo(enabled)
        return result
    }
    
    /// 发送/停止发送本地视频流
    ///
    /// 当 mute == true 时，此方法不会禁用相机，因此不会影响检索本地视频流。与控制本地视频流发送的 AgoraRtcEngineKit.enableLocalVideo(_:) 方法相比，此方法的响应速度更快
    ///
    /// 成功的调用此方法会触发远端机的 AgoraRtcEngineDelegate.rtcEngine(_:didVideoMuted:byUid:) 回调
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func muteLocalVideoStream(_ mute: Bool) -> Int32 {
        let result = rtcEngineKit.muteLocalVideoStream(mute)
        return result
    }
    
    /// 接收/停止接收所有远端视频流
    ///
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func muteAllRemoteVideoStreams(_ mute: Bool) -> Int32 {
        let result = rtcEngineKit.muteAllRemoteVideoStreams(mute)
        return result
    }
    
    /// 接收/停止一个特定远端视频流
    ///
    /// **注意：** 如果调用 AgoraRtcEngineKit.muteAllRemoteVideoStreams(_:) 并将 mute 设为 true 以停止接收所有远端视频流。在调用该方法之前请再次调用AgoraRtcEngineKit.muteAllRemoteVideoStreams(_:) 并将 mute 设为 false
    /// - Parameters:
    ///   - uid: 特定远端用户的UID
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func muteRemoteVideoStream(_ uid: UInt, _ mute: Bool) -> Int32 {
        let result = rtcEngineKit.muteRemoteVideoStream(uid, mute: mute)
        return result
    }
    
    /// 设置是否默认接收所有远程视频流。默认false
    ///
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setDefaultMuteAllRemoteVideoStreams(_ mute: Bool) -> Int32 {
        let result = rtcEngineKit.setDefaultMuteAllRemoteVideoStreams(mute)
        return result
    }
}


// MARK: - Video Pre-Process and Post-Process
extension AgoraRTCEngineProxy {
    
    /// 启用/禁用图像增强并设置选项
    ///
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setBeautyEffectOptions(_ enable: Bool, options: AgoraBeautyOptions?) -> Int32 {
        let result = rtcEngineKit.setBeautyEffectOptions(enable, options: options)
        return result
    }
    
    @discardableResult
    @objc func enableRemoteSuperResolution(_ uid: UInt, _ enabled: Bool) -> Int32 {
        let result = rtcEngineKit.enableRemoteSuperResolution(uid, enabled: enabled)
        return result
    }
}


// MARK: - Audio Routing Controller
extension AgoraRTCEngineProxy {
    
    /// 设置默认的音频路由
    ///
    /// 此方法设置在加入频道之前，默认情况下接收的音频是路由到耳机还是扬声器。如果用户不调用此方法，则默认情况下音频将路由到耳机
    ///
    /// **主题：**
    /// - 此方法只在音频模式下有效
    /// - 在调用 AgoraRtcEngineKit.joinChannel(byToken:channelId:info:uid:joinSuccess:) 之前调用此方法
    ///
    /// 每种模式下的默认设置：
    /// - 声音：耳机
    /// - 视频：扬声器。如果用户在通讯配置文件下调用 AgoraRtcEngineKit.disableVideo 方法或如果用户调用 AgoraRtcEngineKit.muteLocalVideoStream(_:) 和 AgoraRtcEngineKit.muteAllRemoteVideoStreams(_:) 方法，默认的音频线路自动切换到耳机
    /// 现场直播：扬声器
    /// 游戏语音：扬声器
    /// - Parameter defaultToSpeaker: 设置默认的音频路由（true：扬声器；false：耳机）
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setDefaultAudioRouteToSpeakerphone(_ defaultToSpeaker: Bool) -> Int32 {
        let result = rtcEngineKit.setDefaultAudioRouteToSpeakerphone(defaultToSpeaker)
        return result
    }
    
    /// 开启/禁用音频路由到扬声器
    ///
    /// 此方法设置音频是否路由到扬声器。调用此方法后，SDK返回 AgoraRtcEngineDelegate.rtcEngine(_:didAudioRouteChanged:) 回调，指示音频路由发生更改
    ///
    /// **注意：**
    /// - 在调用 AgoraRtcEngineKit.joinChannel(byToken:channelId:info:uid:joinSuccess:) 之后调用此方法
    /// - SDK调用 AVAudioSession.setCategory(_:) 设置 AVAudioSession.Category.playAndRecord，带有配置耳机/扬声器的选项，因此此方法适用于系统中的所有音频播放
    /// - Parameter enableSpeaker: true：路由到扬声器；false：路由到耳机
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setEnableSpeakerphone(_ enableSpeaker: Bool) -> Int32 {
        let result = rtcEngineKit.setEnableSpeakerphone(enableSpeaker)
        return result
    }
    
    /// 检查扬声器是否开启
    @discardableResult
    @objc func isSpeakerphoneEnabled() -> Bool {
        let result = rtcEngineKit.isSpeakerphoneEnabled()
        return result
    }
}


// MARK: - In Ear Monitor
extension AgoraRTCEngineProxy {
    
    /// 允许耳内监听
    ///
    /// - Parameter inEarMonitoring: 默认false
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func enable(inEarMonitoring: Bool) -> Int32 {
        let result = rtcEngineKit.enable(inEarMonitoring: inEarMonitoring)
        return result
    }
    
    /// 设置耳内监听的音量
    ///
    /// - Parameter volume: 耳内音量。范围是：0~100
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setInEarMonitoringVolume(_ volume: Int) -> Int32 {
        let result = rtcEngineKit.setInEarMonitoringVolume(volume)
        return result
    }
}


// MARK: - Audio Sound Effect
extension AgoraRTCEngineProxy {
    
    /// 改变本地说话者的音高
    ///
    /// - Parameter pitch: 设置音高。范围：0.5~2.0。默认是1.0
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setLocalVoicePitch(_ pitch: Double) -> Int32 {
        let result = rtcEngineKit.setLocalVoicePitch(pitch)
        return result
    }
    
    /// 设置本地语音均衡效果
    ///
    /// - Parameters:
    ///   - bandFrequency: 设置频带频率。范围：0~9，表示声音效果的各自10波段中心频率，包括31、62、125、500、1k、2k、4k、8k和16k Hz
    ///   - withGain: 设置每个波段的增益(dB)。范围：-15~15。默认是0
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setLocalVoiceEqualizationOf(_ bandFrequency: AgoraAudioEqualizationBandFrequency, withGain: Int) -> Int32 {
        let result = rtcEngineKit.setLocalVoiceEqualizationOf(bandFrequency, withGain: withGain)
        return result
    }
    
    /// 设置本地声音混响
    ///
    ///  v2.4.0添加了 AgoraRtcEngineKit.setLocalVoiceReverbPreset(_:) 方法，这是一种更友好的方法，用于设置本地语音混响。可以使用此方法设置本地混响效果，如Popular、R&B、Rock、Hip-hop等
    /// - Parameters:
    ///   - reverbType: 设置音效类型
    ///   - withValue: 音效类型的值。查看 AgoraAudioReverbType
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setLocalVoiceReverbOf(_ reverbType: AgoraAudioReverbType, withValue: Int) -> Int32 {
        let result = rtcEngineKit.setLocalVoiceReverbOf(reverbType, withValue: withValue)
        return result
    }
    
    /// 设置本地换声器选项
    ///
    /// **注意：** 不要与 AgoraRtcEngineKit.setLocalVoiceReverbPreset(_:) 一起使用，否则前面调用的方法不生效
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setLocalVoiceChanger(_ voiceChanger: AgoraAudioVoiceChanger) -> Int32 {
        let result = rtcEngineKit.setLocalVoiceChanger(voiceChanger)
        return result
    }
    
    /// 设置预设的本地声音混响效果
    ///
    /// **注意：**
    /// - 不要与 AgoraRtcEngineKit.setLocalVoiceReverbOf(_:withValue:) 一起使用
    /// - 不要与 AgoraRtcEngineKit.setLocalVoiceChanger(_:) 一起使用，否则前面调用的方法不生效
    /// - Parameter reverbPreset: 本地声音混响选项
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setLocalVoiceReverbPreset(_ reverbPreset: AgoraAudioReverbPreset) -> Int32 {
        let result = rtcEngineKit.setLocalVoiceReverbPreset(reverbPreset)
        return result
    }
    
    /// 启用/禁用远端用户的立体平移
    ///
    /// 如果需要使用 AgoraRtcEngineKit.setRemoteVoicePosition(_:pan:gain:)，请确保在加入频道之前调用该方法，以便为远端用户启用立体平移
    /// - Parameter enabled: 是否为远程用户启用立体平移
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func enableSoundPositionIndication(_ enabled: Bool) -> Int32 {
        let result = rtcEngineKit.enableSoundPositionIndication(enabled)
        return result
    }
    
    /// 设置远端用户的声音位置和增益
    ///
    /// 当本地用户调用此方法来设置远端用户的声音位置时，左右频道之间的声音差异允许本地用户跟踪远端用户的实时位置，创建真实的空间感。此方法适用于大型多人在线游戏，如《皇室战争》游戏
    /// **注意：**
    /// - 要使此方法有效，请在加入通道之前调用 AgoraRtcEngineKit.enableSoundPositionIndication(_:)，为远程用户启用立体移动。此方法需要硬件支持
    /// - 为了获得最佳效果，我们建议使用以下音频输出设备：立体声耳机（iOS）；立体声扬声器（macOS）
    /// - Parameters:
    ///   - pan: 远端用户的声音位置。范围：-1.0~1.0（0.0：默认，远处的声音来自前方；-1.0：远处的声音来自左边；1.0：远处的声音来自右边）
    ///   - gain: 远端用户的增益。范围：0.0~100.0。默认值是100.0(远端用户的原始增益)。价值越小，收益越少
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setRemoteVoicePosition(_ uid: UInt, pan: Double, gain: Double) -> Int32 {
        let result = rtcEngineKit.setRemoteVoicePosition(uid, pan: pan, gain: gain)
        return result
    }
}


// MARK: - Music File Playback and Mixing
extension AgoraRTCEngineProxy {
    
    /// 开始音频混合
    ///
    /// 此方法将指定的本地音频文件与来自麦克风的音频流混合，或将麦克风的音频流替换为指定的本地音频文件。您可以选择其他用户是否可以听到本地音频回放，并指定回放循环的数量。该方法还支持在线音乐播放
    ///
    /// 成功的调用方法会触发本地客户机上的 AgoraRtcEngineDelegate.rtcEngine(_:localAudioMixingStateDidChanged:errorCode:) 回调
    ///
    /// 当音频混合文件回放完成时，SDK在本地客户机上触发 AgoraRtcEngineDelegate.rtcEngine(_:localAudioMixingStateDidChanged:errorCode:) 回调
    ///
    /// **注意：**
    /// - 确保iOS设备版本 >= 8.0
    /// - 确保在频道中调用此方法
    /// - 如果想要播放在线音乐文件，请确保从播放在线音乐文件到调用此方法之间的时间间隔大于100 ms，或者出现audiofileopentoofrequency(702)警告
    /// - 如果本地音频混合文件不存在，或者SDK不支持文件格式或无法访问音乐文件URL, SDK将返回AgoraWarningCodeAudioMixingOpenError(701)警告
    /// - Parameters:
    ///   - filePath: 要混合的本地或在线音频文件的绝对路径。支持的音频格式:mp3、aac、m4a、3gp和wav
    ///   - loopback: 谁可以听见混音（true：只有本地用户可以听见；false：本地和远端都可以听见）
    ///   - replace: 音频混合上下文（true：只发布指定的音频文件，麦克风接收到的音频流不发布；false：本地音频文件与来自麦克风的音频流混合）
    ///   - cycle: 播放循环次数（-1表示无限次）
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func startAudioMixing(_ filePath: String, loopback: Bool, replace: Bool, cycle: Int) -> Int32 {
        let result = rtcEngineKit.startAudioMixing(filePath, loopback: loopback, replace: replace, cycle: cycle)
        return result
    }
    
    /// 停止音频混合 (在频道内调用该方法)
    ///
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func stopAudioMixing() -> Int32 {
        let result = rtcEngineKit.stopAudioMixing()
        return result
    }
    
    /// 暂停音频混合 (在频道内调用该方法)
    ///
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func pauseAudioMixing() -> Int32 {
        let result = rtcEngineKit.pauseAudioMixing()
        return result
    }
    
    /// 恢复音频混合 (在频道内调用该方法)
    ///
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func resumeAudioMixing() -> Int32 {
        let result = rtcEngineKit.resumeAudioMixing()
        return result
    }
    
    /// 调节音频混合音量 (在频道内调用该方法)
    ///
    /// - Parameter volume: 音频混合音量。范围：0~100，默认100
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func adjustAudioMixingVolume(_ volume: Int) -> Int32 {
        let result = rtcEngineKit.adjustAudioMixingVolume(volume)
        return result
    }
    
    /// 调整本地播放的音频混合音量 (在频道内调用该方法)
    ///
    /// - Parameter volume: 音频混合音量。范围：0~100，默认100
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func adjustAudioMixingPlayoutVolume(_ volume: Int) -> Int32 {
        let result = rtcEngineKit.adjustAudioMixingPlayoutVolume(volume)
        return result
    }
    
    /// 调整要发布的（发送给其他人的）音频混合音量 (在频道内调用该方法)
    ///
    /// - Parameter volume: 音频混合音量。范围：0~100，默认100
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func adjustAudioMixingPublishVolume(_ volume: Int) -> Int32 {
        let result = rtcEngineKit.adjustAudioMixingPublishVolume(volume)
        return result
    }
    
    /// 获取用于发布的音频混合音量
    ///
    /// 此方法有助于排除音频音量相关问题
    @discardableResult
    @objc func getAudioMixingPublishVolume() -> Int32 {
        let result = rtcEngineKit.getAudioMixingPublishVolume()
        return result
    }
    
    /// 获取用于本地播放的音频混合音量
    ///
    /// 此方法有助于排除音频音量相关问题
    @discardableResult
    @objc func getAudioMixingPlayoutVolume() -> Int32 {
        let result = rtcEngineKit.getAudioMixingPlayoutVolume()
        return result
    }
    
    /// 获取音频混合的时间（ms） (在频道内调用该方法)
    ///
    /// - Returns: > 0：音频混合时间；< 0：失败
    @discardableResult
    @objc func getAudioMixingDuration() -> Int32 {
        let result = rtcEngineKit.getAudioMixingDuration()
        return result
    }
    
    /// 获取音频混合文件的播放位置 (在频道内调用该方法)
    ///
    /// - Returns: > 0：音频混合文件当前的播放位置；< 0：失败
    @discardableResult
    @objc func getAudioMixingCurrentPosition() -> Int32 {
        let result = rtcEngineKit.getAudioMixingCurrentPosition()
        return result
    }
    
    /// 将音频混合文件的播放位置设置为不同的起始位置(默认从开始播放)
    ///
    /// - Parameter pos: 音频混合文件的播放位置（ms）
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setAudioMixingPosition(_ pos: Int) -> Int32 {
        let result = rtcEngineKit.setAudioMixingPosition(pos)
        return result
    }
}


// MARK: - Audio Effect File Playback
extension AgoraRTCEngineProxy {
    
    /// 获取音效的音量（范围：0~100）
    ///
    /// - Returns: > 0：音效的音量；< 0：失败
    @discardableResult
    @objc func getEffectsVolume() -> Double {
        let result = rtcEngineKit.getEffectsVolume()
        return result
    }
    
    /// 设置音效音量
    ///
    /// - Parameter volume: 音效音量。范围：0~100，默认100
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setEffectsVolume(_ volume: Double) -> Int32 {
        let result = rtcEngineKit.setEffectsVolume(volume)
        return result
    }
    
    /// 设置指定的音效的音量
    ///
    /// - Parameters:
    ///     - soundId: 音效ID
    ///     - withVolume: 音效音量。范围：0~100，默认100
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setEffectsVolume(_ soundId: Int32, withVolume: Double) -> Int32 {
        let result = rtcEngineKit.setVolumeOfEffect(soundId, withVolume: withVolume)
        return result
    }
    
    /// 播放指定的音效
    ///
    /// 可以使用此方法为特定场景(例如游戏)添加特定的音效
    ///
    /// 使用此方法，您可以设置音效文件的循环计数、音高、平移和增益，以及远程用户是否能够听到音效
    ///
    /// 要同时播放多个音效文件，请使用不同的声音和文件路径多次调用此方法。我们建议同时播放不超过三个音效文件
    ///
    /// 当音频效果文件回放完成时，会触发 AgoraRtcEngineDelegate.rtcEngineDidAudioEffectFinish(_:soundId:)
    ///
    /// - Parameters:
    ///   - soundId: 音效ID，每个音效都有唯一ID。（如果通过 AgoraRtcEngineKit.preloadEffect(_:filePath:) 预加载了音效文件到内存，确保soundId是唯一的）
    ///   - filePath: 本地音效文件的绝对路径或在线音频效果文件的URL
    ///   - loopCount: 循环次数（0：一次；1：两次；-1：一直播放，直到调用 AgoraRtcEngineKit.stopEffect(_:) 或 AgoraRtcEngineKit.stopAllEffects）
    ///   - pitch: 音效的音高。范围：0.5~2。默认是1
    ///   - pan: 音效空间位置。范围：-1.0~1.0（0.0：音效显示在前面；-1.0：音效显示在左边；1.0：音效显示在右边）
    ///   - gain: 音效的音量。范围：0~100。默认100.
    ///   - publish: 是否发布给Agora Cloud和远端用户
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func playEffect(_ soundId: Int32, filePath: String?, loopCount: Int32, pitch: Double, pan: Double, gain: Double, publish: Bool) -> Int32 {
        let result = rtcEngineKit.playEffect(soundId, filePath: filePath, loopCount: loopCount, pitch: pitch, pan: pan, gain: gain, publish: publish)
        return result
    }
    
    /// 停止播放指定的音效
    ///
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func stopEffect(_ soundId: Int32) -> Int32 {
        let result = rtcEngineKit.stopEffect(soundId)
        return result
    }
    
    /// 停止播放所有的音效
    ///
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func stopAllEffects() -> Int32 {
        let result = rtcEngineKit.stopAllEffects()
        return result
    }
    
    /// 预加载一个指定的音效文件到内存
    ///
    /// 为了保证顺畅的通讯，限制音频效果文件的大小。Agora建议在调用 AgoraRtcEngineKit.joinChannel(byToken:channelId:info:uid:joinSuccess:) 之前使用此方法预加载音效
    ///
    /// 支持的音频格式:mp3、aac、m4a、3gp和wav。
    ///
    /// - Parameters:
    ///   - soundId: 音效ID
    ///   - filePath: 音效文件的绝对路径
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func stopAllEffects(_ soundId: Int32, filePath: String?) -> Int32 {
        let result = rtcEngineKit.preloadEffect(soundId, filePath: filePath)
        return result
    }
    
    /// 从内存中释放一个指定的音效
    ///
    /// - Parameter soundId: 音效ID
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func unloadEffect(_ soundId: Int32) -> Int32 {
        let result = rtcEngineKit.unloadEffect(soundId)
        return result
    }
    
    /// 暂停一个指定的音效
    ///
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func pauseEffect(_ soundId: Int32) -> Int32 {
        let result = rtcEngineKit.pauseEffect(soundId)
        return result
    }
    
    /// 暂停所有的音效
    ///
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func pauseAllEffects() -> Int32 {
        let result = rtcEngineKit.pauseAllEffects()
        return result
    }
    
    /// 恢复一个指定的音效
    ///
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func resumeEffect(_ soundId: Int32) -> Int32 {
        let result = rtcEngineKit.resumeEffect(soundId)
        return result
    }
    
    /// 恢复所有的音效
    ///
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func resumeAllEffects() -> Int32 {
        let result = rtcEngineKit.resumeAllEffects()
        return result
    }
}


// MARK: - Audio Recorder
extension AgoraRTCEngineProxy {
    
    /// 开始音频录制
    ///
    /// SDK允许在调用期间进行录制。支持格式：wav 文件大，保真度高；aac：文件小，保真度低
    ///
    /// 确保保存录制文件的目录存在并且是可写的。在 AgoraRtcEngineKit.joinChannel(byToken:channelId:info:uid:joinSuccess:) 之后调用此方法。当调用 AgoraRtcEngineKit.leaveChannel(_:) 时，录制将自动停止
    /// - Parameters:
    ///   - filePath: 录制文件的绝对文件路径
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func startAudioRecording(filePath: String, quality: AgoraAudioRecordingQuality) -> Int32 {
        let result = rtcEngineKit.startAudioRecording(filePath, quality: quality)
        return result
    }
    
    /// 停止客户端的音频录制
    ///
    /// **注意：** 可以在调用 AgoraRtcEngineKit.leaveChannel(_:) 方法之前调用此方法，否则在调用 AgoraRtcEngineKit.leaveChannel(_:) 方法时录制将自动停止
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func stopAudioRecording() -> Int32 {
        
        let result = rtcEngineKit.stopAudioRecording()
        return result
    }
}


// MARK: - Miscellaneous Audio Control
extension AgoraRTCEngineProxy {
    
    /// 设置音频会话的操作限制
    ///
    /// SDK和app都可以默认配置音频会话。该app可能偶尔会使用其他应用程序或第三方组件来操纵音频会话，并限制SDK这样做。该方法允许应用程序限制SDK对音频会话的操作
    ///
    /// 可以随时调用此方法将音频会话的控制权返回给SDK
    ///
    /// **注意：** 这种方法限制了SDK对音频会话的操作。音频会话的任何操作都完全依赖于应用程序、其他应用程序或第三方组件
    /// - Parameter restriction: 音频会话的操作限制
    @objc func setAudioSessionOperationRestriction(_ restriction: AgoraAudioSessionOperationRestriction) {
        rtcEngineKit.setAudioSessionOperationRestriction(restriction)
    }
}


// MARK: - Network-related Test
extension AgoraRTCEngineProxy {
    
    /// 开始语音通话回路测试
    ///
    /// 此方法启动音频通话回路测试，以确定音频设备(例如耳机和扬声器)和网络连接是否正常工作
    ///
    /// 在音频通话回路测试中，你记录你的声音。如果录音在设定的时间间隔内回放，则音频设备和网络连接正常工作
    /// ** 注意：**
    /// - 在加入通道之前调用此方法。
    /// - 调用此方法后，调用 AgoraRtcEngineKit.stopEchoTest 方法结束测试。否则app无法运行下一个echo测试，或加入频道
    /// - 在直播配置文件中，只有主机可以调用此方法
    /// - Parameters:
    ///   - withInterval: 说话和录音回放之间的时间间隔
    ///   - successBlock: 成功回调
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func startEchoTest(withInterval: Int, successBlock: ((String, UInt, Int) -> Void)?) -> Int32 {
        let result = rtcEngineKit.startEchoTest(withInterval: withInterval) { (channel, uid, elapsed) in
            successBlock?(channel, uid, elapsed)
        }
        return result
    }
    
    /// 停止音频通话回路测试
    ///
    /// - Returns: 成功：0；失败：< 0
    @objc func stopEchoTest() -> Int32 {
        let result = rtcEngineKit.stopEchoTest()
        return result
    }
    
    /// 开启网络连接质量测试
    ///
    /// 此方法测试用户网络连接的质量，默认情况下禁用
    ///
    /// 在用户加入频道或观众切换到主机之前，调用此方法检查上行网络质量
    ///
    /// 此方法消耗额外的网络流量，可能会影响通信质量。我们不建议与 AgoraRtcEngineKit.startLastmileProbeTest(_:) 一起调用此方法。
    ///
    /// 在接收到 AgoraRtcEngineDelegate.rtcEngine(_:lastmileQuality:) 回调之后，以及在用户加入通道或切换用户角色之前，调用 AgoraRtcEngineKit.disableLastmileTest 方法来禁用此测试
    /// **注意：**
    /// - 在收到 AgoraRtcEngineDelegate.rtcEngine(_:lastmileQuality:) 回调之前，不要调用任何其他方法。此外，此回调可能会被其他方法打断或不执行
    /// - 在直播配置文件下，主机在加入频道后不应该调用此方法
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func enableLastmileTest() -> Int32 {
        let result = rtcEngineKit.enableLastmileTest()
        return result
    }
    
    /// 禁用网络连接质量测试
    ///
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func disableLastmileTest() -> Int32 {
        let result = rtcEngineKit.disableLastmileTest()
        return result
    }
    
    /// 开始最后一英里网络探测测试
    ///
    /// 在加入频道之前开始最后一英里网络探测测试，以获得上行和下行最后一英里网络统计数据，包括带宽、包丢失、抖动和往返时间(RTT)
    ///
    /// 在用户加入频道或观众切换到主机之前，调用此方法检查上行网络质量
    ///
    /// 启用此方法后，SDK将返回以下回调：
    /// - AgoraRtcEngineDelegate.rtcEngine(_:lastmileQuality:)：SDK根据网络条件在两秒内触发这个回调。这种回调对网络条件进行评级，并与用户体验更紧密地联系在一起
    /// - AgoraRtcEngineDelegate.rtcEngine(_:lastmileProbeTest:)：SDK根据网络条件在30秒内触发这个回调。这个回调函数返回网络状态的实时统计信息，更加客观
    /// - Parameter config: 最后一英里网络探测测试的配置
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func startLastmileProbeTest(_ config: AgoraLastmileProbeConfig?) -> Int32 {
        let result = rtcEngineKit.startLastmileProbeTest(config)
        return result
    }
    
    /// 停止最后一英里网络探测测试
    ///
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func stopLastmileProbeTest() -> Int32 {
        let result = rtcEngineKit.stopLastmileProbeTest()
        return result
    }
}


// MARK: - Custom Video Module
extension AgoraRTCEngineProxy {
    
    /// 设置视频源
    ///
    /// 在实时通信中，SDK使用默认的视频输入源(内置摄像头)发布流。要使用外部视频源，请调用AgoraVideoSourceProtocol来设置自定义视频源，然后使用此方法将外部视频源添加到SDK中
    @objc func setVideoSource(_ videoSource: AgoraVideoSourceProtocol?) {
        rtcEngineKit.setVideoSource(videoSource)
    }
    
    
    /// 设置本地视频渲染器
    ///
    /// 在实时通信中，SDK使用默认的视频渲染器来渲染视频。要使用外部视频渲染器，请调用AgoraVideoSinkProtocol来设置自定义本地视频渲染器，然后使用此方法将外部渲染器添加到SDK中
    @objc func setLocalVideoRenderer(_ videoRenderer: AgoraVideoSinkProtocol?) {
        rtcEngineKit.setLocalVideoRenderer(videoRenderer)
    }
    
    /// 设置远端视频渲染器
    /// 此方法设置远端视频渲染器。在实时通信中，SDK使用默认的视频渲染器来渲染视频。要使用外部视频渲染器，请调用AgoraVideoSinkProtocol来设置自定义远程视频渲染器，然后使用此方法将外部渲染器添加到SDK中
    @objc func setRemoteVideoRenderer(_ videoRenderer: AgoraVideoSinkProtocol?, forUserId: UInt) {
        rtcEngineKit.setRemoteVideoRenderer(videoRenderer, forUserId: forUserId)
    }
    
    /// 获取视频源
    @objc func videoSource() -> AgoraVideoSourceProtocol? {
        return rtcEngineKit.videoSource()
    }
    
    /// 获取本地视频渲染器
    @objc func localVideoRenderer() -> AgoraVideoSinkProtocol? {
        return rtcEngineKit.localVideoRenderer()
    }
    
    /// 获取指定远端用户的视频源
    @objc func remoteVideoRenderer(ofUserId: UInt) -> AgoraVideoSinkProtocol? {
        return rtcEngineKit.remoteVideoRenderer(ofUserId: ofUserId)
    }
}


// MARK: - External Audio Data
extension AgoraRTCEngineProxy {
    
    /// 开启外部音频源 （在加入频道前调用）
    ///
    /// - Parameters:
    ///   - withSampleRate: 外部音频源的采样率:8000、16000、44100或48000 Hz
    ///   - channelsPerFrame: 外部声源信道的数量（最多两个信道）
    @objc func enableExternalAudioSource(withSampleRate: UInt, channelsPerFrame: UInt) {
        rtcEngineKit.enableExternalAudioSource(withSampleRate: withSampleRate, channelsPerFrame: channelsPerFrame)
    }
    
    /// 禁用外部音频源
    @objc func disableExternalAudioSource() {
        rtcEngineKit.disableExternalAudioSource()
    }
    
    /// 将外部原始音频帧数据推送到SDK进行编码
    ///
    /// - Parameters:
    ///   - data: 外部音频数据
    ///   - samples: 样本数
    ///   - timestamp: 外部音频帧的时间戳。它是强制性的。您可以将此参数用于以下目的：恢复所捕获音频帧的顺序；同步视频相关场景中的音频和视频帧，包括使用外部视频源的场景
    @discardableResult
    @objc func pushExternalAudioFrameRawData(_ data: UnsafeMutableRawPointer, samples: UInt, timestamp: TimeInterval) -> Bool {
        let result = rtcEngineKit.pushExternalAudioFrameRawData(data, samples: samples, timestamp: timestamp)
        return result
    }
    
    /// 将外部CMSampleBuffer音频帧推送到SDK进行编码
    ///
    /// - Parameter sampleBuffer: 样本缓冲区
    @discardableResult
    @objc func pushExternalAudioFrameSampleBuffer(_ sampleBuffer: CMSampleBuffer) -> Bool {
        let result = rtcEngineKit.pushExternalAudioFrameSampleBuffer(sampleBuffer)
        return result
    }
}


// MARK: - External Video Data
extension AgoraRTCEngineProxy {
    
    /// 配置外部视频源
    ///
    /// 如果使用外部视频源，请在 AgoraRtcEngineKit.enableVideo 或 AgoraRtcEngineKit.startPreview 方法之前调用此方法
    /// - Parameters:
    ///   - enable: 是否使用外部视频源。默认false
    ///   - useTexture: 是否使用 texture 作为输入
    ///   - pushMode: 目前只能使用true。外部视频源是否需要调用 AgoraRtcEngineKit.pushExternalVideoFrame(_:) 发送视频帧到SDK
    @objc func setExternalVideoSource(_ enable: Bool, useTexture: Bool, pushMode: Bool) {
        rtcEngineKit.setExternalVideoSource(enable, useTexture: useTexture, pushMode: pushMode)
    }
    
    /// 推送外部视频帧
    ///
    /// 该方法使用AgoraVideoFrame类推送视频帧，并使用 format 参数将视频帧传递给SDK。调用 AgoraRtcEngineKit.setExternalVideoSource(_:useTexture:pushMode:) 方法，并将 pushMode 设置为 true。否则，调用此方法后将返回失败
    ///
    /// **注意：** 在通信配置文件下，此方法不支持推送 texture 视频帧
    /// - Parameter frame: 包含SDK要推送的编码视频数据的视频帧
    @discardableResult
    @objc func pushExternalVideoFrame(_ frame: AgoraVideoFrame) -> Bool {
        let result = rtcEngineKit.pushExternalVideoFrame(frame)
        return result
    }
}


// MARK: - Raw Audio Data
extension AgoraRTCEngineProxy {
    
    /// 设置 onRecordAudioFrame 回调的音频录制格式
    ///
    /// - Parameters:
    ///   - sampleRate: 音频采样率（由 onRecordAudioFrame 回调返回）。可以为8000, 16000, 32000, 44100, or 48000 Hz
    ///   - channel: 音频频道号（由 onRecordAudioFrame 回调返回）。可以是1（Mono）2（Stereo）
    ///   - mode: AgoraAudioRawFrameOperationMode
    ///   - samplesPerCall: 样本点（由 onRecordAudioFrame 回调返回）。通常设置发布流的 samplesPerCall 为1024。samplesPerCall = (int)(sampleRate × sampleInterval)。sampleInterval >= 0.01s
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setRecordingAudioFrameParametersWithSampleRate(_ sampleRate: Int, channel: Int, mode: AgoraAudioRawFrameOperationMode, samplesPerCall: Int) -> Int32 {
        let result = rtcEngineKit.setRecordingAudioFrameParametersWithSampleRate(sampleRate, channel: channel, mode: mode, samplesPerCall: samplesPerCall)
        return result
    }
    
    /// 设置 onPlaybackAudioFrame 回调的音频播放格式
    ///
    /// - Parameters:
    ///   - sampleRate: 音频采样率（由 onPlaybackAudioFrame 回调返回）。可以为8000, 16000, 32000, 44100, or 48000 Hz
    ///   - channel: 音频频道号（由 onPlaybackAudioFrame 回调返回）。可以是1（Mono）2（Stereo）
    ///   - mode: AgoraAudioRawFrameOperationMode
    ///   - samplesPerCall: 样本点（由 onPlaybackAudioFrame 回调返回）。通常设置发布流的 samplesPerCall 为1024。samplesPerCall = (int)(sampleRate × sampleInterval)。sampleInterval >= 0.01s
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setPlaybackAudioFrameParametersWithSampleRate(_ sampleRate: Int, channel: Int, mode: AgoraAudioRawFrameOperationMode, samplesPerCall: Int) -> Int32 {
        let result = rtcEngineKit.setPlaybackAudioFrameParametersWithSampleRate(sampleRate, channel: channel, mode: mode, samplesPerCall: samplesPerCall)
        return result
    }
    
    /// 设置 onMixedAudioFrame 回调的混合音频格式
    ///
    /// - Parameters:
    ///   - sampleRate: 音频采样率（由 onMixedAudioFrame 回调返回）。可以为8000, 16000, 32000, 44100, or 48000 Hz
    ///   - samplesPerCall: 样本点（由 onMixedAudioFrame 回调返回）。通常设置发布流的 samplesPerCall 为1024。samplesPerCall = (int)(sampleRate × sampleInterval)。sampleInterval >= 0.01s
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setMixedAudioFrameParametersWithSampleRate(_ sampleRate: Int, samplesPerCall: Int) -> Int32 {
        let result = rtcEngineKit.setMixedAudioFrameParametersWithSampleRate(sampleRate, samplesPerCall: samplesPerCall)
        return result
    }
}


// MARK: - Watermark
extension AgoraRTCEngineProxy {
    
    /// 向本地视频或CDN实时流添加水印图像
    ///
    /// 该方法将PNG水印添加到本地视频流中，以供记录设备、通道观众或CDN现场观众查看和捕获
    ///
    /// 要将PNG文件仅添加到CDN实时发布流，请参见 AgoraRtcEngineKit.setLiveTranscoding(_:) 方法
    ///
    /// **注意：**
    /// - 本地视频和CDN直播流的URL描述不同：
    ///     - 在本地视频流中，AgoraImage中的 url 指的是在本地视频流中添加的水印图像文件的绝对路径
    ///     - 在CDN直播流中，AgoraImage中的 url 是指在CDN直播中添加水印图像的url地址
    /// - 水印图像的源文件必须是PNG文件格式。如果PNG文件的宽度和高度与在此方法中的设置不同，则会裁剪PNG文件以符合设置
    /// - SDK只支持在本地视频或CDN直播流中添加一个水印图像。新添加的水印图像替代了原来的水印图像
    /// - 如果在 AgoraRtcEngineKit.setVideoEncoderConfiguration(_:) 方法中将 orientationMode 设置为 Adaptive，水印图像将随着视频帧旋转，并围绕水印图像的左上角旋转
    /// - Parameter watermark: AgoraImage
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func addVideoWatermark(_ watermark: AgoraImage) -> Int32 {
        let result = rtcEngineKit.addVideoWatermark(watermark)
        return result
    }
    
    /// 移除 AgoraRtcEngineKit.addVideoWatermark(_:) 添加的水印
    ///
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func clearVideoWatermarks() -> Int32 {
        let result = rtcEngineKit.clearVideoWatermarks()
        return result
    }
}


// MARK: - Stream Fallback
extension AgoraRTCEngineProxy {
    
    /// 设置远端用户流的优先级
    ///
    /// 将此方法与 AgoraRtcEngineKit.setRemoteSubscribeFallbackOption(_:) 方法一起使用。如果给远端流启用了回退函数，SDK将确保高优先级用户获得尽可能好的流质
    ///
    /// **注意：** SDK支持仅为一个用户将userPriority设置为高
    /// - Parameters:
    ///   - uid: 远端用户的UID
    ///   - userPriority: 用户优先级
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setRemoteUserPriority(_ uid: UInt, type: AgoraUserPriority) -> Int32 {
        let result = rtcEngineKit.setRemoteUserPriority(uid, type: type)
        return result
    }
    
    
    /// 根据网络条件为本地发布的视频流设置回退选项
    ///
    /// option 的默认设置是 AgoraStreamFallbackOptions.disabled，当上行网络条件不可靠时，本地发布的视流没有回退行为
    ///
    /// 如果设置为 AgoraStreamFallbackOptions.audioOnly，SDK将：
    /// - 当在网络条件恶化且不能同时支持视频和音频时才启用音频，禁用上游视频
    /// - 当网络状况改善时，重新启用视频
    ///
    /// 当发布的视源流返回到audio-only或当audio-only流切换回视频时，SDK触发 AgoraRtcEngineDelegate.rtcEngine(_:didLocalPublishFallbackToAudioOnly:) 回调
    ///
    /// **注意：** Agora不推荐在CDN实时流媒体中使用此方法，因为当发布的视频流返回到audio-only时，远程CDN实时用户会有明显的延迟
    /// - Parameter option: 默认 AgoraStreamFallbackOptions.disabled
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setLocalPublishFallbackOption(_ option: AgoraStreamFallbackOptions) -> Int32 {
        let result = rtcEngineKit.setLocalPublishFallbackOption(option)
        return result
    }
    
    /// 根据网络条件为远程订阅的视频流设置回退选项
    ///
    /// option 的默认设置是 AgoraStreamFallbackOptions.videoStreamLow，在不可靠的下行网络条件下，远端订阅的视频流回落到低流(低分辨率和低比特率)视频
    ///
    /// 如果将 option 设置为 AgoraStreamFallbackOptions.audioOnly，当下行网络条件不能同时支持音频和视频时，SDK会自动将视频从高流量切换到低流量，禁用视频，以保证音频的质量。SDK监控网络质量，并在网络条件改善时重新启用视频流
    ///
    /// 当订阅的远端视源流返回到audio-only或当audio-only流切换回视频时，SDK触发 AgoraRtcEngineDelegate.rtcEngine(_:didRemoteSubscribeFallbackToAudioOnly:byUid:) 回调
    /// - Parameter option: 默认 AgoraStreamFallbackOptions.videoStreamLow
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setRemoteSubscribeFallbackOption(_ option: AgoraStreamFallbackOptions) -> Int32 {
        let result = rtcEngineKit.setRemoteSubscribeFallbackOption(option)
        return result
    }
}


// MARK: - Dual-stream Mode
extension AgoraRTCEngineProxy {
    
    /// 启用/禁用dual-stream模式（直播）
    ///
    /// 如果启用双流模式，接收端可以选择接收高流(高分辨率高比特率)或低流(低分辨率低比特率)视频
    /// - Parameter enabled: 默认false
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func enableDualStreamMode(_ enabled: Bool) -> Int32 {
        let result = rtcEngineKit.enableDualStreamMode(enabled)
        return result
    }
    
    /// 远端用户发送双流时设置本地用户接收的远端用户的视频流类型
    ///
    /// 此方法允许app根据视频窗口的大小来调整相应的视频流类型，从而减少带宽和资源
    ///
    /// - 如果远端用户通过调用 AgoraRtcEngineKit.enableDualStreamMode(_:) 方法启用双流模式，SDK默认接收高流视频。您可以使用此方法切换到低流视频
    /// - 如果不启用双流模式，SDK默认接收高流量视频
    ///
    /// 方法结果在 AgoraRtcEngineDelegate.rtcEngine(_:didApiCallExecute:api:result:)返回。SDK默认接收高流量视频，节省带宽。如果需要，用户可以使用这种方法切换到低流量视频
    ///
    /// 默认情况下，低流视频的纵横比与高流视频相同。一旦设置了高流量视频的分辨率，系统就会自动设置低流量视频的分辨率、帧速率和比特率
    /// - Parameters:
    ///   - uid: 发送视频流的远端用户ID
    ///   - type: AgoraVideoStreamType
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setRemoteVideoStream(_ uid: UInt, type: AgoraVideoStreamType) -> Int32 {
        let result = rtcEngineKit.setRemoteVideoStream(uid, type: type)
        return result
    }
    
    /// 远端用户发送双流时设置本地用户接收的视频的默认视频流类型
    ///
    /// - Parameter streamType: AgoraVideoStreamType
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setRemoteDefaultVideoStreamType(_ streamType: AgoraVideoStreamType) -> Int32 {
        let result = rtcEngineKit.setRemoteDefaultVideoStreamType(streamType)
        return result
    }
}


// MARK: - Encryption
extension AgoraRTCEngineProxy {
    
    /// 在加入频道之前启用内置加密密码
    ///
    /// 频道中的所有用户必须设置相同的加密密码。一旦用户离开通道，加密密码将自动清除
    ///
    /// 如果加密密码未指定或设置为空，则禁用加密功能
    ///
    /// **注意：**
    /// - 不要在CDN直播中使用此方法
    /// - 为达到最佳传输效果，请确保加密后的数据大小不超过原始数据大小 + 16字节。16字节是AES加密的最大填充大小
    /// - Parameter secret: 加密密码
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setEncryptionSecret(_ secret: String?) -> Int32 {
        let result = rtcEngineKit.setEncryptionSecret(secret)
        return result
    }
    
    /// 设置内置加密模式
    ///
    /// SDK支持内置加密，默认设置为 "aes-128-xts"。调用此方法以使用其他加密模式
    ///
    /// 同一通道中的所有用户必须使用相同的加密模式和密码
    ///
    /// 有关AES加密算法的信息，请参阅加密模式之间的差异
    ///
    /// **注意：**
    /// - 在调用该方法之前，调用 AgoraRtcEngineKit.setEncryptionSecret(_:) 方法启用内置加密函数
    /// - 不要在CDN直播中使用此方法
    ///
    /// - Parameter mode: 加密模式（"aes-128-xts": (default) 128-bit AES encryption, XTS mode；"aes-256-xts": 256-bit AES encryption, XTS mode；"aes-128-ecb": 128-bit AES encryption, ECB mode）
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setEncryptionMode(_ mode: String?) -> Int32 {
        let result = rtcEngineKit.setEncryptionMode(mode)
        return result
    }
}


// MARK: - Inject an Online Media Stream
extension AgoraRTCEngineProxy {
    
    /// 将语音或视频流RTMP URL地址添加到直播
    ///
    /// AgoraRtcEngineDelegate.rtcEngine(_:streamPublishedWithUrl:errorCode:) 会返回注入流的状态
    ///
    /// 如果此方法调用成功，服务器将提取语音或视频流并将其注入到一个实时频道中。这适用于频道中所有观众都可以观看现场表演并相互互动的场景
    ///
    /// 此方法会触发：
    /// - 本地用户
    ///     - AgoraRtcEngineDelegate.rtcEngine(_:streamInjectedStatusOfUrl:uid:status:)
    ///     - 如果此方法调用成功并且在线媒体流注入到了频道中时，AgoraRtcEngineDelegate.rtcEngine(_:didJoinedOfUid:elapsed:) 【uid:666】
    /// - 远端用户
    ///     - 如果此方法调用成功并且在线媒体流注入到了频道中时，AgoraRtcEngineDelegate.rtcEngine(_:didJoinedOfUid:elapsed:) 【uid:666】
    ///
    /// **注意：** 在调用此方法之前，联系 sales@agora.io 启用CDN流函数
    /// - Parameters:
    ///   - url: 要添加的URL。有效的协议是RTMP、HLS、FLV（支持的flv 音频编码类型：aac；支持的flv 视频编码类型：h264(avc)）
    ///   - config: AgoraLiveInjectStreamConfig
    /// - Returns: 成功：0；失败：< 0 （AgoraErrorCodeInvalidArgument，AgoraErrorCodeNotReady，AgoraErrorCodeNotSupported，AgoraErrorCodeNotInitialized）
    @discardableResult
    @objc func addInjectStreamUrl(_ url: String, config: AgoraLiveInjectStreamConfig) -> Int32 {
        let result = rtcEngineKit.addInjectStreamUrl(url, config: config)
        return result
    }
    
    
    /// 移除直播中的声音或视频流 RTMP URL
    ///
    /// 成功的调用此方法会触发 AgoraRtcEngineDelegate.rtcEngine(_:didJoinedOfUid:elapsed:) 【uid:666】
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func removeInjectStreamUrl(_ url: String) -> Int32 {
        let result = rtcEngineKit.removeInjectStreamUrl(url)
        return result
    }
}


// MARK: - CDN Live Streaming
extension AgoraRTCEngineProxy {
    
    /// 发布本地流到CDN
    ///
    /// 此方法会在本地触发 AgoraRtcEngineDelegate.rtcEngine(_:rtmpStreamingChangedToState:state:errorCode:) 报告添加本地流到CDN的状态
    ///
    /// **注意：**
    /// - 此方法只适用于直播配置文件
    /// - 确保用户在调用此方法之前加入频道
    /// - 此方法每次调用只添加一个URL
    /// - url必须不包含特殊字符，例如中文字符
    /// - Parameters:
    ///   - url: RTMP格式的CDN流URL。最大长度1024字节
    ///   - transcodingEnabled: 是否开启双流
    /// - Returns: 成功：0；失败：< 0 （AgoraErrorCodeInvalidArgument，AgoraErrorCodeNotInitialized）
    @discardableResult
    @objc func addPublishStreamUrl(_ url: String, transcodingEnabled: Bool) -> Int32 {
        let result = rtcEngineKit.addPublishStreamUrl(url, transcodingEnabled: transcodingEnabled)
        return result
    }
    
    /// 移除CDN中的RTMP流
    ///
    /// 此方法会在本地触发 AgoraRtcEngineDelegate.rtcEngine(_:rtmpStreamingChangedToState:state:errorCode:) 报告从CDN移除RTMP本地流的状态
    ///
    /// **注意：**
    /// - 此方法只适用于直播配置文件
    /// - 此方法每次调用只移除一个URL
    /// - url必须不包含特殊字符，例如中文字符
    /// - Parameter url: RTMP格式的CDN流URL。最大长度1024字节
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func removePublishStreamUrl(_ url: String) -> Int32 {
        let result = rtcEngineKit.removePublishStreamUrl(url)
        return result
    }
    
    /// 设置视频布局和CDN直播的音频设置（只适用于CDN直播）
    ///
    /// **注意：** 此方法只适用于直播配置文件
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setLiveTranscoding(_ transcoding: AgoraLiveTranscoding?) -> Int32 {
        let result = rtcEngineKit.setLiveTranscoding(transcoding)
        return result
    }
}


// MARK: - Data Stream
extension AgoraRTCEngineProxy {
    
    /// 创建数据流。
    ///
    /// 每个用户最多可以同时拥有五个数据通道
    ///
    /// **注意：** 同时设置 reliable 和 ordered 同时为 true 和 false，不要设置一个为true，一个为false
    /// - Parameters:
    ///   - reliable: 设置是否保证接收方在5秒内接收到发送方的数据流（true：接收方在5秒内接收到发送方的数据流。如果接收者在5秒内没有接收到数据流，就会向应用程序报告错误；false：不能保证收件人在五秒内收到数据流，也不能就任何延迟或丢失的数据流报告错误消息）
    ///   - ordered: 设置接收方是否按发送顺序接收数据流（true：接收方按发送顺序接收数据流；false：接收方没有按发送顺序接收数据流）
    /// - Returns: 成功：数据流的ID；失败：< 0
    @discardableResult
    @objc func createDataStream(_ streamId: UnsafeMutablePointer<Int>, reliable: Bool, ordered: Bool) -> Int32 {
        let result = rtcEngineKit.createDataStream(streamId, reliable: reliable, ordered: ordered)
        return result
    }
    
    /// 向频道中的所有用户发送数据流消息
    ///
    /// SDK对此方法有如下限制：
    /// - 每个通道每秒最多可发送30个数据包，每个数据包的最大大小为1kb
    /// - 每个用户端每秒最多可发送6kb的数据
    /// - 每个用户最多可以同时拥有5个数据流
    ///
    /// 成功的调用此方法会触发远端用户的 AgoraRtcEngineDelegate.rtcEngine(_:receiveStreamMessageFromUid:streamId:data:)
    ///
    /// 失败的调用此方法会触发远端用户的 AgoraRtcEngineDelegate.rtcEngine(_:didOccurStreamMessageErrorFromUid:streamId:error:missed:cached:)
    ///
    /// **注意：** 此方法仅适用于通信配置文件或直播配置文件中的主机。如果直播配置文件中的观众调用此方法，则可以将观众角色更改为主机
    /// - Parameters:
    ///   - streamId: AgoraRtcEngineKit.createDataStream(_:reliable:ordered:) 创建的流的ID
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func sendStreamMessage(_ streamId: Int, data: Data) -> Int32 {
        let result = rtcEngineKit.sendStreamMessage(streamId, data: data)
        return result
    }
}


// MARK: - Miscellaneous Video Control
extension AgoraRTCEngineProxy {
    
    /// 设置本地视频镜像模式
    ///
    /// 在调用AgoraRtcEngineKit.startPreview 方法之前使用此方法，否则除非重新启用AgoraRtcEngineKit.startPreview，不然镜像模式不会生效
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setLocalVideoMirrorMode(_ mode: AgoraVideoMirrorMode) -> Int32 {
        let result = rtcEngineKit.setLocalVideoMirrorMode(mode)
        return result
    }
    
    /// 设置相机捕获首选项
    ///
    /// 对于视频通话或直播，SDK通常控制摄像机的输出参数。当默认相机捕捉设置不满足特殊要求或导致性能问题时，我们建议使用此方法设置相机捕捉首选项：
    ///
    /// - 如果捕获的原始视频数据的分辨率或帧速率高于(AgoraRtcEngineKit.setVideoEncoderConfiguration(_:)设置的分辨率或帧速率，则处理视频帧需要额外的CPU和RAM使用，并且会降低性能。我们建议将 configuration.preference 设置为 AgoraCameraCaptureOutputPreference.performance，以避免此类问题
    /// - 如果您不需要本地视频预览或愿意牺牲预览质量，我们建议将configuration.preference 设置为 AgoraCameraCaptureOutputPreference.performance，以优化CPU和RAM的使用
    /// - 如果您希望本地视频预览的质量更好，我们建议将 configuration.preference 设置为AgoraCameraCaptureOutputPreference.preview
    ///
    /// **注意：** 在启用本地摄像机之前调用此方法。也就是说，您可以在调用AgoraRtcEngineKit.joinChannel、AgoraRtcEngineKit.enableVideo或 AgoraRtcEngineKit.enableLocalVideo(_:)之前调用这个方法，这取决于使用哪个方法打开本地摄像机
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setCameraCapturerConfiguration(_ configuration: AgoraCameraCapturerConfiguration?) -> Int32 {
        let result = rtcEngineKit.setCameraCapturerConfiguration(configuration)
        return result
    }
}


// MARK: - Camera Control
extension AgoraRTCEngineProxy {
    
    /// 切换前后摄像头
    ///
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func switchCamera() -> Int32 {
        let result = rtcEngineKit.switchCamera()
        return result
    }
    
    /// 检查相机是否支持缩放功能
    ///
    /// - Returns: true：支持；false：不支持
    @objc func isCameraZoomSupported() -> Bool {
        let result = rtcEngineKit.isCameraZoomSupported()
        return result
    }
    
    /// 检查是否支持相机闪光灯功能
    ///
    /// **注意：** 该app通常默认启用前置摄像头。如果不支持前置摄像头的闪光灯，返回false。如果要检查是否支持后置照相机闪光灯，请在调用此方法之前调用AgoraRtcEngineKit.switchCamera方法
    /// - Returns: true：支持；false：不支持
    @objc func isCameraTorchSupported() -> Bool {
        let result = rtcEngineKit.isCameraTorchSupported()
        return result
    }
    
    /// 检查是否支持相机手动对焦功能
    ///
    /// - Returns: true：支持；false：不支持
    @objc func isCameraFocusPositionInPreviewSupported() -> Bool {
        let result = rtcEngineKit.isCameraFocusPositionInPreviewSupported()
        return result
    }
    
    /// 检查是否支持相机手动曝光功能
    ///
    /// - Returns: true：支持；false：不支持
    @objc func isCameraExposurePositionSupported() -> Bool {
        let result = rtcEngineKit.isCameraExposurePositionSupported()
        return result
    }
    
    /// 检查是否支持相机自动对焦功能
    ///
    /// - Returns: true：支持；false：不支持
    @objc func isCameraAutoFocusFaceModeSupported() -> Bool {
        let result = rtcEngineKit.isCameraAutoFocusFaceModeSupported()
        return result
    }
    
    /// 设置相机的缩放比例
    ///
    /// - Parameter zoomFactor: 相机缩放因子。范围：1.0~相机支持的最大值
    /// - Returns: 成功：设置的相机缩放因子；失败：< 0
    @discardableResult
    @objc func setCameraZoomFactor(_ zoomFactor: CGFloat) -> CGFloat {
        let result = rtcEngineKit.setCameraZoomFactor(zoomFactor)
        return result
    }
    
    /// 设置手动对焦位置
    ///
    /// 成功的调用此方法会在本地触发 AgoraRtcEngineDelegate.rtcEngine(_:cameraFocusDidChangedTo:)
    /// - Parameter position: 视图中触点的坐标
    /// - Returns: true：成功；false：失败
    @discardableResult
    @objc func setCameraFocusPositionInPreview(_ position: CGPoint) -> Bool {
        let result = rtcEngineKit.setCameraFocusPositionInPreview(position)
        return result
    }
    
    /// 设置相机曝光位置
    ///
    /// 成功的调用此方法会在本地触发 AgoraRtcEngineDelegate.rtcEngine(_:cameraExposureDidChangedTo:)
    /// - Parameter position: 视图中触点的坐标
    /// - Returns: true：成功；false：失败
    @discardableResult
    @objc func setCameraExposurePosition(_ position: CGPoint) -> Bool {
        let result = rtcEngineKit.setCameraExposurePosition(position)
        return result
    }
    
    /// 开启相机闪光功能
    ///
    /// - Returns: true：成功；false：失败
    @discardableResult
    @objc func setCameraTorchOn(_ isOn: Bool) -> Bool {
        let result = rtcEngineKit.setCameraTorchOn(isOn)
        return result
    }
    
    /// 是否启用相机自动对焦功能
    ///
    /// - Returns: true：成功；false：失败
    @discardableResult
    @objc func setCameraAutoFocusFaceModeEnabled(_ enable: Bool) -> Bool {
        let result = rtcEngineKit.setCameraAutoFocusFaceModeEnabled(enable)
        return result
    }
}


// MARK: - Custom Media Metadata
extension AgoraRTCEngineProxy {
    
    /// 设置元数据的数据源
    ///
    /// 将此方法与 AgoraRtcEngineKit.setMediaMetadataDelegate(_:with:) 方法一起使用，在视频流中添加同步元数据。您可以创建更加多样化的直播交互，例如发送购物链接、数字优惠券和在线测试
    ///
    /// **注意：**
    /// - 在 AgoraRtcEngineKit.joinChannel(byToken:channelId:info:uid:joinSuccess:) 之前调用此方法
    /// - 此方法只能用在直播配置文件中
    /// - Parameters:
    ///   - type: 目前只支持视频元数据
    /// - Returns: true：成功；false：失败
    @discardableResult
    @objc func setMediaMetadataDataSource(_ metadataDataSource: AgoraMediaMetadataDataSource?, with type: AgoraMetadataType) -> Bool {
        let result = rtcEngineKit.setMediaMetadataDataSource(metadataDataSource, with: type)
        return result
    }
    
    /// 设置元数据的代理
    ///
    /// **注意：**
    /// - 在 AgoraRtcEngineKit.joinChannel(byToken:channelId:info:uid:joinSuccess:) 之前调用此方法
    /// - 此方法只能用在直播配置文件中
    /// - Parameters:
    ///   - type: 目前只支持视频元数据
    /// - Returns: true：成功；false：失败
    @discardableResult
    @objc func setMediaMetadataDelegate(_ metadataDelegate: AgoraMediaMetadataDelegate?, with type: AgoraMetadataType) -> Bool {
        let result = rtcEngineKit.setMediaMetadataDelegate(metadataDelegate, with: type)
        return result
    }
}


// MARK: - Miscellaneous Methods
extension AgoraRTCEngineProxy {
    
    /// 获取当前的呼叫ID
    ///
    /// 当用户加入频道时，将生成一个 callId 来标识来自客户机的呼叫。反馈方法如 AgoraRtcEngineKit.rate(_:rating:description:) 和 AgoraRtcEngineKit.complain(_:description:)，必须在调用结束后调用，向SDK提交反馈
    ///
    /// AgoraRtcEngineKit.rate(_:rating:description:) 和 AgoraRtcEngineKit.complain(_:description:) 需要此方法获取callId
    /// - Returns: 当前的呼叫ID
    @objc func getCallId() -> String? {
        let result = rtcEngineKit.getCallId()
        return result
    }
    
    /// 允许用户在呼叫结束后对呼叫进行评级
    ///
    /// - Parameters:
    ///   - callId: AgoraRtcEngineKit.getCallId 获取的callId
    ///   - rating: 评分。范围：1~5。如果超出范围，会出现 AgoraErrorCode.invalidArgument 错误
    ///   - description: 评分的描述，800字节内
    /// - Returns: 成功：0；失败：< 0（AgoraErrorCode.invalidArgument，AgoraErrorCode.notReady）
    @discardableResult
    @objc func rate(_ callId: String, rating: Int, description: String?) -> Int32 {
        let result = rtcEngineKit.rate(callId, rating: rating, description: description)
        return result
    }
    
    /// 允许用户在呼叫结束后抱怨呼叫质量
    ///
    /// - Parameters:
    ///   - callId: AgoraRtcEngineKit.getCallId 获取的callId
    ///   - description: 抱怨的描述，800字节内
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func complain(_ callId: String, description: String?) -> Int32 {
        let result = rtcEngineKit.complain(callId, description: description)
        return result
    }
    
    /// 启用/禁用向主队列分派委托的方法
    ///
    /// - Returns: 成功：0；失败：< 0
    @objc func enableMainQueueDispatch(_ enabled: Bool) -> Int32 {
        let result = rtcEngineKit.enableMainQueueDispatch(enabled)
        return result
    }
    
    /// 获取SDK版本号
    static func getSdkVersion() -> String {
        let result = AgoraRtcEngineKit.getSdkVersion()
        return result
    }

    /// 指定SDK输出日志文件
    ///
    /// 日志文件记录了SDK操作的所有日志数据。确保保存日志文件的目录存在并且是可写的
    /// **注意：** ios 默认的日志输出目录：App Sandbox/Library/caches/agorasdk.log；确保此方法在 AgoraRtcEngineKit.sharedEngine(withAppId:delegate:) 后立即调用
    /// - Parameter filePath: 日志文件的绝对路径。日志文件是utf-8的
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setLogFile(_ filePath: String) -> Int32 {
        let result = rtcEngineKit.setLogFile(filePath)
        return result
    }
    
    /// 设置SDK的输出日志级别
    ///
    /// 可以使用一个或多个过滤器的组合。日志级别遵循OFF、CRITICAL、ERROR、WARNING、INFO和DEBUG的顺序。选择一个级别来查看该级别之前的日志
    ///
    /// - Parameter filter: AgoraLogFilter
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setLogFilter(_ filter: AgoraLogFilter) -> Int32 {
        let result = rtcEngineKit.setLogFilter(filter.rawValue)
        return result
    }

    /// 设置日志文件大小(KB)
    ///
    /// SDK有两个日志文件，每个文件的默认大小为512KB。如果您将fileSizeInBytes设置为1024KB， SDK输出的日志文件的总最大大小为2MB，如果日志文件的总大小超过了设置的值，新的输出日志文件将覆盖旧的输出日志文件
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setLogFileSize(_ fileSizeInKBytes: UInt) -> Int32 {
        let result = rtcEngineKit.setLogFileSize(fileSizeInKBytes)
        return result
    }

    /// 返回SDK引擎的本机处理程序
    ///
    /// 此接口用于获取用于特殊场景(如注册音频和视频帧观察者)的SDK引擎的本机CC++处理程序
    @objc func getNativeHandle() -> UnsafeMutableRawPointer? {
        let result = rtcEngineKit.getNativeHandle()
        return result
    }

    /// AgoraRtcEngineDelegate
    var delegate: AgoraRtcEngineDelegate? {
        set { rtcEngineKit.delegate = newValue }
        get { return rtcEngineKit.delegate }
    }
}


// MARK: - Customized Methods (Technical Preview)
extension AgoraRTCEngineProxy {
    
    /// 通过使用JSON选项配置SDK，提供技术预览功能或特殊定制
    ///
    /// - Parameter options: JSON格式的SDK选项
    /// - Returns: 成功：0；失败：< 0
    @discardableResult
    @objc func setParameters(_ options: String) -> Int32 {
        let result = rtcEngineKit.setParameters(options)
        return result
    }
    
    /// 获取SDK的参数以进行定制
    @discardableResult
    @objc func getParameter(_ parameter: String, args: String?) -> String? {
        let result = rtcEngineKit.getParameter(parameter, args: args)
        return result
    }
}


// MARK: - AgoraRtcEngineDelegate
extension AgoraRTCEngineProxy: AgoraRtcEngineDelegate {
}


// MARK: - Core Delegate Methods
extension AgoraRTCEngineProxy {
    
    /// 报告SDK运行时警告。多数情况下app可以忽略SDK报告的警告，因为SDK通常会修复该问题并恢复运行。
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        Agora.log(engine, warningCode, warningCode.rawValue)
        didOccurWarningObserver.send(value: (engine, warningCode))
    }
    
    /// 报告SDK运行时错误。多数情况下SDK不能修复该问题并恢复运行。SDK需要app采取措施或通知用户该问题。
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        Agora.log(engine, errorCode, errorCode.rawValue)
        didOccurErrorObserver.send(value: (engine, errorCode))
    }
    
    /// SDK执行了一个方法时调用
    /// - Parameters:
    ///     - error: AgoraErrorCode
    ///     - result: api 调用的结果
    func rtcEngine(_ engine: AgoraRtcEngineKit, didApiCallExecute error: Int, api: String, result: String) {
        Agora.log(engine, error, api, result)
        didApiCallExecuteObserver.send(value: (engine, error, api, result))
    }
    
    /// 本地用户加入一个频道时调用
    ///
    /// - Parameters:
    ///   - channel: 频道名
    ///   - uid: 用户ID，如果调用 AgoraRtcEngineKit.joinChannel(byToken:channelId:info:uid:joinSuccess:) 时指定了UID，则返回该UID。如果调用 AgoraRtcEngineKit.joinChannel 方法时没有指定UID，服务器会自动生成一个UID返回
    ///   - elapsed: 用户调用 AgoraRtcEngineKit.joinChannel 到调用此方法所花的时间（毫秒）
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        Agora.log(engine, channel, uid, elapsed)
        didJoinChannelObserver.send(value: (engine, channel, uid, elapsed))
    }
    
    /// 本地用户重新加入一个频道时调用
    ///
    /// - Parameters:
    ///   - channel: 频道名
    ///   - uid: 用户ID，如果调用 AgoraRtcEngineKit.joinChannel(byToken:channelId:info:uid:joinSuccess:) 时指定了UID，则返回该UID。如果调用 joinChannel 方法时没有指定UID，服务器会自动生成一个UID返回
    ///   - elapsed: 重新连接成功所花的时间（毫秒）
    func rtcEngine(_ engine: AgoraRtcEngineKit, didRejoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        Agora.log(engine, channel, uid, elapsed)
        didRejoinChannelObserver.send(value: (engine, channel, uid, elapsed))
    }
    
    /// 本地用户离开一个频道时调用。
    ///
    /// 当用户调用 leaveChannel(_:) 时，此回调会通知app一个用户离开了频道。
    ///
    /// 通过这个回调，app可以获取回调函数 AgoraRtcEngineDelegate.rtcEngine(_:audioQualityOfUid:quality:delay:lost:) 报告的调用持续时间和接收/传输数据的统计信息
    func rtcEngine(_ engine: AgoraRtcEngineKit, didLeaveChannelWith stats: AgoraChannelStats) {
        Agora.log(engine, stats)
        didLeaveChannelObserver.send(value: (engine, stats))
    }
    
    /// 本地用户调用 AgoraRtcEngineKit.registerLocalUserAccount(_:appId:) 或 AgoraRtcEngineKit.joinChannel(byUserAccount:token:channelId:joinSuccess:) 成功时调用
    func rtcEngine(_ engine: AgoraRtcEngineKit, didRegisteredLocalUser userAccount: String, withUid uid: UInt) {
        Agora.log(engine, userAccount, uid)
        didRegisteredLocalUserObserver.send(value: (engine, userAccount, uid))
    }
    
    /// 当一个远端用户加入了频道后，SDK获取到远端用户的UID和account缓存到表对象 userInfo 中，并触发此回调
    func rtcEngine(_ engine: AgoraRtcEngineKit, didUpdatedUserInfo userInfo: AgoraUserInfo, withUid uid: UInt) {
        Agora.log(engine, userInfo, uid)
        didUpdatedUserInfoObserver.send(value: (engine, userInfo, uid))
    }
    
    /// 在本地用户加入频道并转换角色后 AgoraRtcEngineKit.setClientRole(_:) 会触发此方法【直播频道配置文件下】
    func rtcEngine(_ engine: AgoraRtcEngineKit, didClientRoleChanged oldRole: AgoraClientRole, newRole: AgoraClientRole) {
        Agora.log(engine, oldRole, newRole)
        didClientRoleChangedObserver.send(value: (engine, oldRole, newRole))
    }
    
    /// 当远端用户或主机加入通道时发生
    ///
    /// - 通讯配置文件：此回调通知app另一个用户加入了频道，如果其他用户已经在频道中，SDK也会通知app现有用户
    /// - 直播配置文件：此回调通知app一个主机加入了频道。如果其他主机已经在频道中，SDK也会通知app现有主机。声网建议限制主机数为17
    ///
    /// SDK 在以下情况下触发此回调：
    /// - 远端用户、主机通过调用 AgoraRtcEngineKit.joinChannel(byToken:channelId:info:uid:joinSuccess:) 加入频道时
    /// - 远端用户在加入频道后通过调用 AgoraRtcEngineKit.setClientRole(_:) 转换角色时
    /// - 远端用户、主机在网络中断重新加入频道时
    /// - 主机通过调用 AgoraRtcEngineKit.addInjectStreamUrl(_:config:) 往频道中注入一个在线媒体流时
    ///
    /// 直播配置文件：
    /// - 主机在另一个主机加入频道会收到此回调
    /// - 频道中的观众在另一个主机加入时会收到此回调
    /// - 当一个web应用加入频道时，在web应用发布流时SDK会触发此回调
    ///
    /// - Parameters:
    ///   - elapsed: 本地用户调用 AgoraRtcEngineKit.joinChannel 或 AgoraRtcEngineKit.setClientRole(_:) 到触发此方法所花的时间（毫秒）
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        Agora.log(engine, uid, elapsed)
        didJoinedObserver.send(value: (engine, uid, elapsed))
    }
    
    /// 当远端用户(通讯)/主机(直播)离开频道时调用
    ///
    /// 用户离线有2个原因：
    /// - 离开频道：当用户/主机离开通道时，用户/主机发送一个告别消息。当接收到消息时，SDK假设用户/主机离开通道。
    /// - 掉线：当某段时间内(通信配置文件20秒，直播配置文件20秒)没有收到用户或主机的数据包时，SDK假设用户/主机掉线。不可靠的网络连接可能导致错误检测，因此Agora建议使用信令系统进行更可靠的脱机检测
    /// - Parameters:
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        Agora.log(engine, uid, reason, reason.rawValue)
        didOfflineObserver.send(value: (engine, uid, reason))
    }
    
    /// 网络连接状态改变时调用
    func rtcEngine(_ engine: AgoraRtcEngineKit, connectionChangedTo state: AgoraConnectionStateType, reason: AgoraConnectionChangedReason) {
        Agora.log(engine, state, state.rawValue, reason, reason.rawValue)
        connectionChangedObserver.send(value: (engine, state, reason))
    }
    
    /// 本地网络类型改变时调用
    func rtcEngine(_ engine: AgoraRtcEngineKit, networkTypeChangedTo type: AgoraNetworkType) {
        Agora.log(engine, type, type.rawValue)
        networkTypeChangedObserver.send(value: (engine, type))
    }
    
    /// 当SDK到服务器的连接中断10秒后，SDK无法重新连接到Agora的edge服务器时调用
    ///
    /// SDK在调用 AgoraRtcEngineKit.joinChannel 方法10秒后无法连接到服务器时触发这个回调，不管它是否在通道中。
    ///
    /// 与的区别：
    /// - SDK在成功加入频道后与服务器断开连接超过4秒时触发 AgoraRtcEngineDelegate.rtcEngineConnectionDidInterrupted(_:)
    /// - SDK在与服务器失去连接超过10秒时触发 AgoraRtcEngineDelegate.rtcEngineConnectionDidLost(_:) 回调，不管它是否加入频道
    ///
    /// 对于这两个回调，SDK都尝试重新连接到服务器，直到应用程序调用 AgoraRtcEngineKit.leaveChannel(_:)
    func rtcEngineConnectionDidLost(_ engine: AgoraRtcEngineKit) {
        Agora.log(engine)
        connectionDidLostObserver.send(value: (engine))
    }
    
    
    /// 当token在30秒内过期时调用
    ///
    /// AgoraRtcEngineKit.joinChannel(byToken:channelId:info:uid:joinSuccess:) 中的 token 过期时，用户会离线，SDK在token过期前30秒触发这个回调，提醒app获得一个新的token。秒触发这个回调，提醒应用程序获得一个新的“令牌”。收到这个回调后，在服务器上生成一个新的token，并调用 AgoraRtcEngineKit.renewToken(_:) 方法将新的token传递给SDK。

    ///
    /// - Parameters:
    ///   - token: 30s内过期的token
    func rtcEngine(_ engine: AgoraRtcEngineKit, tokenPrivilegeWillExpire token: String) {
        Agora.log(engine, token)
        tokenPrivilegeWillExpireObserver.send(value: (engine, token))
    }
    
    /// token过期时调用
    /// 在 AgoraRtcEngineKit.joinChannel(byToken:channelId:info:uid:joinSuccess:) 后，如果SDK由于网络问题失去了与Agora服务器的连接，token在一段时间后可能会过期，并需要一个新的token来重连服务器
    ///
    /// SDK触发此方法来通知app通过调用 AgoraRtcEngineKit.renewToken(_:)  重新生成一个token
    func rtcEngineRequestToken(_ engine: AgoraRtcEngineKit) {
        Agora.log(engine)
        requestTokenObserver.send(value: (engine))
    }
}


// MARK: - Media Delegate Methods
extension AgoraRTCEngineProxy {
    
    /// 当本地用户通过调用 AgoraRtcEngineKit.enableLocalAudio(_:) 方法恢复或停止捕获本地音频流时，SDK触发这个回调
    func rtcEngine(_ engine: AgoraRtcEngineKit, didMicrophoneEnabled enabled: Bool) {
        Agora.log(engine, enabled)
        didMicrophoneEnabledObserver.send(value: (engine, enabled))
    }
    
    /// 报告哪些用户正在说话，以及说话者当前的音量。此回调函数报告当前频道中音量最大的说话者的ID和音量。此回调函数中返回的音频音量是远端用户的语音音量和音频音量的总和。此回调默认是禁用的，可以通过 AgoraRtcEngineKit.enableAudioVolumeIndication(_:smooth:) 开启。
    ///
    /// 以不同的回调报告给本地用户和远端说话者：
    /// - 本地用户回调中 speakers 包含 uid = 0、volume = totalVolume 不管本地用户是否说话
    /// - 远端说话者回调中，speakers 包含每个说话者的UID和音量
    ///
    /// **注意：**
    /// - 调用 AgoraRtcEngineKit.muteLocalAudioStream(_:) 影响SDK的行为：
    ///     - 如果本地用户调用了 AgoraRtcEngineKit.muteLocalAudioStream(_:)，SDK立刻停止返回本地用户的回调
    ///     - 在远端说话者调用 AgoraRtcEngineKit.muteLocalAudioStream(_:)15秒后，远端说话者的回调会排除该用户的信息；在所有远端用户调用 AgoraRtcEngineKit.muteLocalAudioStream(_:)15秒后，SDK停止触发远端扬声器的回调
    /// - speakers为空时，表示当前没有远端用户在说话
    ///
    /// - Parameters:
    ///   - speakers: 所有的说话者
    ///   - totalVolume: 所有说话者的音量之和（0~255）
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportAudioVolumeIndicationOfSpeakers speakers: [AgoraRtcAudioVolumeInfo], totalVolume: Int) {
        Agora.log(engine, speakers, totalVolume)
        reportAudioVolumeIndicationOfSpeakersObserver.send(value: (engine, speakers, totalVolume))
    }
    
    /// 报告一段时间内哪个用户是最大的说话者。如果用户通过调用 AgoraRtcEngineKit.enableAudioVolumeIndication(_:smooth:) 方法启用音频音量指示，这个回调函数将返回活动说话者的UID，该活动说话者的声音由SDK的音频音量检测模块检测到
    ///
    /// **注意：**
    /// - 调用 AgoraRtcEngineKit.enableAudioVolumeIndication(_:smooth:)才会触发此回调
    /// - 回调返回的是一段时间内最大的说话者的UID，而不是临时的
    /// - Parameters:
    ///   - speakerUid: 一段时间内最大的说话者的UID
    func rtcEngine(_ engine: AgoraRtcEngineKit, activeSpeaker speakerUid: UInt) {
        Agora.log(engine, speakerUid)
        activeSpeakerObserver.send(value: (engine, speakerUid))
    }
    
    /// 当引擎发送第一帧本地音频时调用
    ///
    /// - Parameters:
    ///   - elapsed: 用户调用 AgoraRtcEngineKit.joinChannel 到调用此方法所花的时间（毫秒）
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstLocalAudioFrame elapsed: Int) {
        Agora.log(engine, elapsed)
        firstLocalAudioFrameObserver.send(value: (engine, elapsed))
    }
    
    /// 当引擎从指定的远端用户接收到第一个音频帧时调用
    ///
    /// 下面场景会触发此回调：
    /// - 远端用户加入并发送音频流时
    /// - 远端停止发送音频流并在之后15s后重新发送，可能的原因如下：
    ///     - 远端用户离开了频道
    ///     - 远端用户掉线
    ///     - 远端用户调用了 AgoraRtcEngineKit.muteLocalAudioStream(_:)
    ///     - 远端用户调用了 AgoraRtcEngineKit.disableAudio
    ///
    /// - Parameters:
    ///   - uid: 远端用户的UID
    ///   - elapsed: 本地用户调用 AgoraRtcEngineKit.joinChannel 到调用此方法所花的时间（毫秒）
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteAudioFrameOfUid uid: UInt, elapsed: Int) {
        Agora.log(engine, uid, elapsed)
        firstRemoteAudioFrameObserver.send(value: (engine, uid, elapsed))
    }
    
    /// 当SDK解码第一个远端音频帧以进行回放时调用
    ///
    /// - Parameters:
    ///   - elapsed: 本地用户调用 AgoraRtcEngineKit.joinChannel 到调用此方法所花的时间（毫秒）
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteAudioFrameDecodedOfUid uid: UInt, elapsed: Int) {
        Agora.log(engine, uid, elapsed)
        firstRemoteAudioFrameDecodedObserver.send(value: (engine, uid, elapsed))
    }
    
    /// 当引擎发送第一帧本地视频时调用
    ///
    /// - Parameters:
    ///   - size: 第一帧视频的大小
    ///   - elapsed: 本地用户调用 AgoraRtcEngineKit.joinChannel 到调用此方法所花的时间（毫秒）；如果 AgoraRtcEngineKit.startPreview 先于 AgoraRtcEngineKit.joinChannel 调用，则elapsed 表示 AgoraRtcEngineKit.startPreview 到调用此方法所花的时间（毫秒）
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstLocalVideoFrameWith size: CGSize, elapsed: Int) {
        Agora.log(engine, size, elapsed)
        firstLocalVideoFrameObserver.send(value: (engine, size, elapsed))
    }
    
    /// 当接收和解码第一个远端视频帧时调用
    ///
    /// 在以下情况下会触发此回调：
    /// - 远端用户加入频道并发送视频流时
    /// - 远端用户停止发送视频流15s后重新发送。可能的原因如下：
    ///     - 远端用户离开了频道
    ///     - 远端用户掉线
    ///     - 远端用户调用了 AgoraRtcEngineKit.muteLocalVideoStream(_:)
    ///     - 远端用户调用了 AgoraRtcEngineKit.disableVideo
    ///
    /// - Parameters:
    ///   - size: 视频帧的大小
    ///   - elapsed: 本地用户调用 AgoraRtcEngineKit.joinChannel 到调用此方法所花的时间（毫秒）
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        Agora.log(engine, uid, size, elapsed)
        firstRemoteVideoDecodedObserver.send(value: (engine, uid, size, elapsed))
    }
    
    /// 当第一帧远端视频帧渲染时调用
    ///
    /// - Parameters:
    ///   - size: 视频帧的大小
    ///   - elapsed: 本地用户调用 AgoraRtcEngineKit.joinChannel 到调用此方法所花的时间（毫秒）
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoFrameOfUid uid: UInt, size: CGSize, elapsed: Int) {
        Agora.log(engine, uid, size, elapsed)
        firstRemoteVideoFrameObserver.send(value: (engine, uid, size, elapsed))
    }
    
    /// 当远程用户的音频流被静音/非静音时调用
    ///
    /// - Parameters:
    ///   - muted: 是否静音
    func rtcEngine(_ engine: AgoraRtcEngineKit, didAudioMuted muted: Bool, byUid uid: UInt) {
        Agora.log(engine, muted, uid)
        didAudioMutedObserver.send(value: (engine, muted, uid))
    }
    
    /// 当远端用户的视频流回放暂停/恢复时调用
    ///
    /// 当远端用户通过调用 AgoraRtcEngineKit.muteLocalVideoStream(_:) 停止/恢复发送视频流时触发此回调
    ///
    /// **注意：** 当频道中的用户或广播者数量超过20时，此回调无效
    ///
    /// - Parameters:
    ///   - muted: 远端用户视频流播放停止/恢复。true：停止；false：恢复
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted: Bool, byUid uid: UInt) {
        Agora.log(engine, muted, uid)
        didVideoMutedObserver.send(value: (engine, muted, uid))
    }
    
    /// 当远端用户开启/禁用视频模块时调用
    ///
    /// 一旦视频模块禁用了，远端用户只能使用音频呼叫。远端用户不能发送或接受来自其他用户的视频
    ///
    /// 当远端用户通过调用 AgoraRtcEngineKit.disableVideo 开启或禁用视频模块时触发此回调
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoEnabled enabled: Bool, byUid uid: UInt) {
        Agora.log(engine, enabled, uid)
        didVideoEnabledObserver.send(value: (engine, enabled, uid))
    }
    
    /// 当远端用户开启/禁用本地视频捕获方法时调用
    ///
    /// 此回调仅适用于当用户只想观看远程视频而不向其他用户发送任何视频流时的场景
    func rtcEngine(_ engine: AgoraRtcEngineKit, didLocalVideoEnabled enabled: Bool, byUid uid: UInt) {
        Agora.log(engine, enabled, uid)
        didLocalVideoEnabledObserver.send(value: (engine, enabled, uid))
    }
    
    /// 当远端用户的视频大小或方向改变时调用
    ///
    /// - Parameters:
    ///   - rotation: 视频的方向，值范围：0~360
    func rtcEngine(_ engine: AgoraRtcEngineKit, videoSizeChangedOfUid uid: UInt, size: CGSize, rotation: Int) {
        Agora.log(engine, uid, size, rotation)
        videoSizeChangedObserver.send(value: (engine, uid, size, rotation))
    }
    
    /// 当远端视频流状态改变时调用
    ///
    /// 当两个远端视频帧的时间间隔 >= 600ms 时触发此回调
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteVideoStateChangedOfUid uid: UInt, state: AgoraVideoRemoteState) {
        Agora.log(engine, uid, state, state.rawValue)
        remoteVideoStateChangedObserver.send(value: (engine, uid, state))
    }
    
    /// 本地用户视频流状态改变时调用
    ///
    /// - Parameters:
    ///   - state: AgoraLocalVideoStreamState，当state == AgoraLocalVideoStreamState.failed时，查看AgoraLocalVideoStreamError
    ///   - error: AgoraLocalVideoStreamError
    func rtcEngine(_ engine: AgoraRtcEngineKit, localVideoStateChange state: AgoraLocalVideoStreamState, error: AgoraLocalVideoStreamError) {
        Agora.log(engine, state, state.rawValue, error, error.rawValue)
        localVideoStateChangeObserver.send(value: (engine, state, error))
    }
}


// MARK: - Fallback Delegate Methods
extension AgoraRTCEngineProxy {
    
    /// 当已发布的视频流由于不可靠的网络条件而返回到只包含音频的流，或在网络条件改善时切换回视频流时调用
    ///
    /// 如果调用 AgoraRtcEngineKit.setLocalPublishFallbackOption(_:) 时 option == AgoraStreamFallbackOptions.audioOnly，SDK在已发布的视频流由于不可靠的网络条件而返回到只包含音频的流，或在网络条件改善时切换回视频流时触发此回调
    ///
    /// **注意：** 一旦发布的流返回到只有音频时，远端app收到 AgoraRtcEngineDelegate.rtcEngine(_:didVideoMuted:byUid:) 回调
    ///
    /// - Parameters:
    ///   - isFallbackOrRecover: true：发布的流由于不可靠的网络条件返回到只包含音频的流；false：发布的流在网络条件改善时切回视频流
    func rtcEngine(_ engine: AgoraRtcEngineKit, didLocalPublishFallbackToAudioOnly isFallbackOrRecover: Bool) {
        Agora.log(engine, isFallbackOrRecover)
        didLocalPublishFallbackToAudioOnlyObserver.send(value: (engine, isFallbackOrRecover))
    }
    
    /// 当远端视频流由于不可靠的网络条件而退回到音频流或在网络条件改善后切换回视频时调用
    ///
    /// 如果调用 AgoraRtcEngineKit.setRemoteSubscribeFallbackOption(_:) 时 option == AgoraStreamFallbackOptions.audioOnly, SDK在远端媒体流由于不可靠的网络条件返回到只包含音频，或在网络条件改善后切换回视频时触发这个回调
    ///
    /// - **注意：** 一旦远端媒体流由于不可靠的网络条件切到低流时，可以通过 AgoraRtcEngineDelegate.rtcEngine(_:remoteVideoStats:) 监测流的高低切换
    /// - Parameters:
    ///   - isFallbackOrRecover: true：远端媒体流由于不可靠的网络条件返回到只包含音频的流；false：媒体流在网络条件改善时切回视频流
    func rtcEngine(_ engine: AgoraRtcEngineKit, didRemoteSubscribeFallbackToAudioOnly isFallbackOrRecover: Bool, byUid uid: UInt) {
        Agora.log(engine, isFallbackOrRecover, uid)
        didRemoteSubscribeFallbackToAudioOnlyObserver.send(value: (engine, isFallbackOrRecover, uid))
    }
}


// MARK: - Device Delegate Methods
extension AgoraRTCEngineProxy {
    
    /// 当本地音频路由发生更改时调用
    ///
    /// SDK在本地音频路由切换到耳机、扬声器、头戴式耳机或蓝牙设备时触发此回调
    ///
    /// - Parameters:
    ///   - routing: 音频路由 AgoraAudioOutputRouting
    func rtcEngine(_ engine: AgoraRtcEngineKit, didAudioRouteChanged routing: AgoraAudioOutputRouting) {
        Agora.log(engine, routing)
        didAudioRouteChangedObserver.send(value: (engine, routing))
    }
    
    /// 相机焦点区域改变时调用
    ///
    /// 当本地用于调用 AgoraRtcEngineKit.setCameraFocusPositionInPreview(_:) 改变相机焦点时触发此回调
    ///
    /// - Parameters:
    ///   - rect: 在相机缩放指定焦点区域的矩形区域
    func rtcEngine(_ engine: AgoraRtcEngineKit, cameraFocusDidChangedTo rect: CGRect) {
        Agora.log(engine, rect)
        cameraFocusDidChangedObserver.send(value: (engine, rect))
    }
    
    /// 当相机曝光区域发生变化时调用
    ///
    /// 当本地用于调用 AgoraRtcEngineKit.setCameraExposurePosition(_:) 改变相机曝光区域时触发此回调
    ///
    /// - Parameters:
    ///   - rect: 在相机变焦指定曝光面积的矩形区域
    func rtcEngine(_ engine: AgoraRtcEngineKit, cameraExposureDidChangedTo rect: CGRect) {
        Agora.log(engine, rect)
        cameraExposureDidChangedObserver.send(value: (engine, rect))
    }
}


// MARK: - Statistics Delegate Methods
extension AgoraRTCEngineProxy {
    
    /// 每两秒报告一次当前调用会话的统计信息时调用
    ///
    /// - Parameters:
    ///   - stats: AgoraChannelStats 统计信息
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportRtcStats stats: AgoraChannelStats) {
        Agora.log(engine, stats)
        reportRtcStatsObserver.send(value: (engine, stats))
    }
    
    /// 在用户加入通道之前，每两秒报告一次本地用户的最后一英里网络质量时调用
    ///
    /// 最后一英里是指本地设备和Agora的边缘服务器之间的连接。在应用程序调用 AgoraRtcEngineKit.enableLastmileTest方法之后，在用户加入通道之前，SDK每两秒钟触发一次回调报告本地用户的上行和下行最后一英里网络状况
    ///
    /// - Parameters:
    ///   - quality: 最后一英里网络质量基于上行链路和下行链路的丢包率和抖动
    func rtcEngine(_ engine: AgoraRtcEngineKit, lastmileQuality quality: AgoraNetworkQuality) {
        Agora.log(engine, quality, quality.rawValue)
        lastmileQualityObserver.send(value: (engine, quality))
    }
    
    /// 每两秒报告一次通道中每个用户的最后一英里网络质量时调用
    ///
    /// 最后一英里是指本地设备和Agora的边缘服务器之间的连接。SDK每两秒触发此回调一次，以报告通道中每个用户的最后一英里网络状况。如果一个通道包含多个用户，SDK会多次触发这个回调
    ///
    /// - Parameters:
    ///   - uid: 频道中用户的UID。如果UID == 0，表示本地用户
    ///   - txQuality: 上行链路的传输质量，包括上行网络的传输比特率、丢包率、平均RTT(往返时间)和抖动。“txQuality”是一个质量评级，帮助您了解当前上行网络条件如何支持所选的AgoraVideoEncoderConfiguration。例如，对于分辨率为640 * 480 的视频帧和帧率为15fps直播配置文件，1000-Kbps上行链路网络就足够了；但可对于高于1280×720分辨率就不能满足了
    ///   - rxQuality: 根据数据包丢失率、平均RTT和下行网络抖动对用户的下行网络质量进行评级
    func rtcEngine(_ engine: AgoraRtcEngineKit, networkQuality uid: UInt, txQuality: AgoraNetworkQuality, rxQuality: AgoraNetworkQuality) {
        Agora.log(engine, uid, txQuality, txQuality.rawValue, rxQuality, rxQuality.rawValue)
        networkQualityObserver.send(value: (engine, uid, txQuality, rxQuality))
    }
    
    /// 报告最后一英里网络探测结果时调用
    ///
    /// SDK在app调用 AgoraRtcEngineKit.startLastmileProbeTest(_:) 后30秒内触发此回调
    ///
    /// - Parameters:
    ///   - result: 上行链路和下行链路最后一英里网络探针测试结果
    func rtcEngine(_ engine: AgoraRtcEngineKit, lastmileProbeTest result: AgoraLastmileProbeResult) {
        Agora.log(engine, result)
        lastmileProbeTestObserver.send(value: (engine, result))
    }
    
    /// 每2s报告本地视频流的统计数据时调用
    ///
    /// - Parameters:
    ///   - stats: 上传本地视频流的统计信息
    func rtcEngine(_ engine: AgoraRtcEngineKit, localVideoStats stats: AgoraRtcLocalVideoStats) {
        Agora.log(engine, stats)
        localVideoStatsObserver.send(value: (engine, stats))
    }
    
    /// 报告来自每个远端用户/主机的视频流的统计数据时调用
    ///
    /// SDK每两秒为每个远端用户/主机触发一次回调。如果一个频道包含多个远端用户，SDK会多次触发这个回调
    ///
    /// - Parameters:
    ///   - stats: 收到的远端视频流的统计信息
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteVideoStats stats: AgoraRtcRemoteVideoStats) {
        Agora.log(engine, stats)
        remoteVideoStatsObserver.send(value: (engine, stats))
    }
    
    /// 报告来自每个远端用户/主机的音频流的统计数据时调用
    ///
    /// 此方法替换了 AgoraRtcEngineDelegate.rtcEngine(_:audioQualityOfUid:quality:delay:lost:)
    ///
    /// SDK每两秒为每个远端用户/主机触发一次回调。如果一个频道包含多个远端用户，SDK会多次触发这个回调
    ///
    /// 与 AgoraRtcEngineDelegate.rtcEngine(_:audioTransportStatsOfUid:delay:lost:rxKBitRate:) 回调报告的统计数据相比，该回调报告的统计数据更接近于音频传输质量的实际用户体验。这个回调函数更多地报告媒体层统计信息，比如帧丢失率，而 AgoraRtcEngineDelegate.rtcEngine(_:audioTransportStatsOfUid:delay:lost:rxKBitRate:) 回调函数更多地报告传输层统计信息，比如包丢失率
    ///
    /// 如FEC(前向纠错)或重传等方案可以抵消帧丢失率。因此，即使丢包率很高，用户也可能发现整体音频质量是可以接受的
    ///
    /// - Parameters:
    ///   - stats: 收到的远端视频流的统计信息
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteAudioStats stats: AgoraRtcRemoteAudioStats) {
        Agora.log(engine, stats)
        remoteAudioStatsObserver.send(value: (engine, stats))
    }
    
    /// 报告每个音频流传输层的统计信息时调用
    ///
    /// 这个回调函数在本地用户从远端用户接收到音频包后每两秒报告传输层统计信息，例如包丢失率和网络时间延迟
    func rtcEngine(_ engine: AgoraRtcEngineKit, audioTransportStatsOfUid uid: UInt, delay: UInt, lost: UInt, rxKBitRate: UInt) {
        Agora.log(engine, uid, delay, lost, rxKBitRate)
        audioTransportStatsObserver.send(value: (engine, uid, delay, lost, rxKBitRate))
    }
    
    /// 报告每个视频流传输层的统计信息时调用
    ///
    /// 这个回调函数在本地用户从远端用户接收到视频包后每两秒报告传输层统计信息，例如包丢失率和网络时间延迟
    func rtcEngine(_ engine: AgoraRtcEngineKit, videoTransportStatsOfUid uid: UInt, delay: UInt, lost: UInt, rxKBitRate: UInt) {
        Agora.log(engine, uid, delay, lost, rxKBitRate)
        videoTransportStatsObserver.send(value: (engine, uid, delay, lost, rxKBitRate))
    }
}


// MARK: - Audio Player Delegate Methods
extension AgoraRTCEngineProxy {
    
    /// 当音频混合文件播放结束时调用
    ///
    /// 可以通过调用 AgoraRtcEngineKit.startAudioMixing(_:loopback:replace:cycle:) 方法来启动音频混合文件播放。SDK在音频混合文件回放结束时触发此回调。如果 AgoraRtcEngineKit.startAudioMixing(_:loopback:replace:cycle:) 调用失败，通过 AgoraRtcEngineDelegate.rtcEngine(_:didOccurWarning:) 返回 AgoraWarningCode.audioMixingOpenError 警告码
    func rtcEngineLocalAudioMixingDidFinish(_ engine: AgoraRtcEngineKit) {
        Agora.log(engine)
        localAudioMixingDidFinishObserver.send(value: engine)
    }
    
    /// 当本地用户的音频混合文件的状态发生更改时调用
    ///
    /// 如果本地音频混合文件不存在，或者SDK不支持文件格式或无法访问音乐文件URL, SDK返回 errorCode == AgoraAudioMixingErrorCode.canNotOpen
    func rtcEngine(_ engine: AgoraRtcEngineKit, localAudioMixingStateDidChanged state: AgoraAudioMixingStateCode, errorCode: AgoraAudioMixingErrorCode) {
        Agora.log(engine, state, state.rawValue, errorCode, errorCode.rawValue)
        localAudioMixingStateDidChangedObserver.send(value: (engine, state, errorCode))
    }
    
    /// 当远程用户启动音频混合时调用
    ///
    /// 当远程用户调用 AgoraRtcEngineKit.startAudioMixing(_:loopback:replace:cycle:) 方法时SDK触发这个回调
    func rtcEngineRemoteAudioMixingDidStart(_ engine: AgoraRtcEngineKit) {
        Agora.log(engine)
        remoteAudioMixingDidStartObserver.send(value: engine)
    }
    
    /// 当远程用户结束音频混合时调用
    func rtcEngineRemoteAudioMixingDidFinish(_ engine: AgoraRtcEngineKit) {
        Agora.log(engine)
        remoteAudioMixingDidFinishObserver.send(value: engine)
    }
    
    /// 当本地音频效果回放结束时调用
    ///
    /// 您可以通过调用 AgoraRtcEngineKit.playEffect(_:filePath:loopCount:pitch:pan:gain:publish:) 方法来启动本地音频效果播放。SDK在本地音频效果文件回放完成时触发此回调
    ///
    /// - Parameters:
    ///   - soundId: 本地音效的ID
    func rtcEngineDidAudioEffectFinish(_ engine: AgoraRtcEngineKit, soundId: Int) {
        Agora.log(engine, soundId)
        didAudioEffectFinishObserver.send(value: (engine, soundId))
    }
}


// MARK: - CDN Publisher Delegate Methods
extension AgoraRTCEngineProxy {
    
    /// 当RTMP流的状态发生更改时调用
    ///
    /// SDK触发这个回调来报告本地用户调用 AgoraRtcEngineKit.addPublishStreamUrl(_:transcodingEnabled:) 或 AgoraRtcEngineKit.removePublishStreamUrl(_:) 方法的结果
    /// - Parameters:
    /// - url: RTMP url
    func rtcEngine(_ engine: AgoraRtcEngineKit, rtmpStreamingChangedToState url: String, state: AgoraRtmpStreamingState, errorCode: AgoraRtmpStreamingErrorCode) {
        Agora.log(engine, url, state, state.rawValue, errorCode, errorCode.rawValue)
        rtmpStreamingChangedToStateObserver.send(value: (engine, url, state, errorCode))
    }
    
    /// 报告调用 AgoraRtcEngineKit.addPublishStreamUrl(_:transcodingEnabled:) 的结果时调用
    /// - Parameters:
    /// - url: RTMP url
    func rtcEngine(_ engine: AgoraRtcEngineKit, streamPublishedWithUrl url: String, errorCode: AgoraErrorCode) {
        Agora.log(engine, url, errorCode, errorCode.rawValue)
        streamPublishedWithUrlObserver.send(value: (engine, url, errorCode))
    }
    
    /// 报告调用 AgoraRtcEngineKit.removePublishStreamUrl(_:) 的结果时调用
    ///
    /// - Parameters:
    /// - url: RTMP url
    func rtcEngine(_ engine: AgoraRtcEngineKit, streamUnpublishedWithUrl url: String) {
        Agora.log(engine, url)
        streamUnpublishedWithUrlObserver.send(value: (engine, url))
    }
    
    /// 当更新CDN实时流媒体设置时调用
    func rtcEngineTranscodingUpdated(_ engine: AgoraRtcEngineKit) {
        Agora.log(engine)
        transcodingUpdatedObserver.send(value: engine)
    }
}


// MARK: - Inject Stream URL Delegate Methods
extension AgoraRTCEngineProxy {
    
    /// 报告向直播注入在线流的状态
    func rtcEngine(_ engine: AgoraRtcEngineKit, streamInjectedStatusOfUrl url: String, uid: UInt, status: AgoraInjectStreamStatus) {
        Agora.log(engine, url, uid, status)
        streamInjectedStatusOfUrlObserver.send(value: (engine, url, uid, status))
    }
}


// MARK: - Stream Message Delegate Methods
extension AgoraRTCEngineProxy {
    
    /// 当本地用户在5秒内从远程用户接收到数据流时调用
    ///
    /// SDK在本地用户接收到远程用户通过调用 AgoraRtcEngineKit.sendStreamMessage(_:data:) 方法发送的流消息时触发此回调
    func rtcEngine(_ engine: AgoraRtcEngineKit, receiveStreamMessageFromUid uid: UInt, streamId: Int, data: Data) {
        Agora.log(engine, uid, streamId, data)
        receiveStreamMessageObserver.send(value: (engine, uid, streamId, data))
    }
    
    /// 当本地用户在5秒内没有接收到来自远程用户的数据流时调用
    ///
    /// - Parameters:
    ///   - error: 错误ID，查看 AgoraErrorCode
    ///   - missed: 丢失信息的数量
    ///   - cached: 数据流中断时缓存的传入消息数
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurStreamMessageErrorFromUid uid: UInt, streamId: Int, error: Int, missed: Int, cached: Int) {
        Agora.log(engine, uid, streamId, error, missed, cached)
        didOccurStreamMessageErrorObserver.send(value: (engine, uid, streamId, error, missed, cached))
    }
}


// MARK: - Miscellaneous Delegate Methods
extension AgoraRTCEngineProxy {
    
    /// 媒体引擎加载时调用
    func rtcEngineMediaEngineDidLoaded(_ engine: AgoraRtcEngineKit) {
        Agora.log(engine)
        mediaEngineDidLoadedObserver.send(value: engine)
    }
    
    /// 媒体引擎调用启动时调用
    func rtcEngineMediaEngineDidStartCall(_ engine: AgoraRtcEngineKit) {
        Agora.log(engine)
        mediaEngineDidStartCallObserver.send(value: engine)
    }
}
