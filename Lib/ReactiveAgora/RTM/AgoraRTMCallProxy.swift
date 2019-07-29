//
//  AgoraRTMCallProxy.swift
//  ReactiveAgora
//
//  Created by lixiangzhou on 2019/7/19.
//Copyright © 2019 LXZ. All rights reserved.
//

import Foundation
import AgoraRtmKit
import ReactiveSwift

class AgoraRTMCallProxy: NSObject {
    
    /// 创建呼叫Proxy
    override init() {
        callKit = AgoraRtmCallKit()
        super.init()
    }
    
    /// AgoraRtmCallKit
    var callKit: AgoraRtmCallKit
    
    /// AgoraRtmCallDelegate
    var callDelegate: AgoraRtmCallDelegate? {
        set { callKit.callDelegate = newValue }
        get { return callKit.callDelegate }
    }
    
    /// AgoraRtmKit
    var rtmKit: AgoraRtmKit? {
        get { return callKit.rtmKit }
    }
    
    // MARK: - Method CallBack Signal
    
    /// 发送呼叫邀请方法 信号量
    let (sendInvitationSignal, sendInvitationObserver) = Signal<((AgoraRtmLocalInvitation), AgoraRtmInvitationApiCallErrorCode), Never>.pipe()
    
    /// 取消呼叫邀请方法 信号量
    let (cancelInvitationSignal, cancelInvitationObserver) = Signal<((AgoraRtmLocalInvitation), AgoraRtmInvitationApiCallErrorCode), Never>.pipe()
    
    /// 接收呼叫邀请方法 信号量
    let (acceptInvitationSignal, acceptInvitationObserver) = Signal<((AgoraRtmRemoteInvitation), AgoraRtmInvitationApiCallErrorCode), Never>.pipe()
    
    /// 拒绝呼叫邀请方法 信号量
    let (refuseInvitationSignal, refuseInvitationObserver) = Signal<((AgoraRtmRemoteInvitation), AgoraRtmInvitationApiCallErrorCode), Never>.pipe()
    
    // MARK: - Delegate Signal
    
    /// 被叫者收到呼叫的 代理方法信号量（呼叫者回调）
    let (localInvitationReceivedSignal, localInvitationReceivedObserver) = Signal<(AgoraRtmCallKit, AgoraRtmLocalInvitation), Never>.pipe()
    
    /// 被叫者接听的 代理方法信号量（呼叫者回调）
    let (localInvitationAcceptedSignal, localInvitationAcceptedObserver) = Signal<(AgoraRtmCallKit, AgoraRtmLocalInvitation, String?), Never>.pipe()
    
    /// 被叫者拒绝的 代理方法信号量（呼叫者回调）
    let (localInvitationRefusedSignal, localInvitationRefusedObserver) = Signal<(AgoraRtmCallKit, AgoraRtmLocalInvitation, String?), Never>.pipe()
    
    /// 呼叫者取消的 代理方法信号量（呼叫者回调）
    let (localInvitationCanceledSignal, localInvitationCanceledObserver) = Signal<(AgoraRtmCallKit, AgoraRtmLocalInvitation), Never>.pipe()
    
    /// 呼叫生命周期结束的 代理方法信号量（呼叫者回调）
    let (localInvitationFailureSignal, localInvitationFailureObserver) = Signal<(AgoraRtmCallKit, AgoraRtmLocalInvitation, AgoraRtmLocalInvitationErrorCode), Never>.pipe()
    
    /// 被叫者收到呼叫的 代理方法信号量（被叫者回调）
    let (remoteInvitationReceivedSignal, remoteInvitationReceivedObserver) = Signal<(AgoraRtmCallKit, AgoraRtmRemoteInvitation), Never>.pipe()
    
    /// 被叫者接听的 代理方法信号量（被叫者回调）
    let (remoteInvitationAcceptedSignal, remoteInvitationAcceptedObserver) = Signal<(AgoraRtmCallKit, AgoraRtmRemoteInvitation), Never>.pipe()
    
    /// 被叫者拒绝的 代理方法信号量（被叫者回调）
    let (remoteInvitationRefusedSignal, remoteInvitationRefusedObserver) = Signal<(AgoraRtmCallKit, AgoraRtmRemoteInvitation), Never>.pipe()
    
    /// 呼叫者取消的 代理方法信号量（被叫者回调）
    let (remoteInvitationCanceledSignal, remoteInvitationCanceledObserver) = Signal<(AgoraRtmCallKit, AgoraRtmRemoteInvitation), Never>.pipe()
    
    /// 呼叫生命周期结束的 代理方法信号量（被叫者回调）
    let (remoteInvitationFailureSignal, remoteInvitationFailureObserver) = Signal<(AgoraRtmCallKit, AgoraRtmRemoteInvitation, AgoraRtmRemoteInvitationErrorCode), Never>.pipe()
}

