//
//  UINavigationController+StatusBar.swift
//  CustomWeiChatSearchController
//
//  Created by 范国徽 on 2018/4/9.
//  Copyright © 2018年 范国徽. All rights reserved.
//

import UIKit

extension UINavigationController{

    open override var childViewControllerForStatusBarStyle: UIViewController? {

        if let topVC = self.topViewController {
            let childVCS = topVC.childViewControllers
            if childVCS.count == 0 {
                return topVC
            }
            return topVC.childViewControllers[childVCS.count-1]
        }
        return  nil

    }

    open override var childViewControllerForStatusBarHidden: UIViewController? {
        if let topVC = self.topViewController {
            let childVCS = topVC.childViewControllers
            if childVCS.count == 0 {
                return topVC
            }
            return topVC.childViewControllers[childVCS.count-1]
        }
        return  nil
    }

}
