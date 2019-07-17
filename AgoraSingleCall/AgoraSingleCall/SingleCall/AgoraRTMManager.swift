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
//            if code == .ok {
//                self.connectionState = .connected
//            } else if code == .alreadyLogin {
//                self.connectionState = .connected
//            } else {
//                self.connectionState = .disconnected
//            }
        }
    }
    
    /// 检查对方是否在线
    func checkOnline(for userId: String, completion: @escaping ((Bool) -> Void)) {
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
        agoraRtmKit.send(AgoraRtmMessage(text: channel), toPeer: uid, completion: completion)
    }
    
    var receiveMessageClosure: ((AgoraRtmMessage, String) -> Void)?
    
    var connectionStateClosure: ((AgoraRtmConnectionState) -> Void)?
    
    var connectionState = AgoraRtmConnectionState.disconnected {
        didSet {
            if oldValue != connectionState {
                connectionStateClosure?(connectionState)
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
        }
    }
    
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        print(#function, message, peerId)
        
        receiveMessageClosure?(message, peerId)
    }
}
