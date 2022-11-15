//
//  UIViewController+Rotation.swift
//  FullscreenDemo
//
//  Created by sioeye on 2022/11/11.
//

import Foundation
import UIKit

/// 特别注意 UIDeviceOrientation 和（UIInterfaceOrientationMask，UIInterfaceOrientation）的 landscapeRight与landscapeLeft是不同朝向的， interface的两个是一致的

extension UIInterfaceOrientationMask {
    var isFullScreen: Bool {
        return self == .landscapeLeft || self == .landscapeRight
    }
}

extension UIViewController {
    static func convertInterfaceOrientationMaskToDeviceOrientation(_ orientationMask: UIInterfaceOrientationMask) -> UIDeviceOrientation {
        switch orientationMask {
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        case .landscape:
            return .landscapeLeft
        default:
            return .portrait
        }
    }
    
    static func convertDeviceOrientationToInterfaceOrientationMask(_ orientation: UIDeviceOrientation) -> UIInterfaceOrientationMask {
        switch orientation {
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        default:
            return .portrait
        }
    }
}

extension BaseViewController {
    struct Holder {
        static var _canRotation:Bool = false
        
        static var _orientationMask: UIInterfaceOrientationMask = .portrait
    }
    
    var isFullScreen:Bool {
        return orientationMask.isFullScreen
    }
    
    /// 是否可以旋转
    fileprivate var canRotation:Bool {
        get {
            return Holder._canRotation
        }
        set(newValue) {
            Holder._canRotation = newValue
        }
    }
    
    var orientationMask: UIInterfaceOrientationMask {
        get {
            return Holder._orientationMask
        }
        set(newValue) {
            if newValue != orientationMask {
                Holder._orientationMask = newValue
            }
        }
    }
}

extension BaseViewController {
    @objc func addObserverSwitchLandscape() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(rotationDidChanged(_:)),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
    }
    
    @objc func removeObserverSwitchLandscape() {
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func rotationDidChanged(_ noti: Notification) {
        if canRotation {
            return
        }
        
        let orient = UIDevice.current.orientation
        
        switch orient {
        case .portrait:
            orientationMask = .portrait
            
            refreshWindow()
        case .landscapeLeft:
            orientationMask = Self.convertDeviceOrientationToInterfaceOrientationMask(orient)
            
            refreshWindow()
        case     .landscapeRight:
            orientationMask = Self.convertDeviceOrientationToInterfaceOrientationMask(orient)
            
            refreshWindow()
        default:
            debugPrint("")
        }
    }
    
    @objc func refreshWindow() {
        if #available(iOS 16, *) {
            self.setNeedsUpdateOfSupportedInterfaceOrientations()
            self.navigationController?.setNeedsUpdateOfSupportedInterfaceOrientations()
        } else {
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
    
    @objc func switchOrientation(_ orientation: UIInterfaceOrientationMask) {
        defer {
            refreshWindow()
        }
        
        orientationMask = orientation
        
        if #available(iOS 16, *) {
            let windowScene = UIApplication
                .shared
                .connectedScenes.map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first
            
            let geomeTryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: orientation)
            
            windowScene?.requestGeometryUpdate(geomeTryPreferences)
        } else {
            let orientation = UIViewController.convertInterfaceOrientationMaskToDeviceOrientation(orientation)
            let orientationTarget = NSNumber(value: orientation.rawValue)
            
            UIDevice.current.setValue(orientationTarget, forKey: "orientation")
        }
    }
}

// MARK: - 这个是为了解决全屏状态下，按home键进入后台，再进入前台会变为竖屏的bug
extension BaseViewController {
    func addObserverAppActive() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didBecomeActive(_:)),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willResignActive(_:)),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
    }
    
    func removeObserverAppActive() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didBecomeActiveNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification,
                                                  object: nil)
    }
    /// 进入前台
    @objc func didBecomeActive(_ noti: Notification) {
        canRotation = false
    }
    /// 进入后台
    @objc func willResignActive(_ noti: Notification) {
        canRotation = true
    }
}
