//
//  LockedViewController.swift
//  FullscreenDemo
//
//  Created by sioeye on 2022/12/7.
//

import UIKit

class LockedViewController: BaseViewController {
    
    @IBOutlet weak var lockedBtn: UIButton!
    
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
        
        self.title = "lock test"
        
        self.view.backgroundColor = .white
        
        addObserverAppActive()

        addObserverSwitchLandscape()
        
        if #available(iOS 16, *) {
            
        } else {
            // 不知道为啥，iOS 16以下需要自己旋转横屏
            switchOrientation(orientationMask)
        }

        refreshLockedBtnTitle()
        // Do any additional setup after loading the view.
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return isLocked ? self.orientationMask : (isFullScreen ? [.landscapeRight, .landscapeLeft] : .portrait)
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return isLocked ? Self.convertInterfaceOrientationMaskToInterfaceOrientation(self.orientationMask) : (isFullScreen ? .landscapeRight : .portrait)
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
    
    @IBAction func lockedBtnDidTouched(_ sender: UIButton) {
        isLocked = !isLocked
        
        refreshLockedBtnTitle()
    }
    
    func refreshLockedBtnTitle() {
        lockedBtn.setTitle(isLocked ? "locked" : "unLocked", for: .normal)
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
