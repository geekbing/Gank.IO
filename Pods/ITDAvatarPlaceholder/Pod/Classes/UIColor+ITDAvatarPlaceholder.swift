//
//  UIColor+ITDAvatarPlaceholder.swift
//  Pods
//
//  Created by Igor Kurylenko on 4/4/16.
//
//

import UIKit
import ChameleonFramework

extension UIColor {
    public static func forAvatarPlaceholderBackground(userFullName name: String) -> UIColor {
        return fromInt(name.hashValue).flatten()
    }
    
    static func fromInt(value: Int) -> UIColor {
        return UIColor.fromUInt(UInt(abs(value)))
    }
    
    static func fromUInt(value: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
