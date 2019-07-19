//
//  AgoraRTMProxy.swift
//  ReactiveAgora
//
//  Created by lixiangzhou on 2019/7/18.
//  Copyright © 2019 LXZ. All rights reserved.
//

import Foundation
import AgoraRtmKit
import ReactiveSwift

class AgoraRTMProxy: NSObject {
    
    /// RTM 支持多个 AgoraRtmKit，AgoraRtmKit 中的所有方法都是异步的（除了 destroyChannel(withId: ) 方法）
    private(set) var rtmKit: AgoraRtmKit!
    
    /// AgoraRtmCallKit
    var rtmCallKit: AgoraRtmCallKit? {
        set { rtmKit.rtmCallKit = newValue }
        get { return rtmKit.rtmCallKit }
    }
    
    /// AgoraRtmDelegate
    var agoraRtmDelegate: AgoraRtmDelegate? {
        set { rtmKit.agoraRtmDelegate = newValue }
        get { return rtmKit.agoraRtmDelegate }
    }
    
    // MARK: - Delegate Signal
    /// 连接状态改变代理方法回调信号量
    let (connectionStateChangedSignal, connectionStateChangedObserver) = Signal<(AgoraRtmKit, AgoraRtmConnectionState, AgoraRtmConnectionChangeReason), Never>.pipe()
    
    /// 接受远端消息代理方法回调信号量
    let (messageReceivedSignal, messageReceivedObserver) = Signal<(AgoraRtmKit, String), Never>.pipe()
    
    /// token失效代理方法回调信号量
    let (tokenDidExpireSignal, tokenDidExpireObserver) = Signal<AgoraRtmKit, Never>.pipe()
    
    // MARK: - Method CallBack Signal
    
    /// 登录方法回调信号量 <(token?, userId), AgoraRtmLoginErrorCode>
    let (loginSignal, loginObserver) = Signal<((String?, String), AgoraRtmLoginErrorCode), Never>.pipe()
    
    /// 登出方法回调信号量
    let (logoutSignal, logoutObserver) = Signal<AgoraRtmLogoutErrorCode, Never>.pipe()
    
    /// 重新生成token方法回调信号量 <token?, AgoraRtmRenewTokenErrorCode>
    let (renewTokenSignal, renewTokenObserver) = Signal<(String?, AgoraRtmRenewTokenErrorCode), Never>.pipe()
    
    /// 发送消息方法回调信号量 <(msg, userId, options?), AgoraRtmSendPeerMessageErrorCode>
    let (sendMsgSignal, sendMsgObserver) = Signal<((AgoraRtmMessage, String, AgoraRtmSendMessageOptions?), AgoraRtmSendPeerMessageErrorCode), Never>.pipe()
    
    /// 创建频道方法回调信号量 <(channelId, delegate), AgoraRtmChannel?>
    let (createChannelSignal, createChannelObserver) = Signal<((String, AgoraRtmChannelDelegate?), AgoraRtmChannel?), Never>.pipe()
    
    /// 销毁频道方法回调信号量 <(channelId), Bool>
    let (destroyChannelSignal, destroyChannelObserver) = Signal<((String), Bool), Never>.pipe()

    /// 查询在线用户方法回调信号量 <([userId]), [AgoraRtmPeerOnlineStatus]?, AgoraRtmQueryPeersOnlineErrorCode>
    let (queryPeersOnlineStatusSignal, queryPeersOnlineStatusObserver) = Signal<(([String]), [AgoraRtmPeerOnlineStatus]?, AgoraRtmQueryPeersOnlineErrorCode), Never>.pipe()
    
    /// 设置本地用户属性方法回调信号量 <([attrs]), AgoraRtmProcessAttributeErrorCode>
    let (setLocalUserAttributesSignal, setLocalUserAttributesObserver) = Signal<(([AgoraRtmAttribute]?), AgoraRtmProcessAttributeErrorCode), Never>.pipe()
    
