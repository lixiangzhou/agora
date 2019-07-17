//
//  AgoraRTMManager.swift
//  AgoraSingleCall
//
//  Created by Macbook Pro on 2019/7/16.
//  Copyright © 2019 sphr. All rights reserved.
//

import Foundation
import AgoraRtmKit

class AgoraRTMManager: NSObject {
    
    static let shared = AgoraRTMManager()
    
    private var agoraRtmKit: AgoraRtmKit!
    
    func setup() {
        agoraRtmKit = AgoraRtmKit(appId: AgoraManager.shared.appId, delegate: self)
    }
    
    /// 连接用户user 到SDK
    func connectToSDK(byToken token: String? = nil, user userId: String) {
        login(byToken: token, user: userId) { (code) in
            print("login code", code.rawValue)
        }
    }
    
    /// 检查对方是否在线
    func checkOnline(for userId: String, completion: @escaping ((Bool) -> Void)) {
        AgoraManager.shared.role = .sender
        agoraRtmKit.queryPeersOnlineStatus([userId]) { (status, code) in
            if let status = status, code == .ok {
                for st in status {
                    if st.peerId == userId, st.isOnline {
                        completion(true)
                        return
                    }
                }
            }
            completion(false)
        }
    }
    
    /// 登录
    func login(byToken token: String?, user userId: String, completion: AgoraRtmLoginBlock? = nil) {
        agoraRtmKit.login(byToken: token, user: userId, completion: completion)
    }
    
    /// 登出
    func logout(completion: AgoraRtmLogoutBlock? = nil) {
        agoraRtmKit.logout(completion: completion)
    }
    
    /// 自己加入频道，并通知对方也加入相同的频道
    func askToJoinChannel(_ uid: String, channel: String, completion: ((AgoraRtmSendPeerMessageErrorCode) -> Void)? = nil) {
        AgoraManager.shared.role = .sender
        agoraRtmKit.send(AgoraRtmMessage(text: channel), toPeer: uid, completion: completion)
    }
    
    func askToLeaveChannel(_ uid: String, completion: ((AgoraRtmSendPeerMessageErrorCode) -> Void)? = nil) {
        AgoraManager.shared.role = .none
        agoraRtmKit.send(AgoraRtmMessage(text: ""), toPeer: uid, completion: completion)
    }
    
    var connectionState = AgoraRtmConnectionState.disconnected {
        didSet {
            if oldValue != connectionState {
                NotificationCenter.default.post(name: Notification.Name.YGXQ.RTMConnectionStateChanged, object: ConnectionStateBox(state: connectionState, remotePeer: AgoraManager.shared.peerUsers.remote))
            }
        }
    }
}

extension AgoraRTMManager: AgoraRtmDelegate {
    func rtmKit(_ kit: AgoraRtmKit, connectionStateChanged state: AgoraRtmConnectionState, reason: AgoraRtmConnectionChangeReason) {
        print(#function, state.rawValue, reason.rawValue)
        
        connectionState = state
        
        switch state {
        case .connected:
            break
        case .connecting:
            break
        case .disconnected:
            break
        case .reconnecting:
            break
        case .aborted:
            logout()
        @unknown default:
            break
        }
    }
    
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        print(#function, message, peerId)
        var peers = AgoraManager.shared.peerUsers
        peers.remote = peerId
        AgoraManager.shared.peerUsers = peers
        
        NotificationCenter.default.post(name: Notification.Name.YGXQ.DidReceiveMessage, object: MessageBox(message: message, remotePeer: peerId), userInfo: nil)
    }
}

extension AgoraRTMManager {
    struct MessageBox {
        let message: AgoraRtmMessage
        let remotePeer: String
        
        var isConnectMessage: Bool {
            return !channel.isEmpty
        }
        
        var isDisConnectMessage: Bool {
            return channel.isEmpty
        }
        
        var channel: String {
            return message.text
        }
    }
    
    struct ConnectionStateBox {
        let state: AgoraRtmConnectionState
        let remotePeer: String
    }
}


