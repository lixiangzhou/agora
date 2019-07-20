//
//  AgoraRTCEngineProxy.swift
//  ReactiveAgora
//
//  Created by lixiangzhou on 2019/7/20.
//Copyright © 2019 LXZ. All rights reserved.
//

import Foundation
import AgoraRtcEngineKit
import ReactiveSwift

class AgoraRTCEngineProxy: NSObject {
    
    /// 创建 AgoraRtcEngineKit Proxy
    ///
    /// - Parameter delegate: AgoraRtcEngineDelegate，如果为nil，则默认代理为自己
    convenience init(delegate: AgoraRtcEngineDelegate? = nil) {
        self.init()
        rtcEngineKit = AgoraRtcEngineKit.sharedEngine(withAppId: agoraAppID, delegate: delegate ?? self)
        
    }
    
    /// AgoraRtcEngineKit 提供了需要的所有方法，AgoraRtcEngineKit是SDK的基本接口类，一个AgoraRtcEngineKit只能使用一个AppID，如果需要修改AppID，先调用 destroy 方法释放当前实例，然后再调用 sharedEngine(withAppId:delegate:) 方法创建新的实例

    var rtcEngineKit: AgoraRtcEngineKit!
    
    // MARK: - Method CallBack Signal
    
    
    // MARK: - Delegate Signal
    
}

// MARK: - Method Proxy
extension AgoraRTCEngineProxy {
    
    /// 销毁RtcEngine实例，并释放SDK使用的所有资源。该方法对于偶尔进行视频、语音通话很有用，可以在不通话时为其他操作释放资源。一旦调用该方法，该实例的所有回调和代理都不会被调用。为了再次重启通信，调用 sharedEngine(withAppId:delegate:) 创建一个新的AgoraRtcEngineKit实例。**注意：在子线程调用改方法；该方法是同步的，不能在该SDK的回调中调用，否则会造成死锁**
    func destroy() {
        AgoraRtcEngineKit.destroy()
    }
    
    /// 设置频道配置文件
    ///
    /// SDK需要了解应用程序场景，以便设置适当的通道配置文件来应用不同的优化方法
    ///
    /// Agora原生SDK支持以下通道配置文件:
    /// - 通讯（Communication）
    /// - 直播（Live Broadcast）
    /// - 游戏（Gaming (for the Agora Gaming SDK only)）
    ///
    /// **注意：在相同频道的用户必须使用相同的频道配置文件；调用该方法前，销毁（destroy）当前引擎并创建一个新的引擎（sharedEngine(withAppId:delegate:)）；在用户加入该频道（joinChannel(byToken:channelId:info:uid:joinSuccess:)）前调用此方法，因为在频道被用户使用的时候不能配置频道配置文件；在Communication配置文件下，SDK只支持原始数据编码，不支持文本编码**
    ///
    /// - Parameter profile: 频道配置文件
    /// - Returns: 成功：0；失败：< 0
    func setChannelProfile(_ profile: AgoraChannelProfile) -> Int {
        let result = rtcEngineKit.setChannelProfile(profile)
        return Int(result)
    }
}


// MARK: - AgoraRtcEngineDelegate
extension AgoraRTCEngineProxy: AgoraRtcEngineDelegate {
    
}
