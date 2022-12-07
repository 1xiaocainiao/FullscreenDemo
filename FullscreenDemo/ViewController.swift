//
//  ViewController.swift
//  FullscreenDemo
//
//  Created by on 2022/9/22.
//

import UIKit

class ViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @IBAction func enterfullScreenDidTouched(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FullScreenID") as? FullScreenController else {
            return
        }
        vc.orientationMask = .landscapeRight
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func pushLockedDidTouched(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LockedID") as? LockedViewController else {
            return
        }
        vc.orientationMask = .landscapeRight
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// 是否全屏，旋转后布局，用这个字段判断是否全屏
//extension ViewController {
//    static var isFullscreen: Bool {
//        if let vc = getCurrentDisplayController() as? ViewController {
//            return vc.isFullScreen
//        } else {
//            return false
//        }
//    }
//}

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

extension DispatchQueue {
    public static func delay(_ delay: Double, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
}
