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
    
    /// AgoraRtcEngineKit 提供了需要的所有方法，AgoraRtcEngineKit是SDK的基本接口类，一个AgoraRtcEngineKit只能使用一个AppID，如果需要修改AppID，先调用 destroy 方法释放当前实例，然后再调用 AgoraRtcEngineKit.sharedEngine(withAppId:delegate:) 方法创建新的实例

    var rtcEngineKit: AgoraRtcEngineKit!
    
    // MARK: - Method CallBack Signal
    
    
    // MARK: - Delegate Signal
    
}

// MARK: - Method Proxy
extension AgoraRTCEngineProxy {
    
    /// 销毁RtcEngine实例，并释放SDK使用的所有资源。该方法对于偶尔进行视频、语音通话很有用，可以在不通话时为其他操作释放资源。一旦调用该方法，该实例的所有回调和代理都不会被调用。为了再次重启通信，调用 AgoraRtcEngineKit.sharedEngine(withAppId:delegate:) 创建一个新的AgoraRtcEngineKit实例。**注意：在子线程调用改方法；该方法是同步的，不能在该SDK的回调中调用，否则会造成死锁**
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
    /// **注意：在相同频道的用户必须使用相同的频道配置文件；调用该方法前，销毁（destroy）当前引擎并创建一个新的引擎（AgoraRtcEngineKit.sharedEngine(withAppId:delegate:)）；在用户加入该频道（AgoraRtcEngineKit.joinChannel(byToken:channelId:info:uid:joinSuccess:)）前调用此方法，因为在频道被用户使用的时候不能配置频道配置文件；在Communication配置文件下，SDK只支持原始数据编码，不支持文本编码**
    ///
    /// - Parameter profile: 频道配置文件
    /// - Returns: 成功：0；失败：< 0
    func setChannelProfile(_ profile: AgoraChannelProfile) -> Int {
        let result = rtcEngineKit.setChannelProfile(profile)
        return Int(result)
    }
    
    /// 设置用户的角色
    ///
    /// 该方法只适合直播配置文件。在加入频道之前，设置用户的角色，如 host 或 audience (default)。此方法可用于在用户加入通道后切换用户角色。当用户在加入通道后切换用户角色时，成功的方法调用会触发以下回调:
    /// - 本地用户：AgoraRtcEngineDelegate.rtcEngine(_:didClientRoleChanged:newRole:)
    /// - 远端用户：AgoraRtcEngineDelegate.rtcEngine(_:didJoinedOfUid:elapsed:) 或者 AgoraRtcEngineDelegate.rtcEngine(_:didOfflineOfUid:reason:)
    ///
    /// - Parameter role: 用户的角色
    /// - Returns: 成功：0；失败：< 0
    func setClientRole(_ role: AgoraClientRole) -> Int {
        let result = rtcEngineKit.setClientRole(role)
        return Int(result)
    }
}


// MARK: - AgoraRtcEngineDelegate
extension AgoraRTCEngineProxy: AgoraRtcEngineDelegate {
    // MARK: - Core Delegate Methods
    
