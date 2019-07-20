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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        rtmProxy.rtmCallKit = callProxy.callKit
        rtmProxy.login(user: "test")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let invitation = AgoraRtmLocalInvitation(calleeId: "KKKK")
        invitation.channelId = "hahah"
//        invitation.content = "Content"
        callProxy.callKit.send(invitation) { code in
            print(code, code.rawValue)
        }
    }
}

