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
    
    /// 创建 AgoraRtmKit Proxy
    ///
    /// - Parameter delegate: AgoraRtmDelegate，如果为nil，则默认代理为自己
    convenience init(delegate: AgoraRtmDelegate? = nil) {
        self.init()  
        rtmKit = AgoraRtmKit(appId: agoraAppID, delegate: delegate ?? self)
    }
    
    /// AgoraRtmKit 是RTM的入口。RTM 支持多个 AgoraRtmKit，AgoraRtmKit 中的所有方法都是异步的（除了 AgoraRtmKit.destroyChannel(withId: ) 方法）
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
    
    // MARK: - Method CallBack Signal
    
    /// 登录方法 信号量
    ///
    /// func login(byToken token: String? = nil, user userId: String, completion: AgoraRtmLoginBlock? = nil)
    let (loginSignal, loginObserver) = Signal<((String?, String), AgoraRtmLoginErrorCode), Never>.pipe()
    
    /// 登出方法 信号量
    ///
    /// func logout(completion: AgoraRtmLogoutBlock? = nil)
    let (logoutSignal, logoutObserver) = Signal<AgoraRtmLogoutErrorCode, Never>.pipe()
    
    /// 重新生成token方法 信号量
    ///
    /// func renewToken(_ token: String, completion: AgoraRtmRenewTokenBlock? = nil)
    let (renewTokenSignal, renewTokenObserver) = Signal<(String?, AgoraRtmRenewTokenErrorCode), Never>.pipe()
    
    /// 发送消息方法 信号量
    ///
    /// func send(_ message: AgoraRtmMessage, toPeer: String, options: AgoraRtmSendMessageOptions, completion: AgoraRtmSendPeerMessageBlock? = nil)
    ///
    /// func send(_ message: AgoraRtmMessage, toPeer: String, completion: AgoraRtmSendPeerMessageBlock? = nil)
    let (sendMsgSignal, sendMsgObserver) = Signal<((AgoraRtmMessage, String, AgoraRtmSendMessageOptions?), AgoraRtmSendPeerMessageErrorCode), Never>.pipe()
    
    /// 销毁频道方法 信号量
    ///
    /// func destroyChannelWithId(_ channelId: String) -> Bool
    let (destroyChannelSignal, destroyChannelObserver) = Signal<((String), Bool), Never>.pipe()
    
    /// 查询在线用户方法 信号量
    ///
    /// func queryPeersOnlineStatus(peerIds: [String], completion: AgoraRtmQueryPeersOnlineBlock? = nil)
    let (queryPeersOnlineStatusSignal, queryPeersOnlineStatusObserver) = Signal<(([String]), [AgoraRtmPeerOnlineStatus]?, AgoraRtmQueryPeersOnlineErrorCode), Never>.pipe()
    
    /// 设置本地用户属性方法 信号量
    ///
    /// func setLocalUserAttributes(_ attributes: [AgoraRtmAttribute]?, completion: AgoraRtmSetLocalUserAttributesBlock? = nil)
    let (setLocalUserAttributesSignal, setLocalUserAttributesObserver) = Signal<(([AgoraRtmAttribute]?), AgoraRtmProcessAttributeErrorCode), Never>.pipe()
    
    /// 添加或更新本地用户属性方法 信号量
    ///
    /// func addOrUpdateLocalUserAttributes(_ attributes: [AgoraRtmAttribute]?, completion: AgoraRtmAddOrUpdateLocalUserAttributesBlock? = nil)
    let (addOrUpdateLocalUserAttributesSignal, addOrUpdateLocalUserAttributesObserver) = Signal<(([AgoraRtmAttribute]?), AgoraRtmProcessAttributeErrorCode), Never>.pipe()
    
    /// 删除本地用户属性方法 信号量
    ///
    /// func deleteLocalUserAttributes(byKeys: [String]?, completion: AgoraRtmDeleteLocalUserAttributesBlock? = nil)
    let (deleteLocalUserAttributesSignal, deleteLocalUserAttributesObserver) = Signal<(([String]?), AgoraRtmProcessAttributeErrorCode), Never>.pipe()
    
    /// 清空本地用户属性方法 信号量
    ///
    /// func clearLocalUserAttributes(completion: AgoraRtmClearLocalUserAttributesBlock? = nil)
    let (clearLocalUserAttributesSignal, clearLocalUserAttributesObserver) = Signal<AgoraRtmProcessAttributeErrorCode, Never>.pipe()
    
    /// 获取用户所有属性方法 信号量
    ///
    /// func getUserAllAttributes(_ userId: String, completion: AgoraRtmGetUserAttributesBlock? = nil)
    let (getUserAllAttributesSignal, getUserAllAttributesObserver) = Signal<((String), [AgoraRtmAttribute]?, String?, AgoraRtmProcessAttributeErrorCode), Never>.pipe()
    
    /// 获取用户属性方法 信号量
    ///
    /// getUserAttributes(_ userId: String, byKeys: [String]?, completion: AgoraRtmGetUserAttributesBlock? = nil)
    let (getUserAttributesSignal, getUserAttributesObserver) = Signal<((String, [String]?), [AgoraRtmAttribute]?, String?, AgoraRtmProcessAttributeErrorCode), Never>.pipe()
    
    // MARK: - Delegate Signal
    
    /// 连接状态改变 代理方法信号量
    ///
    /// func rtmKit(_ kit: AgoraRtmKit, connectionStateChanged state: AgoraRtmConnectionState, reason: AgoraRtmConnectionChangeReason)
    let (connectionStateChangedSignal, connectionStateChangedObserver) = Signal<(AgoraRtmKit, AgoraRtmConnectionState, AgoraRtmConnectionChangeReason), Never>.pipe()
    
    /// 接受远端消息 代理方法信号量
    ///
    /// func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String)
    let (messageReceivedSignal, messageReceivedObserver) = Signal<(AgoraRtmKit, String), Never>.pipe()
    
    /// token失效 代理方法信号量
    ///
    /// func rtmKitTokenDidExpire(_ kit: AgoraRtmKit)
    let (tokenDidExpireSignal, tokenDidExpireObserver) = Signal<AgoraRtmKit, Never>.pipe()
}

