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
    
        NotificationCenter.default.addObserver(forName: Notification.Name.YGXQ.DidReceiveMessage, object: nil, queue: nil) { (note) in
            if let box = note.object as? AgoraRTMManager.MessageBox {
                if box.isConnectMessage {
                    AgoraVideoCallManager.shared.callStatus = .incoming
                    let agoraVC = AgoraSingleCallController()
                    agoraVC.account = box.remotePeer
                    agoraVC.channel = box.channel
                    AgoraManager.shared.presentCallController(agoraVC)
                }
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.YGXQ.RTMConnectionStateChanged, object: nil, queue: nil) { (note) in
            if let box = note.object as? AgoraRTMManager.ConnectionStateBox {
                if box.state == .connected {    // 连接成功
                    print("连接成功 ", box.state.rawValue)
                    AgoraManager.shared.checkOnlineAndCall(to: box.remotePeer)
                } else {
                    print("连接失败，不能通知到对方加入 channel")
                }
            }
        }
        
        AgoraManager.shared.peerUsers = AgoraManager.PeerUsers(local: "123", remote: "1062")
    }
    
    
    @IBAction func receiverLinkAction(_ sender: Any) {
        AgoraRTMManager.shared.connectToSDK(user: AgoraManager.shared.peerUsers.remote)
    }
    
    @IBAction func senderLinkAction(_ sender: Any) {
        if AgoraRTMManager.shared.connectionState == .connected {
            print("目前连接状态")
            AgoraManager.shared.checkOnlineAndCall(to: AgoraManager.shared.peerUsers.remote)
        } else {
            AgoraRTMManager.shared.connectToSDK(user: AgoraManager.shared.peerUsers.local)
        }
    }
}
