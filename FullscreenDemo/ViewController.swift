//
//  ViewController.swift
//  FullscreenDemo
//
//  Created by on 2022/9/22.
//

import UIKit

class ViewController: UIViewController {
    
    var isFullScreen: Bool = false
    
    deinit {
        removeObserver()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObserverSwitchLandscape()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = false
        
        /// 退出界面 立即退出全屏
        AppDelegate.app()?.allowRotation = false
        switchFullscreen(.portrait, maskOrientation: .portrait)
    }

    @IBAction func fullScreenDidTouched(_ sender: UIButton) {
        var orientation: UIInterfaceOrientation = .portrait
        var maskOrientation: UIInterfaceOrientationMask = .portrait
        
        if isFullScreen {
            isFullScreen = false
            
            AppDelegate.app()?.allowRotation = false
            
            orientation = .portrait
            maskOrientation = .portrait
        } else {
            isFullScreen = true
            
            AppDelegate.app()?.allowRotation = true
            
            orientation = .landscapeRight
            maskOrientation = .landscapeRight
        }
        
        switchFullscreen(orientation, maskOrientation: maskOrientation)
        
        AppDelegate.app()?.allowRotation = false // 特别注意手动旋转为全屏后，需要重置为false，否则会出神奇bug
    }
    
    
    // MARK: - 旋转后重新布局
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if self.isFullScreen {
            print("全屏布局")
        } else {
            print("竖屏布局")
        }
    }
    
}

extension ViewController {
    func addObserverSwitchLandscape() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(rotationDidChanged(_:)),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
    }
    
    func removeObserver() {
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func rotationDidChanged(_ noti: Notification) {
        // 其他方向不刷新controller，之前在faceup 等情况下被坑了好久
        func refreshWindow() {
            if #available(iOS 16, *) {
                self.setNeedsUpdateOfSupportedInterfaceOrientations()
                self.navigationController?.setNeedsUpdateOfSupportedInterfaceOrientations()
            } else {
                UIViewController.attemptRotationToDeviceOrientation()
            }
        }
        
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

    func switchFullscreen(_ orientation: UIInterfaceOrientation, maskOrientation: UIInterfaceOrientationMask) {
        if #available(iOS 16, *) {
            self.setNeedsUpdateOfSupportedInterfaceOrientations()
            self.navigationController?.setNeedsUpdateOfSupportedInterfaceOrientations()
            
            let windowScene = UIApplication
                .shared
                .connectedScenes.map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first
            
            let geomeTryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: maskOrientation)
            
            windowScene?.requestGeometryUpdate(geomeTryPreferences)
        } else {
            UIDevice.switchOrientation(orientation)
            
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
}

// 是否全屏，旋转后布局，用这个字段判断是否全屏
extension ViewController {
    static var isFullscreen: Bool {
        if let vc = getCurrentDisplayController() as? ViewController {
            return vc.isFullScreen
        } else {
            return false
        }
    }
}

public func getCurrentDisplayController() -> UIViewController? {
    var normalWindow: UIWindow?
    if #available(iOS 13, *) {
        normalWindow = UIApplication.shared.windows.first
    } else {
        normalWindow = UIApplication.shared.keyWindow
    }
    let windows = UIApplication.shared.windows
    if normalWindow?.windowLevel != .normal {
        for obj in windows {
            if obj.windowLevel == .normal {
                normalWindow = obj
                break
            }
        }
    }
    
    return getTopViewController(normalWindow?.rootViewController)
}

public func getTopViewController(_ inViewController: UIViewController?) -> UIViewController? {
    var inViewController = inViewController
    while ((inViewController?.presentedViewController) != nil) {
        inViewController = inViewController?.presentedViewController
    }
    
    if (inViewController is UITabBarController) {
        let selectedVC: UIViewController? = getTopViewController((inViewController as? UITabBarController)?.selectedViewController)
        return selectedVC
    } else if (inViewController is UINavigationController) {
        let selectedVC: UIViewController? = getTopViewController((inViewController as? UINavigationController)?.visibleViewController)
        return selectedVC
    } else {
        return inViewController
    }
}
