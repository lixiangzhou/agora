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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        rtmProxy.setup()
        
        
        rtmProxy.connectToSDK(user: "hello")
        
        rtmProxy.connectionStateChangedSignal.observeValues { (kit, state, reason) in
            Agora.log("signal", kit, state, reason)
        }
    }
}

