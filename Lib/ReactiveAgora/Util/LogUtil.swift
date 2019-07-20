//
//  LogUtil.swift
//  ReactiveAgora
//
//  Created by lixiangzhou on 2019/7/18.
//  Copyright © 2019 LXZ. All rights reserved.
//

import Foundation

struct LogEnableModel {
    let name: String
    let enalbed: Bool
}

private let logConfig = [
    LogEnableModel(name: simpleClassName(AgoraRTMProxy.classForCoder()), enalbed: true),
    LogEnableModel(name: simpleClassName(AgoraRTMChannelProxy.classForCoder()), enalbed: true),
    LogEnableModel(name: simpleClassName(AgoraRTMCallProxy.classForCoder()), enalbed: true),
    LogEnableModel(name: simpleClassName(AgoraRTCEngineProxy.classForCoder()), enalbed: true)
]

extension Agora {
    static func log(_ items: Any..., line: Int = #line, file: String = #file, function: String = #function) {
        let fullFileName = (file as NSString).lastPathComponent
        let idx = fullFileName.firstIndex(of: ".")!
        
        let fileName = String(fullFileName[fullFileName.startIndex..<idx])
        
        var result = "\(fileName).\(function) line: \(line) => "
        
        for item in items {
            result += "\(item) "
        }
        
        func logIf(_ enabled: Bool) {
            if enabled {
                print(result)
            }
        }
        
        if let idx = logConfig.firstIndex(where: { $0.name == fileName }) {
            logIf(logConfig[idx].enalbed)
        } else {
            logIf(true)
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