    /// 报告一个SDK运行时错误。多数情况下app可以忽略SDK报告的警告，因为SDK通常会修复该问题并恢复运行。
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        Agora.log(engine, warningCode, warningCode.rawValue)
    }
    
    /// 报告一个SDK运行时警告。多数情况下SDK不能修复该问题并恢复运行。SDK需要app采取措施或通知用户该问题。
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        Agora.log(engine, errorCode, errorCode.rawValue)
    }
    
    /// SDK执行了一个方法时调用
    func rtcEngine(_ engine: AgoraRtcEngineKit, didApiCallExecute error: Int, api: String, result: String) {
        Agora.log(engine, error, api, result)
    }
    
    /// 本地用户加入一个频道时调用
    ///
    /// - Parameters:
    ///   - channel: 频道名
    ///   - uid: 用户ID，如果调用 AgoraRtcEngineKit.joinChannel(byToken:channelId:info:uid:joinSuccess:) 时指定了UID，则返回该UID。如果调用 AgoraRtcEngineKit.joinChannel 方法时没有指定UID，服务器会自动生成一个UID返回
    ///   - elapsed: 用户调用 AgoraRtcEngineKit.joinChannel 到调用此方法所花的时间（毫秒）
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        Agora.log(engine, channel, uid, elapsed)
    }
    
    /// 本地用户重新加入一个频道时调用
    ///
    /// - Parameters:
    ///   - channel: 频道名
    ///   - uid: 用户ID，如果调用 AgoraRtcEngineKit.joinChannel(byToken:channelId:info:uid:joinSuccess:) 时指定了UID，则返回该UID。如果调用 joinChannel 方法时没有指定UID，服务器会自动生成一个UID返回
    ///   - elapsed: 重新连接成功所花的时间（毫秒）
    func rtcEngine(_ engine: AgoraRtcEngineKit, didRejoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        Agora.log(engine, channel, uid, elapsed)
    }
    
    /// 本地用户离开一个频道时调用。
    ///
    /// 当用户调用 leaveChannel(_:) 时，此回调会通知app一个用户离开了频道。
    ///
    /// 通过这个回调，app可以获取回调函数 AgoraRtcEngineDelegate.rtcEngine(_:audioQualityOfUid:quality:delay:lost:) 报告的调用持续时间和接收/传输数据的统计信息
    func rtcEngine(_ engine: AgoraRtcEngineKit, didLeaveChannelWith stats: AgoraChannelStats) {
        Agora.log(engine, stats)
    }
    
    /// 本地用户调用 AgoraRtcEngineKit.registerLocalUserAccount(_:appId:) 或 AgoraRtcEngineKit.joinChannel(byUserAccount:token:channelId:joinSuccess:) 成功时调用
    func rtcEngine(_ engine: AgoraRtcEngineKit, didRegisteredLocalUser userAccount: String, withUid uid: UInt) {
        Agora.log(engine, userAccount, uid)
    }
    
    /// 当一个远端用户加入了频道后，SDK获取到远端用户的UID和account缓存到表对象 userInfo 中，并触发此回调
    func rtcEngine(_ engine: AgoraRtcEngineKit, didUpdatedUserInfo userInfo: AgoraUserInfo, withUid uid: UInt) {
        Agora.log(engine, userInfo, uid)
    }
    
    /// 在本地用户加入频道并转换角色后 AgoraRtcEngineKit.setClientRole(_:) 会触发此方法【直播频道配置文件下】
    func rtcEngine(_ engine: AgoraRtcEngineKit, didClientRoleChanged oldRole: AgoraClientRole, newRole: AgoraClientRole) {
        Agora.log(engine, oldRole, newRole)
    }
    
    /// 当远程用户或主机加入通道时发生
    ///
    /// - 通讯配置文件：此回调通知app另一个用户加入了频道，如果其他用户已经在频道中，SDK也会通知app现有用户
    /// - 直播配置文件：此回调通知app一个主机加入了频道。如果其他主机已经在频道中，SDK也会通知app现有主机。声网建议限制主机数为17
    ///
    /// SDK 在以下情况下触发此回调：
    /// - 远端用户、主机通过调用 AgoraRtcEngineKit.joinChannel(byToken:channelId:info:uid:joinSuccess:) 加入频道时
    /// - 远端用户在加入频道后通过调用 AgoraRtcEngineKit.setClientRole(_:) 转换角色时
    /// - 远端用户、主机在网络中断重新加入频道时
    /// - 主机通过调用 AgoraRtcEngineKit.addInjectStreamUrl(_:config:) 往频道中注入一个在线媒体流时
    ///
    /// 直播配置文件：
    /// - 主机在另一个主机加入频道会收到此回调
    /// - 频道中的观众在另一个主机加入时会收到此回调
    /// - 当一个web应用加入频道时，在web应用发布流时SDK会触发此回调
    ///
    /// - Parameters:
    ///   - elapsed: 本地用户调用 AgoraRtcEngineKit.joinChannel 或 AgoraRtcEngineKit.setClientRole(_:) 到触发此方法所花的时间（毫秒）
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        Agora.log(engine, uid, elapsed)
    }
    
    /// 当远端用户(通讯)/主机(直播)离开频道时调用
    ///
    /// 用户离线有2个原因：
    /// - 离开频道：当用户/主机离开通道时，用户/主机发送一个告别消息。当接收到消息时，SDK假设用户/主机离开通道。
    /// - 掉线：当某段时间内(通信配置文件20秒，直播配置文件20秒)没有收到用户或主机的数据包时，SDK假设用户/主机掉线。不可靠的网络连接可能导致错误检测，因此Agora建议使用信令系统进行更可靠的脱机检测
    /// - Parameters:
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        Agora.log(engine, uid, reason, reason.rawValue)
    }
    
    /// 网络连接状态改变时调用
    func rtcEngine(_ engine: AgoraRtcEngineKit, connectionChangedTo state: AgoraConnectionStateType, reason: AgoraConnectionChangedReason) {
        Agora.log(engine, state, state.rawValue, reason, reason.rawValue)
    }
    
    /// 本地网络类型改变时调用
    func rtcEngine(_ engine: AgoraRtcEngineKit, networkTypeChangedTo type: AgoraNetworkType) {
        Agora.log(engine, type, type.rawValue)
    }
    
    /// 当SDK到服务器的连接中断10秒后，SDK无法重新连接到Agora的edge服务器时调用
    ///
    /// SDK在调用 AgoraRtcEngineKit.joinChannel 方法10秒后无法连接到服务器时触发这个回调，不管它是否在通道中。
    ///
    /// 与的区别：
    /// - SDK在成功加入频道后与服务器断开连接超过4秒时触发 AgoraRtcEngineDelegate.rtcEngineConnectionDidInterrupted(_:)
    /// - SDK在与服务器失去连接超过10秒时触发 AgoraRtcEngineDelegate.rtcEngineConnectionDidLost(_:) 回调，不管它是否加入频道
    ///
    /// 对于这两个回调，SDK都尝试重新连接到服务器，直到应用程序调用 AgoraRtcEngineKit.leaveChannel(_:)
    func rtcEngineConnectionDidLost(_ engine: AgoraRtcEngineKit) {
        Agora.log(engine)
    }
    
    
    /// 当token在30秒内过期时调用
    ///
    /// AgoraRtcEngineKit.joinChannel(byToken:channelId:info:uid:joinSuccess:) 中的 token 过期时，用户会离线，SDK在token过期前30秒触发这个回调，提醒app获得一个新的token。秒触发这个回调，提醒应用程序获得一个新的“令牌”。收到这个回调后，在服务器上生成一个新的token，并调用 AgoraRtcEngineKit.renewToken(_:) 方法将新的token传递给SDK。

    ///
    /// - Parameters:
    ///   - token: 30s内过期的token
    func rtcEngine(_ engine: AgoraRtcEngineKit, tokenPrivilegeWillExpire token: String) {
        Agora.log(engine, token)
    }
    
    /// token过期时调用
    /// 在 AgoraRtcEngineKit.joinChannel(byToken:channelId:info:uid:joinSuccess:) 后，如果SDK由于网络问题失去了与Agora服务器的连接，token在一段时间后可能会过期，并需要一个新的token来重连服务器
    ///
    /// SDK触发此方法来通知app通过调用 AgoraRtcEngineKit.renewToken(_:)  重新生成一个token
    func rtcEngineRequestToken(_ engine: AgoraRtcEngineKit) {
        Agora.log(engine)
    }
    
    // MARK: - Media Delegate Methods
    
}

extension AgoraRTCEngineProxy {
    func a() {
        #selector(AgoraRtcEngineKit.renewToken(_:))
    }
}
