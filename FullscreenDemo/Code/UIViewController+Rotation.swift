//
//  UIViewController+Rotation.swift
//  FullscreenDemo
//
//  Created by sioeye on 2022/11/11.
//

import Foundation
import UIKit

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
        let orient = UIDevice.current.orientation
        
        switch orient {
        case .portrait:
            isFullScreen = false
            
            refreshWindow()
        case .landscapeLeft,
                .landscapeRight:
            isFullScreen = true
            
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
    
    @objc func switchFullscreen(_ orientation: UIInterfaceOrientation, maskOrientation: UIInterfaceOrientationMask) {
        if #available(iOS 16, *) {
            let windowScene = UIApplication
                .shared
                .connectedScenes.map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first
            
            let geomeTryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: maskOrientation)
            
            windowScene?.requestGeometryUpdate(geomeTryPreferences)
        } else {
            let orientationTarget = NSNumber(value: orientation.rawValue)
            
            UIDevice.current.setValue(orientationTarget, forKey: "orientation")
        }
    }
}
