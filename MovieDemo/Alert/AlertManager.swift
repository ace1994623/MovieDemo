//
//  AlertManager.swift
//  MovieDemo
//
//  Created by Li, Jiawen on 2023/5/15.
//

import UIKit

class AlertManager {
    private init() {}
    // MARK: - Properties
    static let shared = AlertManager()
    
    // MARK: - Lazy load properties
    private lazy var loadingView: ProgressView = {
        let loadingView = ProgressView.init()
        return loadingView
    }()
    
    // MARK: - Progress view
    /*
     Show loading view
     */
    func showLoading() {
        DispatchQueue.main.async() {
            if let topViewController = UIApplication.shared.windows.first?.rootViewController?.topMostViewController() {
                topViewController.view.addSubview(self.loadingView)
                self.loadingView.start()
            }
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async() {
            // hide loading view
            self.loadingView.stop()
            self.loadingView.removeFromSuperview()
        }
    }
    
    // MARK: - Toast view
    static func showToast(message: String, duration: Float = 2) {
        DispatchQueue.main.async() {
            if let topViewController = UIApplication.shared.windows.first?.rootViewController?.topMostViewController() {
                var toast : ToastView? = ToastView(message: message, view: topViewController.view)
                
                // Show toast
                UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                    toast?.alpha = 1
                }) { _ in
                    UIView.animate(withDuration: 0, delay: TimeInterval(duration), options: .curveEaseIn, animations: {
                        toast?.alpha = 0
                    }) { _ in
                        toast?.removeFromSuperview()
                        toast = nil
                    }
                }
            }
        }
    }
}
