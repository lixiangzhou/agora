//
//  ViewController.swift
//  ReactiveAgora
//
//  Created by lixiangzhou on 2019/7/18.
//  Copyright © 2019 LXZ. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import AgoraRtcEngineKit
import AgoraRtmKit

class ViewController: UIViewController {
    
    let rtmProxy = AgoraRTMProxy()
    let callProxy = AgoraRTMCallProxy()
    let rtcProxy = AgoraRTCEngineProxy(delegate: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        rtmProxy.rtmCallKit = callProxy.callKit
//        rtmProxy.login(user: "test")
        
        rtcProxy.reactive.signal(for: #selector(AgoraRTCEngineProxy.joinChannel(byToken:channelId:info:uid:joinSuccess:))).observeValues { (result) in
            print(result)
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let invitation = AgoraRtmLocalInvitation(calleeId: "KKKK")
//        invitation.channelId = "hahah"
////        invitation.content = "Content"
//        callProxy.callKit.send(invitation) { code in
//            print(code, code.rawValue)
//        }
        
        rtcProxy.joinChannel(byToken: "TOKEN", channelId: "CHANNELID", info: "INFO", uid: 111) { (channel, uid, elapsed) in
            print(channel, uid, elapsed)
        }
    }
}

