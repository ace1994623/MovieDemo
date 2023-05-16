//
//  ProgressView.swift
//  MovieDemo
//
//  Created by Li, Jiawen on 2023/5/15.
//

import UIKit
class ProgressView: UIView {
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.center = self.center
        self.addSubview(activityIndicatorView)
        return activityIndicatorView
    }()
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("[MovieDemo] ProgressView - `init(coder:)` has not been implemented")
    }
    
    func start() {
        activityIndicatorView.startAnimating()
    }
    
    func stop() {
        activityIndicatorView.stopAnimating()
    }
}