// MARK: - Method Proxy
extension AgoraRTMProxy {
    
    /// 登录RTM系统
    ///
    /// **注意：** 如果您在不同实例中以相同用户ID登录，您将被踢出以前的登录并从以前连接的通道中移除
    ///
    /// 调用此方法后，本地用户会收到 AgoraRtmLoginBlock 和 AgoraRtmDelegate.rtmKit(_:connectionStateChanged:reason:) 回调，连接状态会转换为 AgoraRtmConnectionState.connecting
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
            completion?($0)
            self?.loginObserver.send(value: ((token, userId), $0))
        }
    }
    
    /// 登出RTM系统
    ///
    /// - 成功：本地用户会收到 AgoraRtmLogoutBlock 和 AgoraRtmDelegate.rtmKit(_:connectionStateChanged:reason:) 回调，连接状态会转换为 AgoraRtmConnectionState.disconnected
    /// - 失败：本地用户会收到 AgoraRtmLogoutBlock
    /// - Parameter completion: AgoraRtmLogoutBlock 完成回调。查看 AgoraRtmLogoutErrorCode 错误码
    func logout(completion: AgoraRtmLogoutBlock? = nil) {
        Agora.log()
        rtmKit.logout { [weak self] in
            completion?($0)
            self?.logoutObserver.send(value: $0)
        }
    }
    
    /// 重新生成token
    ///
    /// - Parameters:
    ///   - token: 新token
    ///   - completion: AgoraRtmLogoutBlock 完成回调。查看 AgoraRtmRenewTokenErrorCode 错误码
    func renewToken(_ token: String, completion: AgoraRtmRenewTokenBlock? = nil) {
        Agora.log(token)
        rtmKit.renewToken(token) { [weak self] (token, code) in
            completion?(token, code)
            self?.renewTokenObserver.send(value: (token, code))
        }
    }
    
    /// 给指定的用户发送P2P消息
    ///
    /// **注意：** 可以最多每秒发送60次P2P消息和频道消息
    ///
    /// - 成功：
    ///     - 本地会用户收到 AgoraRtmSendPeerMessageBlock 回调
    ///     - 指定的远端用户会收到 AgoraRtmDelegate.rtmKit(_:messageReceived:fromPeer:)) 回调
    ///
    /// - Parameters:
    ///   - message: 要发送的消息
    ///   - toPeer: 远端用户的ID
    ///   - options: 发送选项，目前仅支持离线选项
    ///   - completion: AgoraRtmSendPeerMessageBlock 完成回调。查看 AgoraRtmSendPeerMessageErrorCode 错误码
    func send(_ message: AgoraRtmMessage, toPeer: String, options: AgoraRtmSendMessageOptions, completion: AgoraRtmSendPeerMessageBlock? = nil) {
        Agora.log(message, toPeer, options)
        rtmKit.send(message, toPeer: toPeer, sendMessageOptions: options) { [weak self] (code) in
            completion?(code)
            self?.sendMsgObserver.send(value: ((message, toPeer, options), code))
        }
    }
    
    func send(_ message: AgoraRtmMessage, toPeer: String, completion: AgoraRtmSendPeerMessageBlock? = nil) {
        Agora.log(message, toPeer)
        rtmKit.send(message, toPeer: toPeer) { [weak self] (code) in
            completion?(code)
            self?.sendMsgObserver.send(value: ((message, toPeer, nil), code))
        }
    }
    
    /// 创建一个RTM 频道
    ///
    /// **注意：** 同一时间最多可以创建20个AgoraRtmChannel
    ///
    /// - Parameters:
    ///   - channelId: RTM中频道的唯一名字。字符串的长度必须小于64字节，可用的字符如下：26个英文字母（大小写都行）；数字0-9；空格；"!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ","
    ///   - delegate: AgoraRtmChannelDelegate
    /// - Returns: 成功时：返回AgoraRtmChannel；失败时：返回nil（可能的原因：channelId无效；已存在相同的channelId；频道数量超限）
    @discardableResult
    func createChannel(withId channelId: String, delegate: AgoraRtmChannelDelegate? = nil) -> AgoraRtmChannel? {
        Agora.log(channelId, delegate as Any)
        let channel = rtmKit.createChannel(withId: channelId, delegate: delegate)
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
            completion?(statuses, code)
            self?.queryPeersOnlineStatusObserver.send(value: ((peerIds), statuses, code))
        }
    }
}

