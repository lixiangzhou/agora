//
//  AgoraHelper.swift
//  AgoraSingleCall
//
//  Created by Macbook Pro on 2019/7/16.
//  Copyright © 2019 sphr. All rights reserved.
//

import UIKit

private let alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

func randomString(_ length: Int = 10) -> String {
    var result = ""
    let count = UInt32(alphabet.count)
    for _ in 0..<length {
        let idx = Int(arc4random() % count)
        result.append(alphabet.substring(range: NSRange(location: idx, length: 1)))
    }
    return result
}

extension String {
    func substring(range: NSRange) -> String {
        let startIdx = index(startIndex, offsetBy: range.location)
        let endIdx = index(startIdx, offsetBy: range.length)
        
        return String(self[startIdx..<endIdx])
    }
    
    func size(with maxSize: CGSize, font: UIFont) -> CGSize {
        let size = (self as NSString).boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }
}

extension Int {
    func timeFormSec() -> String {
        if self < 3600 {
            return String(format: "%02d:%02d", self / 60, self % 60)
        } else {
            return String(format: "%02d:%02d:%02d", self / 60 / 60, (self / 60) % 60, self % 60)
        }
    }
}

extension UIColor {
    convenience init?(hex: String) {
        
        var hexValue = hex.uppercased()
        if hexValue.hasPrefix("#") {
            hexValue = String(hexValue[hexValue.index(hexValue.startIndex, offsetBy: 1)...])
        } else if hexValue.hasPrefix("0X") {
            hexValue = String(hexValue[hexValue.index(hexValue.startIndex, offsetBy: 2)...])
        }
        let len = hexValue.count
        // RGB  RGBA    RRGGBB  RRGGBBAA
        if len != 3 && len != 4 && len != 6 && len != 8 {
            return nil
        }
        
        var resultHexValue: UInt32 = 0
        guard Scanner(string: hexValue).scanHexInt32(&resultHexValue) else {
            return nil
        }
        
        var divisor: CGFloat = 255
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        if len == 3 {
            divisor = 15
            r = CGFloat((resultHexValue & 0xF00) >> 8) / divisor
            g = CGFloat((resultHexValue & 0x0F0) >> 4) / divisor
            b = CGFloat( resultHexValue & 0x00F) / divisor
            a = 1
        } else if len == 4 {
            divisor = 15
            r = CGFloat((resultHexValue & 0xF000) >> 12) / divisor
            g = CGFloat((resultHexValue & 0x0F00) >> 8) / divisor
            b = CGFloat((resultHexValue & 0x00F0) >> 4) / divisor
            a = CGFloat(resultHexValue & 0x000F) / divisor
        } else if len == 6 {
            r = CGFloat((resultHexValue & 0xFF0000) >> 16) / divisor
            g = CGFloat((resultHexValue & 0x00FF00) >> 8) / divisor
            b = CGFloat(resultHexValue & 0x0000FF) / divisor
            a = 1
        } else if len == 8 {
            r = CGFloat((resultHexValue & 0xFF000000) >> 24) / divisor
            g = CGFloat((resultHexValue & 0x00FF0000) >> 16) / divisor
            b = CGFloat((resultHexValue & 0x0000FF00) >> 8) / divisor
            a = CGFloat(resultHexValue & 0x000000FF) / divisor
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

enum AgoraCallStatus: Equatable {
    /// 正在呼叫
    case dialing
    /// 正在呼入
    case incoming
    /// 收到一个通话呼入后，正在振铃
    case ringing
    /// 正在通话
    case active
    /// 挂断
    case hangupNormal
    case hangupUnNormal
}

enum AgoraCallHangupReason: Equatable {
    /// 还没退出 channel
    case stillInChannel
    /// 未知原因
    case unknown
}
