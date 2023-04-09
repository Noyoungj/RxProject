//
//  UIColor+.swift
//  SocarProject
//
//  Created by 노영재 on 2023/03/11.
//

import UIKit

extension UIColor {
    // hex code를 이용한 컬러 정의
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    // 컬러 정의
    class var Color28323C : UIColor { UIColor(hex: 0x28323C)}
    class var Color646F7C : UIColor { UIColor(hex: 0x646F7C)}
    class var Color374553 : UIColor { UIColor(hex: 0x374553)}
    class var ColorEDEDED : UIColor { UIColor(hex: 0xEDEDED)}
    class var Color898989 : UIColor { UIColor(hex: 0x898989)}
}