// MARK: - Method Proxy
extension AgoraRTMCallProxy {
    /// 呼叫者发送一个呼叫邀请给被叫者
    ///
    /// - 成功：
    ///     - 呼叫者收到 AgoraRtmLocalInvitationSendBlock 和 AgoraRtmCallDelegate.rtmCallKit(_:localInvitationReceivedByPeer:) 回调，code == AgoraRtmInvitationApiCallError.ok
    ///     - 被叫者收到 AgoraRtmCallDelegate.rtmCallKit(_:remoteInvitationReceived:) 回调
    /// - 失败：呼叫者收到 AgoraRtmLocalInvitationSendBlock 回调，查看 AgoraRtmInvitationApiCallErrorCode 错误码
    ///
    /// - Parameters:
    ///   - localInvitation: AgoraRtmLocalInvitation
    ///   - completion: AgoraRtmLocalInvitationSendBlock 完成回调。查看 AgoraRtmInvitationApiCallErrorCode 错误码
    func send(_ localInvitation: AgoraRtmLocalInvitation, completion: AgoraRtmLocalInvitationSendBlock? = nil) {
        Agora.log(localInvitation)
        callKit.send(localInvitation) { [weak self] (code) in
            completion?(code)
            self?.sendInvitationObserver.send(value: ((localInvitation), code))
        }
    }
    
    /// 呼叫者取消呼叫邀请
    ///
    /// - 成功：
    ///     - 呼叫者收到 AgoraRtmLocalInvitationCancelBlock 和 AgoraRtmCallDelegate.rtmCallKit(_:localInvitationCanceled:) 回调，code == AgoraRtmInvitationApiCallError.ok
    ///     - 被叫者收到 AgoraRtmCallDelegate.rtmCallKit(_:remoteInvitationCanceled:) 回调
    /// - 失败：呼叫者收到 AgoraRtmLocalInvitationCancelBlock 回调，查看 AgoraRtmInvitationApiCallErrorCode 错误码
    ///
    /// - Parameters:
    ///   - localInvitation: AgoraRtmLocalInvitation
    ///   - completion: AgoraRtmLocalInvitationCancelBlock 完成回调。查看 AgoraRtmInvitationApiCallErrorCode 错误码
    func cancel(_ localInvitation: AgoraRtmLocalInvitation, completion: AgoraRtmLocalInvitationCancelBlock? = nil) {
        Agora.log(localInvitation)
        callKit.cancel(localInvitation) { [weak self] (code) in
            completion?(code)
            self?.cancelInvitationObserver.send(value: ((localInvitation), code))
        }
    }
    
    /// 被叫者接受呼叫邀请
    ///
    /// - 成功：
    ///     - 呼叫者收到 AgoraRtmRemoteInvitationAcceptBlock 和 AgoraRtmCallDelegate.rtmCallKit(_:localInvitationAccepted:withResponse:) 回调，code == AgoraRtmInvitationApiCallError.ok
    ///     - 被叫者收到 AgoraRtmCallDelegate.rtmCallKit(_:remoteInvitationAccepted:) 回调
    /// - 失败：呼叫者收到 AgoraRtmLocalInvitationCancelBlock 回调，查看 AgoraRtmInvitationApiCallErrorCode 错误码
    ///
    /// - Parameters:
    ///   - remoteInvitation: AgoraRtmRemoteInvitation
    ///   - completion: AgoraRtmRemoteInvitationAcceptBlock 完成回调。查看 AgoraRtmInvitationApiCallErrorCode 错误码
    func accept(_ remoteInvitation: AgoraRtmRemoteInvitation, completion: AgoraRtmRemoteInvitationAcceptBlock? = nil) {
        Agora.log(remoteInvitation)
        callKit.accept(remoteInvitation) { [weak self] (code) in
            completion?(code)
            self?.acceptInvitationObserver.send(value: ((remoteInvitation), code))
        }
    }
    
    /// 被叫者拒绝呼叫邀请
    ///
    /// - 成功：
    ///     - 呼叫者收到 AgoraRtmRemoteInvitationRefuseBlock 和 AgoraRtmCallDelegate.rtmCallKit(_:localInvitationRefused:withResponse:) 回调，code == AgoraRtmInvitationApiCallError.ok
    ///     - 被叫者收到 AgoraRtmCallDelegate.rtmCallKit(_:remoteInvitationRefused:) 回调
    /// - 失败：呼叫者收到 AgoraRtmRemoteInvitationRefuseBlock 回调，查看 AgoraRtmInvitationApiCallErrorCode 错误码
    ///
    /// - Parameters:
    ///   - remoteInvitation: AgoraRtmRemoteInvitation
    ///   - completion: AgoraRtmRemoteInvitationRefuseBlock 完成回调。查看 AgoraRtmInvitationApiCallErrorCode 错误码
    func refuse(_ remoteInvitation: AgoraRtmRemoteInvitation, completion: AgoraRtmRemoteInvitationRefuseBlock? = nil) {
        Agora.log(remoteInvitation)
        callKit.refuse(remoteInvitation) { [weak self] (code) in
            completion?(code)
            self?.refuseInvitationObserver.send(value: ((remoteInvitation), code))
        }
    }
}

