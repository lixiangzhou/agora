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
    
        // 发起端：第一步：设置通话的两端用户名
        AgoraManager.shared.peerUsers = AgoraManager.PeerUsers(local: "123", remote: "1062")
    }
    
    
    @IBAction func receiverLinkAction(_ sender: Any) {
        // 接收端：连接到Agora
        AgoraRTMManager.shared.connectToSDK(user: AgoraManager.shared.peerUsers.remote)
    }
    
    @IBAction func senderLinkAction(_ sender: Any) {
        // 发起端：第二步：开启通话
        AgoraManager.shared.startCall()
    }
}