    /// 添加或更新本地用户属性方法回调信号量 <([attrs]), AgoraRtmProcessAttributeErrorCode>
    let (addOrUpdateLocalUserAttributesSignal, addOrUpdateLocalUserAttributesObserver) = Signal<(([AgoraRtmAttribute]?), AgoraRtmProcessAttributeErrorCode), Never>.pipe()
    
    /// 删除本地用户属性方法回调信号量 <([keys]?), AgoraRtmProcessAttributeErrorCode>
    let (deleteLocalUserAttributesSignal, deleteLocalUserAttributesObserver) = Signal<(([String]?), AgoraRtmProcessAttributeErrorCode), Never>.pipe()
    
    /// 清空本地用户属性方法回调信号量
    let (clearLocalUserAttributesSignal, clearLocalUserAttributesObserver) = Signal<AgoraRtmProcessAttributeErrorCode, Never>.pipe()
    
    /// 获取用户所有属性方法回调信号量 <(userId), [attrs]?, userID?, AgoraRtmProcessAttributeErrorCode>
    let (getUserAllAttributesSignal, getUserAllAttributesObserver) = Signal<((String), [AgoraRtmAttribute]?, String?, AgoraRtmProcessAttributeErrorCode), Never>.pipe()
    
    /// 获取用户属性方法回调信号量 <(userId, keys), [attrs]?, userID?, AgoraRtmProcessAttributeErrorCode>
    let (getUserAttributesSignal, getUserAttributesObserver) = Signal<((String, [String]?), [AgoraRtmAttribute]?, String?, AgoraRtmProcessAttributeErrorCode), Never>.pipe()
}

extension AgoraRTMProxy {
    func setup() {
        rtmKit = AgoraRtmKit(appId: agoraAppID, delegate: self)
    }
}

extension AgoraRTMProxy {
    
    /// 登录RTM系统
    ///
    /// **注意：** 如果您在不同实例中以相同用户ID登录，您将被踢出以前的登录并从以前连接的通道中移除
    ///
    /// 调用此方法后，本地用户会收到 AgoraRtmLoginBlock 和 rtmKit(_:connectionStateChanged:reason:) 回调【触发 loginSignal 和 connectionStateChangedSignal】，连接状态会转换为 AgoraRtmConnectionState.connecting
    ///
    /// - 成功：连接状态会转换为 AgoraRtmConnectionState.connected
    /// - 失败：连接状态会转换为 AgoraRtmConnectionState.disconnected
    ///
    /// - Parameters:
    ///   - token: app 服务端生成，用于登录RTM系统，当动态身份验证开启时token可用。在集成和测试时设置为nil
    ///   - user: 登录RTM系统的用户ID，字符串的长度必须小于64字节，可用的字符如下：26个英文字母（大小写都行）；数字0-9；空格；"!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ","。**注意：**不能设置userId为nil，也不能以空格开头
    ///
    ///
    ///   - completion: AgoraRtmLoginBlock 完成回调。查看 AgoraRtmLoginErrorCode 错误码
    func login(byToken token: String? = nil, user userId: String, completion: AgoraRtmLoginBlock? = nil) {
        Agora.log(token ?? "No Token", userId)
        
        rtmKit.login(byToken: token, user: userId) { [weak self] in
            self?.loginObserver.send(value: ((token, userId), $0))
            completion?($0)
        }
    }
    
    /// 登出RTM系统
    ///
    /// - 成功：本地用户会收到 AgoraRtmLogoutBlock 和 rtmKit(_:connectionStateChanged:reason:) 回调【触发 logoutSignal 和 connectionStateChangedSignal】，连接状态会转换为 AgoraRtmConnectionState.disconnected
    /// - 失败：本地用户会收到 AgoraRtmLogoutBlock 【触发 logoutSignal】
    /// - Parameter completion: AgoraRtmLogoutBlock 完成回调。查看 AgoraRtmLogoutErrorCode 错误码
    func logout(completion: AgoraRtmLogoutBlock? = nil) {
        Agora.log()
        rtmKit.logout { [weak self] in
            self?.logoutObserver.send(value: $0)
            completion?($0)
        }
    }
    