// MARK: - AgoraRtmCallDelegate
extension AgoraRTMCallProxy: AgoraRtmCallDelegate {
    
    /// 呼叫者的回调：当被叫者收到呼叫邀请时调用
    func rtmCallKit(_ callKit: AgoraRtmCallKit, localInvitationReceivedByPeer localInvitation: AgoraRtmLocalInvitation) {
        Agora.log(callKit, localInvitation)
        localInvitationReceivedObserver.send(value: (callKit, localInvitation))
    }
    
    /// 呼叫者的回调：当被叫者接受呼叫邀请时调用
    func rtmCallKit(_ callKit: AgoraRtmCallKit, localInvitationAccepted localInvitation: AgoraRtmLocalInvitation, withResponse response: String?) {
        Agora.log(callKit, localInvitation, response as Any)
        localInvitationAcceptedObserver.send(value: (callKit, localInvitation, response))
    }
    
    /// 呼叫者的回调：当被叫者拒绝呼叫邀请时调用
    func rtmCallKit(_ callKit: AgoraRtmCallKit, localInvitationRefused localInvitation: AgoraRtmLocalInvitation, withResponse response: String?) {
        Agora.log(callKit, localInvitation, response as Any)
        localInvitationRefusedObserver.send(value: (callKit, localInvitation, response))
    }
    
    /// 呼叫者的回调：当被叫者取消呼叫邀请时调用
    func rtmCallKit(_ callKit: AgoraRtmCallKit, localInvitationCanceled localInvitation: AgoraRtmLocalInvitation) {
        Agora.log(callKit, localInvitation)
        localInvitationCanceledObserver.send(value: (callKit, localInvitation))
    }
    
    /// 呼叫者的回调：当发出的呼叫邀请的生命周期以失败而结束时调用
    func rtmCallKit(_ callKit: AgoraRtmCallKit, localInvitationFailure localInvitation: AgoraRtmLocalInvitation, errorCode: AgoraRtmLocalInvitationErrorCode) {
        Agora.log(callKit, localInvitation, errorCode, errorCode.rawValue)
        localInvitationFailureObserver.send(value: (callKit, localInvitation, errorCode))
    }
    
    /// 被叫者的回调：当被叫者收到呼叫邀请时调用
    func rtmCallKit(_ callKit: AgoraRtmCallKit, remoteInvitationReceived remoteInvitation: AgoraRtmRemoteInvitation) {
        Agora.log(callKit, remoteInvitation)
        remoteInvitationReceivedObserver.send(value: (callKit, remoteInvitation))
    }
    
    /// 被叫者的回调：当被叫者拒绝呼叫邀请时调用
    func rtmCallKit(_ callKit: AgoraRtmCallKit, remoteInvitationRefused remoteInvitation: AgoraRtmRemoteInvitation) {
        Agora.log(callKit, remoteInvitation)
        remoteInvitationRefusedObserver.send(value: (callKit, remoteInvitation))
    }
    
    /// 被叫者的回调：当被叫者接受呼叫邀请时调用
    func rtmCallKit(_ callKit: AgoraRtmCallKit, remoteInvitationAccepted remoteInvitation: AgoraRtmRemoteInvitation) {
        Agora.log(callKit, remoteInvitation)
        remoteInvitationAcceptedObserver.send(value: (callKit, remoteInvitation))
    }
    
    /// 被叫者的回调：当被叫者取消呼叫邀请时调用
    func rtmCallKit(_ callKit: AgoraRtmCallKit, remoteInvitationCanceled remoteInvitation: AgoraRtmRemoteInvitation) {
        Agora.log(callKit, remoteInvitation)
        remoteInvitationCanceledObserver.send(value: (callKit, remoteInvitation))
    }
    
    /// 被叫者的回调：当收到的呼叫邀请的生命周期以失败而结束时调用
    func rtmCallKit(_ callKit: AgoraRtmCallKit, remoteInvitationFailure remoteInvitation: AgoraRtmRemoteInvitation, errorCode: AgoraRtmRemoteInvitationErrorCode) {
        Agora.log(callKit, remoteInvitation, errorCode, errorCode.rawValue)
        remoteInvitationFailureObserver.send(value: (callKit, remoteInvitation, errorCode))
    }
}