// MARK: 定制方法(技术预览)
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
            completion?(code)
            self?.setLocalUserAttributesObserver.send(value: ((attributes), code))
        }
    }
    
    func addOrUpdateLocalUserAttributes(_ attributes: [AgoraRtmAttribute]?, completion: AgoraRtmAddOrUpdateLocalUserAttributesBlock? = nil) {
        Agora.log(attributes as Any)
        rtmKit.addOrUpdateLocalUserAttributes(attributes) { [weak self] (code) in
            completion?(code)
            self?.addOrUpdateLocalUserAttributesObserver.send(value: ((attributes), code))
        }
    }
    
    func deleteLocalUserAttributes(byKeys: [String]?, completion: AgoraRtmDeleteLocalUserAttributesBlock? = nil) {
        Agora.log(byKeys as Any)
        rtmKit.deleteLocalUserAttributes(byKeys: byKeys) { [weak self] (code) in
            completion?(code)
            self?.deleteLocalUserAttributesObserver.send(value: ((byKeys), code))
        }
    }
    
    func clearLocalUserAttributes(completion: AgoraRtmClearLocalUserAttributesBlock? = nil) {
        Agora.log()
        rtmKit.clearLocalUserAttributes { [weak self] (code) in
            completion?(code)
            self?.clearLocalUserAttributesObserver.send(value: code)
        }
    }
    
    func getUserAttributes(_ userId: String, byKeys: [String]?, completion: AgoraRtmGetUserAttributesBlock? = nil) {
        Agora.log(userId, byKeys as Any)
        rtmKit.getUserAttributes(userId, byKeys: byKeys) { [weak self] (attributes, userID, code) in
            completion?(attributes, userId, code)
            self?.getUserAttributesObserver.send(value: ((userId, byKeys), attributes, userID, code))
        }
    }
    
    func getUserAllAttributes(_ userId: String, completion: AgoraRtmGetUserAttributesBlock? = nil) {
        Agora.log(userId)
        rtmKit.getUserAllAttributes(userId) { (attributes, userID, code) in
            completion?(attributes, userId, code)
            self.getUserAllAttributesObserver.send(value: ((userId), attributes, userID, code))
        }
    }
}

// MARK: - AgoraRtmDelegate
extension AgoraRTMProxy: AgoraRtmDelegate {
    
    /// 当SDK与RTM系统之间的连接变化时调用
    func rtmKit(_ kit: AgoraRtmKit, connectionStateChanged state: AgoraRtmConnectionState, reason: AgoraRtmConnectionChangeReason) {
        Agora.log(kit, state, state.rawValue, reason, reason.rawValue)
        connectionStateChangedObserver.send(value: (kit, state, reason))
    }
    
    /// 本地用户收到p2p消息时调用
    ///
    /// - Parameters:
    ///   - peerId: 远端发送消息用户的ID
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        Agora.log(kit, message, peerId)
        messageReceivedObserver.send(value: (kit, peerId))
    }
    
    /// token过期时调用
    func rtmKitTokenDidExpire(_ kit: AgoraRtmKit) {
        Agora.log(kit)
        tokenDidExpireObserver.send(value: kit)
    }
}
