//
//  ViewController.swift
//  AgoraSingleCall
//
//  Created by Macbook Pro on 2019/7/16.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func receiverLinkAction(_ sender: Any) {
        AgoraRTMManager.shared.connectToSDK(user: "ppp")
        AgoraRTMManager.shared.receiveMessageClosure = { msg, user in
            let agoraVC = AgoraSingleCallController()
            agoraVC.account = user
            agoraVC.channel = msg.text
            AgoraManager.shared.presentCallController(agoraVC)
        }
    }
    
    @IBAction func senderLinkAction(_ sender: Any) {
        let user = "ddd"
        let toUser = "ppp"
        
        if AgoraRTMManager.shared.connectionState == .connected {
            print("目前连接状态")
            AgoraManager.shared.checkOnlineAndCall(to: toUser)
        } else {
            AgoraRTMManager.shared.connectToSDK(user: user)
            AgoraRTMManager.shared.connectionStateClosure = { (state) in
                if state == .connected {    // 连接成功
                    print("连接成功 connectionStateClosure", state.rawValue)
                    AgoraManager.shared.checkOnlineAndCall(to: toUser)
                } else {
                    print("连接失败，不能通知到对方加入 channel")
                }
            }
        }
    }
}

extension ViewController {
    func test() {
        //        AgoraManager.shared.presentCallController(AgoraSingleCallController())
        let user = "ddd"
        let toUser = "ppp"
        
        //        AgoraVideoCallManager.shared.prepare()
        //        AgoraVideoCallManager.shared.setLocalView(self.smallView, uid: self.uid)
        //        AgoraVideoCallManager.shared.rtcEngineFirstRemoteVideoDecodedOfUidClosure = { _, uid in
        //            AgoraVideoCallManager.shared.setRemoteView(self.fullView, uid: uid)
        //        }
        
        AgoraRTMManager.shared.connectToSDK(user: user)
        AgoraRTMManager.shared.connectionStateClosure = { (state) in
            if state == .connected {    // 连接成功，发起通话，开始响铃，加入 channel，通知对方加入 channel
                AgoraVideoCallManager.shared.callStatus = .dialing
                AgoraManager.shared.presentCallController(AgoraSingleCallController())
                
                AgoraVideoCallManager.shared.joinChannel(account: user, channel: randomString(), success: { (channel) in
                    AgoraRTMManager.shared.askToJoinChannel(toUser, channel: channel, completion: { (code) in
                        if code == .ok {
                            
                        } else {
                            
                        }
                    })
                })
            } else {
                // 连接失败，不能通知到对方加入 channel
            }
        }
    }
}
