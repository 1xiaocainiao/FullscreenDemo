//
//  NavigationViewController.swift
//  YouLeApp
//
//  Created by Hu Yi on 2018/8/25.
//  Copyright © 2018年 Sioeye Inc. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interactivePopGestureRecognizer?.delegate = self
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let topViewController = topViewController {
            return topViewController.preferredStatusBarStyle
        } else {
            return super.preferredStatusBarStyle
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        if viewControllers.count > 0 {
            viewControllers.last?.hidesBottomBarWhenPushed = true
        }
        super.setViewControllers(viewControllers, animated: true)
    }
    
    // 自动全屏设置
    override var shouldAutorotate: Bool {
        return self.topViewController?.shouldAutorotate ?? false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.topViewController?.supportedInterfaceOrientations ?? .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }
}


extension NavigationViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count <= 1 {
            return false
        }
        return true
    }
}
