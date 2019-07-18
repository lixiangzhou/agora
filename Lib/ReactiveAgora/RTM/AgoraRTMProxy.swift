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
    
    var connectionStateChangedSignal: Signal<(AgoraRtmKit, AgoraRtmConnectionState, AgoraRtmConnectionChangeReason), Never>!
    var messageReceivedSignal: Signal<(AgoraRtmKit, String), Never>!
    var tokenDidExpireSignal: Signal<AgoraRtmKit, Never>!
}

extension AgoraRTMProxy {
    func setup() {
        rtmKit = AgoraRtmKit(appId: agoraAppID, delegate: self)
        
        binding()
    }
    
    func connectToSDK(byToken token: String? = nil, user userId: String) {
        Agora.log(token ?? "No Token", userId)
        login(byToken: token, user: userId)
    }
    
    /// 登录
    func login(byToken token: String?, user userId: String, completion: AgoraRtmLoginBlock? = nil) {
        Agora.log(token ?? "No Token", userId)
        rtmKit.login(byToken: token, user: userId, completion: completion)
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