    /// 重新生成token
    ///
    /// AgoraRtmRenewTokenBlock 完成回调会触发 renewTokenSignal
    ///
    /// - Parameters:
    ///   - token: 新token
    ///   - completion: AgoraRtmLogoutBlock 完成回调。查看 AgoraRtmRenewTokenErrorCode 错误码
    func renewToken(_ token: String, completion: AgoraRtmRenewTokenBlock? = nil) {
        Agora.log(token)
        rtmKit.renewToken(token) { [weak self] (token, code) in
            self?.renewTokenObserver.send(value: (token, code))
            completion?(token, code)
        }
    }
    
    /// 给指定的用户发送P2P消息
    ///
    /// **注意：** 可以最多每秒发送60次P2P消息和channel消息
    ///
    /// - 成功：
    ///     - 本地会用户收到 AgoraRtmSendPeerMessageBlock 回调
    ///     - 指定的远端用户会收到 rtmKit(_:messageReceived:fromPeer:)) 回调【触发 messageReceivedSignal】
    ///
    /// - Parameters:
    ///   - message: 要发送的消息
    ///   - toPeer: 远端用户的ID
    ///   - options: 发送选项，目前仅支持离线选项
    ///   - completion: AgoraRtmSendPeerMessageBlock 完成回调。查看 AgoraRtmSendPeerMessageErrorCode 错误码
    func send(_ message: AgoraRtmMessage, toPeer: String, options: AgoraRtmSendMessageOptions, completion: AgoraRtmSendPeerMessageBlock? = nil) {
        Agora.log(message, toPeer, options)
        rtmKit.send(message, toPeer: toPeer, sendMessageOptions: options) { [weak self] (code) in
            self?.sendMsgObserver.send(value: ((message, toPeer, options), code))
            completion?(code)
        }
    }
    
    func send(_ message: AgoraRtmMessage, toPeer: String, completion: AgoraRtmSendPeerMessageBlock? = nil) {
        Agora.log(message, toPeer)
        rtmKit.send(message, toPeer: toPeer) { [weak self] (code) in
            self?.sendMsgObserver.send(value: ((message, toPeer, nil), code))
            completion?(code)
        }
    }
    
    /// 创建一个RTM 频道
    ///
    /// **注意：** 同一时间最多可以创建20个AgoraRtmChannel
    ///
    /// - Parameters:
    ///   - channelId: RTM中频道的唯一名字。字符串的长度必须小于64字节，可用的字符如下：26个英文字母（大小写都行）；数字0-9；空格；"!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ","。**注意：**不能设置userId为nil，也不能以空格开头
    ///   - delegate: AgoraRtmChannelDelegate
    /// - Returns: 成功时：返回AgoraRtmChannel；失败时：返回nil（可能的原因：channelId无效；已存在相同的channelId；频道数量超限）
    func createChannel(withId channelId: String, delegate: AgoraRtmChannelDelegate?) -> AgoraRtmChannel? {
        Agora.log(channelId, delegate as Any)
        let channel = rtmKit.createChannel(withId: channelId, delegate: delegate)
        createChannelObserver.send(value: ((channelId, delegate), channel))
        return channel
    }
    
    /// 销毁AgoraRtmChannel
    ///
    /// **注意：** 不要在任何回调用调用
    ///
    /// - Parameter channelId: 频道的ID
    /// - Returns: 是否成功销毁
    func destroyChannelWithId(_ channelId: String) -> Bool {
        Agora.log(channelId)
        let result = rtmKit.destroyChannel(withId: channelId)
        destroyChannelObserver.send(value: ((channelId), result))
        return result
    }
    
