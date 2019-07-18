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
    
    private var rtmKit: AgoraRtmKit!
    
    // MARK: - Delegate Signal
    /// 连接状态改变信号量
    var connectionStateChangedSignal: Signal<(AgoraRtmKit, AgoraRtmConnectionState, AgoraRtmConnectionChangeReason), Never>!
    /// 接受远端消息信号量
    var messageReceivedSignal: Signal<(AgoraRtmKit, String), Never>!
    /// token失效信号量
    var tokenDidExpireSignal: Signal<AgoraRtmKit, Never>!
    
    // MARK: - Method Block Signal
    /// 登录信号量
    let (loginSignal, loginObserver) = Signal<AgoraRtmLoginErrorCode, Never>.pipe()
    /// 登出信号量
    let (logoutSignal, logoutObserver) = Signal<AgoraRtmLogoutErrorCode, Never>.pipe()
    /// 重新生成token信号量 <token?, AgoraRtmRenewTokenErrorCode>
    let (renewTokenSignal, renewTokenObserver) = Signal<(String?, AgoraRtmRenewTokenErrorCode), Never>.pipe()
}

extension AgoraRTMProxy {
    func setup() {
        rtmKit = AgoraRtmKit(appId: agoraAppID, delegate: self)
        
        binding()
    }
    
    private func binding() {
        connectionStateChangedSignal = reactive
            .signal(for: #selector(rtmKit(_:connectionStateChanged:reason:)))
            .map { ($0[0] as! AgoraRtmKit, AgoraRtmConnectionState(rawValue: $0[1] as! Int)!, AgoraRtmConnectionChangeReason(rawValue: $0[2] as! Int)!) }
        
        messageReceivedSignal = reactive
            .signal(for: #selector(rtmKit(_:messageReceived:fromPeer:)))
            .map { ($0[0] as! AgoraRtmKit, $0[1] as! String) }
        
        tokenDidExpireSignal = reactive.signal(for: #selector(rtmKitTokenDidExpire(_:))).map { $0[0] as! AgoraRtmKit }
        
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
            self?.loginObserver.send(value: $0)
            completion?($0)
        }
    }
    
    /// 登出RTM系统
    ///
    /// - 成功：本地用户会收到 AgoraRtmLogoutBlock 和 rtmKit(_:connectionStateChanged:reason:) 回调【触发logoutSignal 和 connectionStateChangedSignal】，连接状态会转换为 AgoraRtmConnectionState.disconnected
    /// - 失败：本地用户会收到 AgoraRtmLogoutBlock 【触发logoutSignal】
    
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
        rtmKit.renewToken(token) { [weak self] (token, code) in
            self?.renewTokenObserver.send(value: (token, code))
            completion?(token, code)
        }
    }
    
    
    
}

extension AgoraRTMProxy: AgoraRtmDelegate {
    func rtmKit(_ kit: AgoraRtmKit, connectionStateChanged state: AgoraRtmConnectionState, reason: AgoraRtmConnectionChangeReason) {
        Agora.log(kit, state.rawValue, reason.rawValue)
    }
    
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        Agora.log(kit, message, peerId)
    }
    
    func rtmKitTokenDidExpire(_ kit: AgoraRtmKit) {
        Agora.log(kit)
    }
}
