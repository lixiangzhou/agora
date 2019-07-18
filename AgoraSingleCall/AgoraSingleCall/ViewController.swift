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
    
        let string = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let data = string.data(using: .utf8)!
        print(string.count)
        print(data.count)
        print(NSData(data: data).length)
    }
    
    
    @IBAction func receiverLinkAction(_ sender: Any) {
        // 接受端：第一步：设置通话的用户名
        AgoraManager.shared.peerUsers = AgoraManager.PeerUsers(local: "1060", remote: "")
        // 接收端：连接到Agora
        AgoraRTMManager.shared.connectToSDK(user: AgoraManager.shared.peerUsers.local)
    }
    
    @IBAction func senderLinkAction(_ sender: Any) {
        // 发起端：第一步：设置通话的用户名
        AgoraManager.shared.peerUsers = AgoraManager.PeerUsers(local: "123", remote: "")
        // 发起端：第二步：开启通话
        AgoraManager.shared.startCall("1060")
    }
    
    @IBAction func senderLinkAction2(_ sender: Any) {
        // 发起端：第一步：设置通话的用户名
        AgoraManager.shared.peerUsers = AgoraManager.PeerUsers(local: "123", remote: "")
        // 发起端：第二步：开启通话
        AgoraManager.shared.startCall("1062")
    }
    
}
