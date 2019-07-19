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
    
        
        AgoraRTMManager.shared.addLocal(name: "MY NAME", portrait: "http://image.baidu.com/search/detail?ct=503316480&z=undefined&tn=baiduimagedetail&ipn=d&word=图标&step_word=&ie=utf-8&in=&cl=2&lm=-1&st=undefined&hd=undefined&latest=undefined&copyright=undefined&cs=129764643,3625725045&os=1795269128,411523297&simid=4034654014,800824514&pn=35&rn=1&di=32340&ln=1235&fr=&fmq=1563518909963_R&fm=&ic=undefined&s=undefined&se=&sme=&tab=0&width=undefined&height=undefined&face=undefined&is=0,0&istype=0&ist=&jit=&bdtype=0&spn=0&pi=0&gsm=0&objurl=http%3A%2F%2Fdpic.tiankong.com%2Fzk%2Fnh%2FQJ8122580525.jpg&rpstart=0&rpnum=0&adpicid=0&force=undefined")
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
