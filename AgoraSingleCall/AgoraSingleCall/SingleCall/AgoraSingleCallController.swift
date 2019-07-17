//
//  AgoraSingleCallController.swift
//  AgoraSingleCall
//
//  Created by Macbook Pro on 2019/7/16.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit
import AgoraRtcEngineKit
import AgoraRtmKit

class AgoraSingleCallController: UIViewController {
    
    // MARK: - Life Cycle
    
    var localViewId: UInt = 10
    var remoteViewId: UInt = 20
    
    var account: String = ""
    var channel: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "0x262e42")
        setUI()
        addObservers()
    }
    
    deinit {
        removeObservers()
        print("AgoraSingleCallController deinit")
    }
    
    // MARK: - Public Property
    
    // MARK: - Private Property
    /// 背景
    private let fullBgView = UIView()
    /// 全屏大视频
    private let fullView = UIView()
    private let topView = UIView()
    private let bottomView = UIView()
    
    /// 最小化
    private let minimizeBtn = UIButton()
    
    /// 小视频
    private let smallView = UIView()
    private let smallBtn = UIButton()
    
    /// 正在呼叫
    private let callingView = UIView()
    /// 正在被呼叫
    private let beCallView = UIView()
    /// 通话中
    private let callView = UIView()
    
    /// 头像和状态
    let portraitView = AgoraPortartView()
    
    /// 名称和时间
    let nameTimeView = AgoraNameTimeView()
    
    
    /// 是否调换 local 和 remote View
    private var hasSwitchedView = false
}

// MARK: - UI
extension AgoraSingleCallController {
    private func setUI() {
        setViews()
        setInitialState()
    }
    
    func setInitialState() {
        if AgoraVideoCallManager.shared.callStatus == .dialing {
            showDialing()
        } else if AgoraVideoCallManager.shared.callStatus == .incoming {
            showIncoming()
        }
    }
    
