//
//  UIDevice+Rotation.swift
//  live
//
//  Created by on 2022/2/8.
//

import Foundation
import UIKit

extension UIDevice {
    static func switchOrientation(_ orientation: UIInterfaceOrientation) {
//        UIDevice.current.setValue(NSNumber(value: UIDeviceOrientation.unknown.rawValue), forKey: "orientation")
        
        let orientationTarget = NSNumber(value: orientation.rawValue)
        
        UIDevice.current.setValue(orientationTarget, forKey: "orientation")
    }
}