    /// 查询指定的用户是否在线
    ///
    /// - Parameters:
    ///   - peerIds: 用户ID
    ///   - completion: AgoraRtmQueryPeersOnlineBlock 完成回调。 查看 AgoraRtmQueryPeersOnlineErrorCode 错误码
    func queryPeersOnlineStatus(peerIds: [String], completion: AgoraRtmQueryPeersOnlineBlock? = nil) {
        Agora.log(peerIds)
        rtmKit.queryPeersOnlineStatus(peerIds) { [weak self] (statuses, code) in
            self?.queryPeersOnlineStatusObserver.send(value: ((peerIds), statuses, code))
            completion?(statuses, code)
        }
    }
}


// MARK: - 定制方法(技术预览)
/// 通过使用JSON选项配置SDK，提供技术预览功能或特殊定制
/// **注意：**
extension AgoraRTMProxy {
    func setParameters(_ parameters: String) {
        Agora.log(parameters)
        rtmKit.setParameters(parameters)
    }
    
    func setLocalUserAttributes(_ attributes: [AgoraRtmAttribute]?, completion: AgoraRtmSetLocalUserAttributesBlock? = nil) {
        Agora.log(attributes as Any)
        rtmKit.setLocalUserAttributes(attributes) { [weak self] (code) in
            self?.setLocalUserAttributesObserver.send(value: ((attributes), code))
            completion?(code)
        }
    }
    
    func addOrUpdateLocalUserAttributes(_ attributes: [AgoraRtmAttribute]?, completion: AgoraRtmAddOrUpdateLocalUserAttributesBlock? = nil) {
        Agora.log(attributes as Any)
        rtmKit.addOrUpdateLocalUserAttributes(attributes) { [weak self] (code) in
            self?.addOrUpdateLocalUserAttributesObserver.send(value: ((attributes), code))
            completion?(code)
        }
    }
    
    func deleteLocalUserAttributes(byKeys: [String]?, completion: AgoraRtmDeleteLocalUserAttributesBlock? = nil) {
        Agora.log(byKeys as Any)
        rtmKit.deleteLocalUserAttributes(byKeys: byKeys) { [weak self] (code) in
            self?.deleteLocalUserAttributesObserver.send(value: ((byKeys), code))
            completion?(code)
        }
    }
    
    func clearLocalUserAttributes(completion: AgoraRtmClearLocalUserAttributesBlock? = nil) {
        Agora.log()
        rtmKit.clearLocalUserAttributes { [weak self] (code) in
            self?.clearLocalUserAttributesObserver.send(value: code)
            completion?(code)
        }
    }
    
    func getUserAttributes(_ userId: String, byKeys: [String]?, completion: AgoraRtmGetUserAttributesBlock? = nil) {
        Agora.log(userId, byKeys as Any)
        rtmKit.getUserAttributes(userId, byKeys: byKeys) { [weak self] (attributes, userID, code) in
            self?.getUserAttributesObserver.send(value: ((userId, byKeys), attributes, userID, code))
            completion?(attributes, userId, code)
        }
    }
    
    func getUserAllAttributes(_ userId: String, completion: AgoraRtmGetUserAttributesBlock? = nil) {
        Agora.log(userId)
        rtmKit.getUserAllAttributes(userId) { (attributes, userID, code) in
            self.getUserAllAttributesObserver.send(value: ((userId), attributes, userID, code))
            completion?(attributes, userId, code)
        }
    }
}

extension AgoraRTMProxy: AgoraRtmDelegate {
    func rtmKit(_ kit: AgoraRtmKit, connectionStateChanged state: AgoraRtmConnectionState, reason: AgoraRtmConnectionChangeReason) {
        Agora.log(kit, state.rawValue, reason.rawValue)
        connectionStateChangedObserver.send(value: (kit, state, reason))
    }
    
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        Agora.log(kit, message, peerId)
        messageReceivedObserver.send(value: (kit, peerId))
    }
    
    func rtmKitTokenDidExpire(_ kit: AgoraRtmKit) {
        Agora.log(kit)
        tokenDidExpireObserver.send(value: kit)
    }
}
