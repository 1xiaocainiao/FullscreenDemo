//
//  FullScreenController.swift
//  FullscreenDemo
//
//  Created by sioeye on 2022/11/11.
//

import UIKit

class FullScreenController: BaseViewController {
    
    deinit {
        if #available(iOS 16, *) {
            
        } else {
            switchFullscreen(.portrait, maskOrientation: .portrait)
        }
        
        removeObserverSwitchLandscape()
        
        removeObserverAppActive()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .gray
        
        addObserverAppActive()

        addObserverSwitchLandscape()
        
        if #available(iOS 16, *) {
            
        } else {
            // 不知道为啥，iOS 16以下需要自己旋转横屏
            switchFullscreen(isFullScreen ? .landscapeRight : .portrait, maskOrientation: isFullScreen ? .landscapeRight : .portrait)
        }
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return isFullScreen ? [.landscapeRight, .landscapeLeft] : .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return isFullScreen ? .landscapeRight : .portrait
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

    @IBAction func fullScreenChanged(_ sender: UIButton) {
        var orientation: UIInterfaceOrientation = .portrait
        var maskOrientation: UIInterfaceOrientationMask = .portrait
        
        if isFullScreen {
            isFullScreen = false
            
            orientation = .portrait
            maskOrientation = .portrait
        } else {
            isFullScreen = true
            
            orientation = .landscapeRight
            maskOrientation = .landscapeRight
        }
        
        switchFullscreen(orientation, maskOrientation: maskOrientation)
        
        refreshWindow()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FullScreenController {
    func addObserverAppActive() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForeground(_:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didEnterBackground(_:)),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    func removeObserverAppActive() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc func willEnterForeground(_ noti: Notification) {
        /// ios 16以下会马上注册，导致进入前台时横屏变竖屏, 顾延迟注册
        DispatchQueue.delay(0.5) {
            self.addObserverSwitchLandscape()
        }
    }
    
    @objc func didEnterBackground(_ noti: Notification) {
        removeObserverSwitchLandscape()
    }
}