    func setViews() {
        minimizeBtn.setImage(UIImage(named: "minimize"), for: .normal)
        minimizeBtn.setImage(UIImage(named: "minimize"), for: .highlighted)
        minimizeBtn.addTarget(self, action: #selector(minimizeAction), for: .touchUpInside)
        minimizeBtn.frame = CGRect(x: 12, y: 12, width: 65, height: 65)
        
        resetSmallViewPosition()
        
        smallBtn.backgroundColor = .clear
        smallBtn.addTarget(self, action: #selector(smallAction), for: .touchUpInside)
        smallView.layer.borderColor = UIColor.white.cgColor
        smallView.layer.borderWidth = 2
        smallView.layer.cornerRadius = 3
        smallView.layer.masksToBounds = true
        
        let bottomHeight: CGFloat = 200
        
        fullBgView.frame = view.bounds
        fullView.frame = view.bounds
        topView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - bottomHeight)
        bottomView.frame = CGRect(x: 0, y: topView.frame.maxY, width: view.frame.width, height: bottomHeight)
        
        callView.frame = bottomView.bounds
        beCallView.frame = bottomView.bounds
        callingView.frame = bottomView.bounds
        
        
        fullBgView.backgroundColor = UIColor(hex: "0x262e42")
        fullView.backgroundColor = .clear
        topView.backgroundColor = .clear
        bottomView.backgroundColor = .clear
        
        
        var ntFrame = nameTimeView.frame
        let ntX = (view.frame.width - ntFrame.width) * 0.5
        let ntY: CGFloat = 50
        ntFrame.origin = CGPoint(x: ntX, y: ntY)
        nameTimeView.frame = ntFrame
        topView.addSubview(nameTimeView)
        
        var pFrame = portraitView.frame
        let pX = (view.frame.width - pFrame.width) * 0.5
        let pY: CGFloat = 100
        pFrame.origin = CGPoint(x: pX, y: pY)
        portraitView.frame = pFrame
        topView.addSubview(portraitView)
        
        setCallView()
        setCallingView()
        setBeCallView()
        
        bottomView.addSubview(callView)
        bottomView.addSubview(callingView)
        bottomView.addSubview(beCallView)
        
        callView.isHidden = true
        callingView.isHidden = true
        beCallView.isHidden = true
        
        fullBgView.addSubview(fullView)
        fullBgView.addSubview(topView)
        fullBgView.addSubview(bottomView)
        fullBgView.addSubview(minimizeBtn)
        
        view.addSubview(fullBgView)
        view.addSubview(smallView)
        view.addSubview(smallBtn)
    }
    
    private func setCallingView() {
        let hangupView = getButtonView(title: "挂断", image: "hang_up", hightImage: "hang_up_hover", action: #selector(hangupAction))
        hangupView.center = callingView.center
        callingView.addSubview(hangupView)
    }
    
    private func setBeCallView() {
        let paddingX: CGFloat = 30
        let hangupView = getButtonView(title: "挂断", image: "hang_up", hightImage: "hang_up_hover", action: #selector(hangupAction))
        var hangupFrame = hangupView.frame
        let hangupX = paddingX
        let hangupY = (beCallView.bounds.height - hangupView.bounds.height) * 0.5
        hangupFrame.origin = CGPoint(x: hangupX, y: hangupY)
        hangupView.frame = hangupFrame
        beCallView.addSubview(hangupView)
        
        let acceptView = getButtonView(title: "接听", image: "answer", hightImage: "answer_hover", action: #selector(acceptAction))
        var acceptFrame = acceptView.frame
        let acceptX: CGFloat = beCallView.bounds.width - acceptFrame.width - paddingX
        let acceptY = (beCallView.bounds.height - acceptView.bounds.height) * 0.5
        acceptFrame.origin = CGPoint(x: acceptX, y: acceptY)
        acceptView.frame = acceptFrame
        beCallView.addSubview(acceptView)
    }
    
    private func setCallView() {
        let paddingX: CGFloat = 30
        let muteView = getButtonView(title: "静音", image: "mute", hightImage: "mute_hover", selectImage: "mute_hover", action: #selector(muteAction))
        var muteFrame = muteView.frame
        let muteX = paddingX
        let muteY = (callView.bounds.height - muteView.bounds.height) * 0.5
        muteFrame.origin = CGPoint(x: muteX, y: muteY)
        muteView.frame = muteFrame
        callView.addSubview(muteView)
        
        let hangupView = getButtonView(title: "挂断", image: "hang_up", hightImage: "hang_up_hover", action: #selector(hangupAction))
        hangupView.center = callView.center
        callView.addSubview(hangupView)
        
        let cameraView = getButtonView(title: "摄像头", image: "camera", hightImage: "camera_hover", action: #selector(cameraAction))
        var cameraFrame = cameraView.frame
        let cameraX: CGFloat = callView.bounds.width - cameraFrame.width - paddingX
        let cameraY = (callView.bounds.height - cameraView.bounds.height) * 0.5
        cameraFrame.origin = CGPoint(x: cameraX, y: cameraY)
        cameraView.frame = cameraFrame
        callView.addSubview(cameraView)
    }
    
    private func showDialing() {
        AgoraAudioManager.shared.play()
        try? AVAudioSession.sharedInstance().setCategory(.playAndRecord)
        smallView.isHidden = true
        minimizeBtn.isHidden = true
        
        nameTimeView.isHidden = true
        
        portraitView.isHidden = false
        portraitView.statusLabel.text = "正在等待对方接受邀请..."
        portraitView.nameLabel.text = "AAA"
        
        AgoraVideoCallManager.shared.setLocalView(fullView, uid: localViewId)
        AgoraVideoCallManager.shared.setRemoteView(nil, uid: remoteViewId)
        
        
        
        beCallView.isHidden = true
        callView.isHidden = true
        callingView.isHidden = false
    }
    
    private func showIncoming() {
        AgoraAudioManager.shared.play()
        try? AVAudioSession.sharedInstance().setCategory(.soloAmbient)
        AgoraAudioManager.shared.triggerVibrate()
        smallView.isHidden = true
        minimizeBtn.isHidden = true
        
        nameTimeView.isHidden = true
        
        portraitView.isHidden = false
        portraitView.statusLabel.text = "邀请您进行视频聊天"
        portraitView.nameLabel.text = "AAA"
        
        AgoraVideoCallManager.shared.setLocalView(nil, uid: localViewId)
        AgoraVideoCallManager.shared.setRemoteView(nil, uid: remoteViewId)
        
        beCallView.isHidden = false
        callView.isHidden = true
        callingView.isHidden = true
    }
    
    private func showActive() {
        AgoraAudioManager.shared.stop()
        smallView.isHidden = false
        minimizeBtn.isHidden = false
        
        nameTimeView.isHidden = false
        
        portraitView.isHidden = true
        
        AgoraVideoCallManager.shared.prepare()
        AgoraVideoCallManager.shared.setLocalView(smallView, uid: localViewId)
        
        beCallView.isHidden = true
        callView.isHidden = false
        callingView.isHidden = true
    }
    
    private func resetSmallViewPosition() {
        let x = AgoraManager.shared.screenWidth - AgoraManager.shared.winWidth - AgoraManager.shared.startPaddingX
        let y = AgoraManager.shared.startPaddingY
        smallView.frame = CGRect(x: x, y: y, width: AgoraManager.shared.winWidth, height: AgoraManager.shared.winHeight)
        smallBtn.frame = smallView.frame
    }
    
    private func getButtonView(title: String, image: String, hightImage: String, selectImage: String? = nil, action: Selector) -> ButtonView {
        let view = ButtonView()
        view.button.setImage(UIImage(named: image), for: .normal)
        view.button.setImage(UIImage(named: hightImage), for: .highlighted)
        if let selectImage = selectImage {
            view.button.setImage(UIImage(named: selectImage), for: .selected)
        }
        view.titleLabel.text = title
        view.button.addTarget(self, action: action, for: .touchUpInside)
        return view
    }
}

// MARK: - Action
extension AgoraSingleCallController {
    @objc func hangupAction() {
        
        let hangupClosure = {
            AgoraVideoCallManager.shared.callStatus = .hangupNormal
            AgoraVideoCallManager.shared.callStatus = .idle
        }
        
        if AgoraVideoCallManager.shared.callStatus == .incoming || AgoraVideoCallManager.shared.callStatus == .dialing {
            let remoteUser = AgoraManager.shared.peerUsers.remote
            AgoraRTMManager.shared.askToLeaveChannel(remoteUser) { (code) in
                if code != .ok {
                    AgoraRTMManager.shared.askToLeaveChannel(remoteUser) { _ in
                        hangupClosure()
                    }
                } else {
                    hangupClosure()
                }
            }
        } else {
            hangupClosure()
        }
    }
    
    @objc func acceptAction() {
        AgoraVideoCallManager.shared.joinChannel(account: account, channel: channel) { [weak self] (_) in
            self?.showActive()
        }
    }
    
    @objc func muteAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        AgoraVideoCallManager.shared.setMute(isMute: sender.isSelected)
    }
    
    @objc func cameraAction() {
        AgoraVideoCallManager.shared.switchCamera()
    }
    
    @objc func minimizeAction() {
        smallBtn.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25) {
            self.fullBgView.isHidden = true
            self.smallView.frame = CGRect(x: 0, y: 0, width: 64, height: 96)
            self.smallBtn.frame = self.smallView.frame
        }
        AgoraManager.shared.minimize()
    }
    
    @objc func smallAction() {
        hasSwitchedView = !hasSwitchedView
        if hasSwitchedView {
            AgoraVideoCallManager.shared.setLocalView(self.fullView, uid: self.localViewId)
            AgoraVideoCallManager.shared.setRemoteView(self.smallView, uid: self.remoteViewId)
        } else {
            AgoraVideoCallManager.shared.setLocalView(self.smallView, uid: self.localViewId)
            AgoraVideoCallManager.shared.setRemoteView(self.fullView, uid: self.remoteViewId)
        }
    }
}

// MARK: - Observer
extension AgoraSingleCallController {
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(videoCallDurationChanged), name: Notification.Name.YGXQ.VideoCallDurationChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRegisteredLocalUser), name: Notification.Name.YGXQ.DidRegisteredLocalUser, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(firstRemoteVideoDecoded), name: Notification.Name.YGXQ.FirstRemoteVideoDecoded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(videoCallStatusChanged), name: Notification.Name.YGXQ.VideoCallStatusChanged, object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func videoCallDurationChanged(_ note: Notification) {
        if let duration = note.object as? Int {
            nameTimeView.timeLabel.text = duration.timeFormSec()
        }
    }
    
    @objc private func didRegisteredLocalUser(_ note: Notification) {
        if let uid = note.object as? UInt {
            localViewId = uid
        }
    }
    
    @objc private func firstRemoteVideoDecoded(_ note: Notification) {
        if let uid = note.object as? UInt {
            AgoraVideoCallManager.shared.setRemoteView(fullView, uid: uid)
            remoteViewId = uid
        }
    }
    
    @objc private func videoCallStatusChanged(_ note: Notification) {
        if let status = note.object as? AgoraCallStatus {
            if status == .hangupNormal || status == .hangupUnNormal {
                hangup()
            } else if status == .active {
                showActive()
            }
        }
    }
}

// MARK: - Other
extension AgoraSingleCallController {
    func toFull() {
        fullBgView.isHidden = false
        smallBtn.isUserInteractionEnabled = true
        self.resetSmallViewPosition()
    }
    
    func hangup() {
        AgoraVideoCallManager.shared.leaveChannel()
        AgoraAudioManager.shared.stop()
        AgoraManager.shared.dismissCallControllerWithAnimation()
    }
}
