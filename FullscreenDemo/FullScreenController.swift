//
//  FullScreenController.swift
//  FullscreenDemo
//
//  Created by sioeye on 2022/11/11.
//

import UIKit

class FullScreenController: BaseViewController {
    
    var beforePushOrientation: UIInterfaceOrientationMask?
    
    deinit {
        if #available(iOS 16, *) {

        } else {
            switchOrientation(.portrait)
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
            switchOrientation(orientationMask)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// 检查push前是否为横屏，并重设
        if let orient = beforePushOrientation, orient.isFullScreen {
            switchOrientation(orient)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
        switchOrientation(isFullScreen ? .portrait : .landscapeRight)
    }
    
    @IBAction func pushTestBtnDidTouched(_ sender: UIButton) {
        beforePushOrientation = orientationMask
        
        if isFullScreen {
            switchOrientation(.portrait)
        }
        
        let vc = ThirdPortraitController()
        self.navigationController?.pushViewController(vc, animated: true)
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
