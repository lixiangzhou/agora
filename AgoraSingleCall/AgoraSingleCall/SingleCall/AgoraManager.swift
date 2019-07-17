//
//  AgoraManager.swift
//  AgoraSingleCall
//
//  Created by Macbook Pro on 2019/7/16.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class AgoraManager {
    static let shared = AgoraManager()
    let appId = "b25c785c3d674b7990082d4855daa932"
    
    private init() {}
    
    func setup() {
        AgoraVideoCallManager.shared.setup()
        AgoraRTMManager.shared.setup()
    }
    
    var peerUsers = PeerUsers(local: "", remote: "")
    
    private(set) var window: UIWindow!
    let winWidth: CGFloat = 64
    let winHeight: CGFloat = 96
    let paddingX: CGFloat = 5
    let paddingY: CGFloat = 5
    let startPaddingX: CGFloat = 30
    let startPaddingY: CGFloat = 48
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    private var lastX: CGFloat?
    private var lastY: CGFloat?
    
    private(set) var callController: AgoraSingleCallController!
}

// MARK: -
extension AgoraManager {
    func presentCallController(_ controller: AgoraSingleCallController) {
        UIApplication.shared.keyWindow?.endEditing(true)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = .alert
        window.rootViewController = controller
        window.makeKeyAndVisible()
        let anim = CATransition()
        anim.duration = 0.3
        anim.type = .moveIn
        anim.subtype = .fromBottom
        window.layer.add(anim, forKey: nil)
        self.window = window
        callController = controller
    }
    
    func dismissCallControllerWithAnimation() {
        if window != nil {
            UIView.animate(withDuration: 1, animations: {
                self.window.alpha = 0
            }) { (_) in
                self.dismissCallController()
            }
        }
    }
    
    func dismissCallController() {
        if window != nil {
            window.resignKey()
            window.isHidden = true
            if let window = UIApplication.shared.delegate?.window {
                window?.makeKeyAndVisible()
            }
        }
        
        callController = nil
        window = nil
        lastX = nil
        lastY = nil
    }
    
    func minimize() {
        var x = screenWidth - winWidth - startPaddingX
        var y = startPaddingY
        if let lastX = lastX, let lastY = lastY {
            x = lastX
            y = lastY
        } else {
            let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction))
            pan.maximumNumberOfTouches = 1
            window.addGestureRecognizer(pan)
            
            window.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureAction)))
        }
        
        for ges in window.gestureRecognizers! {
            ges.isEnabled = true
        }
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        UIView.animate(withDuration: 0.25, animations: {
            self.window.frame = CGRect(x: x, y: y, width: self.winWidth, height: self.winHeight)
        }) { (_) in
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    /// 检查对方是否在线，在线就请求一起加入channel
    func checkOnlineAndCall(to user: String) {
        print("检查对方是否在线")
        AgoraRTMManager.shared.checkOnline(for: user) { (online) in
            if online {
                print("对方在线，开始进入呼叫模式")
                AgoraVideoCallManager.shared.callStatus = .dialing
                AgoraManager.shared.presentCallController(AgoraSingleCallController())
                print("自己加入channel")
                AgoraVideoCallManager.shared.joinChannel(account: user, channel: randomString(), success: { (channel) in
                    print("自己加入成功，请求对方加入channel，开始发送请求消息")
                    AgoraRTMManager.shared.askToJoinChannel(user, channel: channel, completion: { (code) in
                        if code == .ok {
                            print("请求消息，发送成功，等待自己进入对话模式")
                        } else {
                            print("请求消息，发送失败，自己进入挂断模式")
                            AgoraVideoCallManager.shared.callStatus = .hangupUnNormal
                            AgoraVideoCallManager.shared.callStatus = .idle
                        }
                    })
                })
            } else {
                print("对方不在线")
            }
        }
    }
}

// MARK: - Action
extension AgoraManager {
    @objc private func panGestureAction(pan: UIPanGestureRecognizer) {
        if pan.state != .ended, pan.state != .failed {
            let location = pan.location(in: UIApplication.shared.windows.first!)
            
            var frame = window.frame
            frame.origin.x = location.x - frame.size.width / 2
            frame.origin.y = location.y - frame.size.height / 2
            
            if frame.origin.x < paddingX {
                frame.origin.x = paddingX
            }
            
            if frame.origin.y < paddingY {
                frame.origin.y = paddingY
            }
            
            if frame.maxX > screenWidth - paddingX {
                frame.origin.x = screenWidth - paddingX - winWidth
            }
            
            if frame.maxY > screenHeight - paddingY {
                frame.origin.y = screenHeight - paddingY - winHeight
            }
            
            window.frame = frame
        }
    }
    
    @objc private func tapGestureAction(pan: UITapGestureRecognizer) {
        for ges in window.gestureRecognizers! {
            ges.isEnabled = false
        }
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        UIView.animate(withDuration: 0.25, animations: {
            self.window.frame = UIScreen.main.bounds
            self.callController.toFull()
        }) { (_) in
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}

extension AgoraManager {
    /// 必须保证 local 和 remote 都有内容
    struct PeerUsers {
        let local: String
        let remote: String
    }
}
