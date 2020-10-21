//
//  UIColor+Extensions.swift
//  Grow iOS
//
//  Created by Ryan Thally on 10/12/20.
//  Copyright © 2020 Ryan Thally. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init?(hexString: String) {
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    func hexString(withAlpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else { return nil }
        
        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])
        
        let alpha: Float
        if components.count >= 4 {
            alpha = Float(components[3])
        } else {
            alpha = 1.0
        }
        
        if withAlpha {
            return String(format: "%02lx%02lx%02lx%02lx", lroundf(red*255), lroundf(green*255), lroundf(blue*255), lroundf(alpha*255))
        } else {
            return String(format: "%02lx%02lx%02lx", lroundf(red*255), lroundf(green*255), lroundf(blue*255))
        }
    }
}
