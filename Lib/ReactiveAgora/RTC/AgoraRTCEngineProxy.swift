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
    func destroy() {
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
    func setChannelProfile(_ profile: AgoraChannelProfile) -> Int {
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
    func setClientRole(_ role: AgoraClientRole) -> Int {
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
    func joinChannel(byToken: String?, channelId: String, info: String?, uid: UInt, joinSuccess: ((String, UInt, Int) -> Void)?) -> Int32 {
        let result = rtcEngineKit.joinChannel(byToken: byToken, channelId: channelId, info: info, uid: uid) { (channel, uid, elapsed) in
            
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
    func joinChannel(byUserAccount: String, token: String?, channelId: String, joinSuccess: ((String, UInt, Int) -> Void)?) -> Int32 {
        let result = rtcEngineKit.joinChannel(byUserAccount: byUserAccount, token: token, channelId: channelId) { (channel, uid, elasped) in
            
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
    func registerLocalUserAccount(_ userAccount: String, appId: String) -> Int32 {
        let result = rtcEngineKit.registerLocalUserAccount(userAccount, appId: appId)
        return result
    }
    
    /// 通过用户账号获取用户信息
    ///
    /// 远端用户连接频道后，SDK获取远端用户的UID和用户帐户，缓存在映射表缓存对象(“AgoraUserInfo”)中，并触发 AgoraRtcEngineDelegate.rtcEngine(_:didUpdatedUserInfo:withUid:)回调
    ///
    /// 在接收到 AgoraRtcEngineDelegate.rtcEngine(_:didUpdatedUserInfo:withUid:) 回调之后，您可以调用这个方法，通过传入用户帐户来从'userInfo'对象获取远端用户的UID
    func getUserInfo(byUserAccount: String, withError: UnsafeMutablePointer<AgoraErrorCode>?) -> AgoraUserInfo? {
        let userInfo = rtcEngineKit.getUserInfo(byUserAccount: byUserAccount, withError: withError)
        return userInfo
    }
    
    /// 通过UID获取用户信息
    ///
    /// 远端用户连接频道后，SDK获取远端用户的UID和用户帐户，缓存在映射表缓存对象(“AgoraUserInfo”)中，并触发 AgoraRtcEngineDelegate.rtcEngine(_:didUpdatedUserInfo:withUid:)回调
    ///
    /// 在接收到 AgoraRtcEngineDelegate.rtcEngine(_:didUpdatedUserInfo:withUid:) 回调之后，您可以调用这个方法，通过传入UID来从'userInfo'对象获取远端用户的用户账户
    func getUserInfo(byUid: UInt, withError: UnsafeMutablePointer<AgoraErrorCode>?) -> AgoraUserInfo? {
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
    func leaveChannel(_ leaveChannelBlock: ((AgoraChannelStats) -> Void)?) -> Int32 {
        let result = rtcEngineKit.leaveChannel { (stats) in
            
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
    func renewToken(_ token: String) -> Int32 {
        let result = rtcEngineKit.renewToken(token)
        return result
    }
    
    
    /// 开启与Agora Web SDK的互操作性
    ///
    /// 此方法只适用于直播配置文件。通讯配置文件下，默认是与Agora Web SDK有互操作性
    /// - Returns: 成功：0；失败：< 0
    func enableWebSdkInteroperability(_ enabled: Bool) -> Int32 {
        let result = rtcEngineKit.enableWebSdkInteroperability(enabled)
        return result
    }
    
    /// 获取app的连接状态
    func getConnectionState() -> AgoraConnectionStateType {
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
    func enableAudio() -> Int32 {
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
    func disableAudio() -> Int32 {
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
    func setAudioProfile(profile: AgoraAudioProfile, scenario: AgoraAudioScenario) -> Int32 {
        let result = rtcEngineKit.setAudioProfile(profile, scenario: scenario)
        return result
    }
    
    /// 调整录音音量
    ///
    /// - Parameter volume: 录音音量。（范围是：0~4001。0：静音；100：原始音量；400：最大声，四倍的原始音量与信号剪辑保护）
    /// - Returns: 成功：0；失败：< 0
    func adjustRecordingSignalVolume(_ volume: Int) -> Int32 {
        let result = rtcEngineKit.adjustRecordingSignalVolume(volume)
        return result
    }
    
    /// 调整播放音量
    ///
    /// - Parameter volume: 播放音量。（范围是：0~4001。0：静音；100：原始音量；400：最大声，四倍的原始音量与信号剪辑保护）
    /// - Returns: 成功：0；失败：< 0
    func adjustPlaybackSignalVolume(_ volume: Int) -> Int32 {
        let result = rtcEngineKit.adjustPlaybackSignalVolume(volume)
        return result
    }
    
    /// 使SDK能够定期向应用程序报告说话者和说话者的音量
    ///
    /// - Parameters:
    ///   - interval: 设置两个连续音量指示之间的时间间隔（<0：禁用音量指示；>0：两个连续的音量指示之间的时间间隔(ms)。Agora建议设置 interval≥200 ms。一旦启用了这个方法，SDK返回体积指标的设置时间间隔AgoraRtcEngineDelegate.rtcEngine(_:reportAudioVolumeIndicationOfSpeakers:totalVolume:)回调，无论哪个用户在频道说话）
    ///   - smooth: 平滑因子设置音频音量指示器的灵敏度。值的范围在0到10之间。值越大，表示指标越敏感。推荐值为3
    /// - Returns: 成功：0；失败：< 0
    func enableAudioVolumeIndication(_ interval: Int, smooth: Int) -> Int32 {
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
    func enableLocalAudio(_ enabled: Bool) -> Int32 {
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
    func muteLocalAudioStream(_ mute: Bool) -> Int32 {
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
    func muteRemoteAudioStream(_ uid: UInt, mute: Bool) -> Int32 {
        let result = rtcEngineKit.muteRemoteAudioStream(uid, mute: mute)
        return result
    }
    
    /// 接收/停止接收所有远端用户的音频流
    ///
    /// - Parameter mute: 设置是否接收/停止接收所有远端用户的音频流。默认为false
    /// - Returns: 成功：0；失败：< 0
    func muteAllRemoteAudioStreams(_ mute: Bool) -> Int32 {
        let result = rtcEngineKit.muteAllRemoteAudioStreams(mute)
        return result
    }
    
    /// 默认是否接受所有的远端音频流
    ///
    /// 可以在加入频道之前或之后调用此方法。如果在加入频道后调用此方法，则不会接收随后加入的所有用户的音频流
    ///
    /// - Parameter mute: 默认是否接受所有的远端音频流。默认为false
    /// - Returns: 成功：0；失败：< 0
    func setDefaultMuteAllRemoteAudioStreams(_ mute: Bool) -> Int32 {
        let result = rtcEngineKit.setDefaultMuteAllRemoteAudioStreams(mute)
        return result
    }
}

// MARK: - Core Video
extension AgoraRTCEngineProxy {
    
}

// MARK: - Video Pre-Process and Post-Process
extension AgoraRTCEngineProxy {
    
}

// MARK: - Audio Routing Controller
extension AgoraRTCEngineProxy {
    
}

// MARK: - In Ear Monitor
extension AgoraRTCEngineProxy {
    
}

// MARK: - Audio Sound Effect
extension AgoraRTCEngineProxy {
    
}

// MARK: - Music File Playback and Mixing
extension AgoraRTCEngineProxy {
    
}

// MARK: - Audio Effect File Playback
extension AgoraRTCEngineProxy {
    
}

// MARK: - Audio Recorder
extension AgoraRTCEngineProxy {
    
}

// MARK: - Loopback Recording
extension AgoraRTCEngineProxy {
    
}

// MARK: - Miscellaneous Audio Control
extension AgoraRTCEngineProxy {
    
}

// MARK: - Network-related Test
extension AgoraRTCEngineProxy {
    
}

// MARK: - Custom Video Module
extension AgoraRTCEngineProxy {
    
}

// MARK: - External Audio Data
extension AgoraRTCEngineProxy {
    
}

// MARK: - External Video Data
extension AgoraRTCEngineProxy {
    
}

// MARK: - Raw Audio Data
extension AgoraRTCEngineProxy {
    
}

// MARK: - Watermark
extension AgoraRTCEngineProxy {
    
}

// MARK: - Stream Fallback
extension AgoraRTCEngineProxy {
    
}

// MARK: - Dual-stream Mode
extension AgoraRTCEngineProxy {
    
}

// MARK: - Encryption
extension AgoraRTCEngineProxy {
    
}

// MARK: - Inject an Online Media Stream
extension AgoraRTCEngineProxy {
    
}

// MARK: - CDN Live Streaming
extension AgoraRTCEngineProxy {
    
}

// MARK: - Data Stream
extension AgoraRTCEngineProxy {
    
}

// MARK: - Miscellaneous Video Control
extension AgoraRTCEngineProxy {
    
}

// MARK: - Camera Control
extension AgoraRTCEngineProxy {
    
}

// MARK: - Screen Sharing
extension AgoraRTCEngineProxy {
    
}

// MARK: - Custom Media Metadata
extension AgoraRTCEngineProxy {
    
}

// MARK: - Miscellaneous Methods
extension AgoraRTCEngineProxy {
    
}

// MARK: - Customized Methods (Technical Preview)
extension AgoraRTCEngineProxy {
    
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
