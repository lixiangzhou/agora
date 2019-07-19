//
//  AgoraRTMChannelProxy.swift
//  ReactiveAgora
//
//  Created by lixiangzhou on 2019/7/19.
//  Copyright © 2019 LXZ. All rights reserved.
//

import Foundation
import AgoraRtmKit
import ReactiveSwift

class AgoraRTMChannelProxy: NSObject {
    
    /// 创建频道代理
    convenience init(channel: AgoraRtmChannel) {
        self.init()
        rtmChannel = channel
        rtmChannel.channelDelegate = self
    }
    
    private(set) var rtmChannel: AgoraRtmChannel!
    
    var rtmKit: AgoraRtmKit {
        return rtmChannel.kit
    }
    
    var channelDelegate: AgoraRtmChannelDelegate? {
        set { rtmChannel.channelDelegate = newValue }
        get { return rtmChannel.channelDelegate }
    }
    
    // MARK: - Delegate Signal
    
    /// 成员离开代理方法信号量
    let (memberLeftSignal, memberLeftObserver) = Signal<(AgoraRtmChannel, AgoraRtmMember), Never>.pipe()
    
    /// 成员加入代理方法信号量
    let (memberJoinedSignal, memberJoinedObserver) = Signal<(AgoraRtmChannel, AgoraRtmMember), Never>.pipe()
    
    /// 收到消息代理方法信号量
    let (messageReceivedSignal, messageReceivedObserver) = Signal<(AgoraRtmChannel, AgoraRtmMessage, AgoraRtmMember), Never>.pipe()
    
    // MARK: - Method CallBack Signal
    /// 加入频道方法回调信号量
    let (joinSignal, joinObserver) = Signal<AgoraRtmJoinChannelErrorCode, Never>.pipe()
    
    /// 离开频道方法回调信号量
    let (leaveSignal, leaveObserver) = Signal<AgoraRtmLeaveChannelErrorCode, Never>.pipe()
    
    /// 发送消息方法回调信号量
    let (sendMsgSignal, sendMsgObserver) = Signal<((AgoraRtmMessage), AgoraRtmSendChannelMessageErrorCode), Never>.pipe()
    
    /// 获取成员列表方法回调信号量
    let (getMembersSignal, getMembersObserver) = Signal<([AgoraRtmMember]?, AgoraRtmGetMembersErrorCode), Never>.pipe()
}

// MARK: - Method Proxy
extension AgoraRTMChannelProxy {
    /// 加入频道
    ///
    /// - 成功：
    ///     - 本地用户收到 AgoraRtmJoinChannelBlock 回调，code == AgoraRtmJoinChannelError.ok
    ///     - 所有远端用户收到 channel(_:memberJoined:) 回调【触发 memberJoinedSignal】
    /// - 失败：本地用户收到 AgoraRtmJoinChannelBlock 回调
    ///
    /// - Parameter completion: AgoraRtmJoinChannelBlock 完成回调，查看 AgoraRtmJoinChannelErrorCode 错误码
    func join(completion: AgoraRtmJoinChannelBlock? = nil) {
        Agora.log()
        rtmChannel.join { [weak self] (code) in
            self?.joinObserver.send(value: code)
            completion?(code)
        }
    }
    
    /// 离开频道
    ///
    /// - 成功：
    ///     - 本地用户收到 AgoraRtmLeaveChannelBlock 回调，code == AgoraRtmLeaveChannelError.ok
    ///     - 所有远端用户收到 channel(_:memberLeft:) 回调【触发 memberLeftSignal】
    /// - 失败：本地用户收到 AgoraRtmLeaveChannelBlock 回调
    /// - Parameter completion: AgoraRtmLeaveChannelBlock 完成回调，查看 AgoraRtmLeaveChannelErrorCode 错误码
    func leave(completion: AgoraRtmLeaveChannelBlock? = nil) {
        Agora.log()
        rtmChannel.leave { [weak self] (code) in
            self?.leaveObserver.send(value: code)
            completion?(code)
        }
    }
    
    /// 发送信息给频道的所有用户
    ///
    /// **注意：** 每秒最多发送60条频道消息
    /// - 成功：
    ///     - 本地用户收到 AgoraRtmSendChannelMessageBlock 回调，code == AgoraRtmSendChannelMessageError.ok
    ///     - 所有远端用户收到 channel(_:messageReceived:) 回调
    /// - 失败：本地用户收到 AgoraRtmSendChannelMessageBlock 回调
    ///
    /// - Parameters:
    ///   - message: 要发送的消息
    ///   - completion: AgoraRtmSendChannelMessageBlock 完成回调，查看 AgoraRtmSendChannelMessageErrorCode 错误码
    func send(_ message: AgoraRtmMessage, completion: AgoraRtmSendChannelMessageBlock? = nil) {
        Agora.log(message)
        rtmChannel.send(message) { [weak self] (code) in
            self?.sendMsgObserver.send(value: ((message), code))
            completion?(code)
        }
    }
    
    /// 获取频道内的成员列表
    ///
    /// - Parameter completion: AgoraRtmGetMembersBlock 完成回调，查看 AgoraRtmGetMembersErrorCode 错误码
    func getMembers(_ completion: AgoraRtmGetMembersBlock? = nil) {
        Agora.log()
        rtmChannel.getMembersWithCompletion { [weak self] (members, code) in
            self?.getMembersObserver.send(value: (members, code))
            completion?(members, code)
        }
    }
}

// MARK: - AgoraRtmChannelDelegate
extension AgoraRTMChannelProxy: AgoraRtmChannelDelegate {
    func channel(_ channel: AgoraRtmChannel, memberLeft member: AgoraRtmMember) {
        Agora.log(channel, member)
        memberLeftObserver.send(value: (channel, member))
    }
    
    func channel(_ channel: AgoraRtmChannel, memberJoined member: AgoraRtmMember) {
        Agora.log(channel, member)
        memberJoinedObserver.send(value: (channel, member))
    }
    
    func channel(_ channel: AgoraRtmChannel, messageReceived message: AgoraRtmMessage, from member: AgoraRtmMember) {
        Agora.log(channel, message, member)
        messageReceivedObserver.send(value: (channel, message, member))
    }
}
