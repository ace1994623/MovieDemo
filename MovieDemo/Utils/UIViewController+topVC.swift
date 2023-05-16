//
//  UIViewController+topVC.swift
//  MovieDemo
//
//  Created by Li, Jiawen on 2023/5/15.
//

import UIKit

extension UIViewController {
    /*
     Return the to most view controller
     */
    func topMostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? self
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? self
        }
        return self
    }
}
