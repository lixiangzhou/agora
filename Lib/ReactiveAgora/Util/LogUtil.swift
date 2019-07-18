//
//  LogUtil.swift
//  ReactiveAgora
//
//  Created by lixiangzhou on 2019/7/18.
//  Copyright © 2019 LXZ. All rights reserved.
//

import Foundation

private let rtcProxyName = simpleClassName(AgoraRTCProxy.classForCoder())
private let rtmProxyName = simpleClassName(AgoraRTMProxy.classForCoder())

extension Agora {
    static func log(_ items: Any..., line: Int = #line, file: String = #file, function: String = #function) {
        let fullFileName = (file as NSString).lastPathComponent
        let idx = fullFileName.firstIndex(of: ".")!
        
        let fileName = String(fullFileName[fullFileName.startIndex..<idx])
        
        var result = "\(fileName).\(function) line: \(line) => "
        
        for item in items {
            result += "\(item) "
        }
        
        if fileName == rtmProxyName {
            if logRTMDelegateMethod {
                print(result)
            }
        } else if fileName == rtcProxyName {
            if logRTCDelegateMethod {
                print(result)
            }
        } else {
            print(result)
        }
    }
}

private func simpleClassName(_ clazz: AnyClass) -> String {
    let clazzFullName = clazz.description()
    
    if let idx = clazzFullName.firstIndex(of: ".") {
        return String(clazzFullName[clazzFullName.index(after: idx)...])
    }
    return clazzFullName
}
