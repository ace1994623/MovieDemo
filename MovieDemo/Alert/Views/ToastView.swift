//
//  ToastView.swift
//  MovieDemo
//
//  Created by Li, Jiawen on 2023/5/15.
//

import Foundation
import UIKit

class ToastView: UIView {
    /// Add background of the toast
    private let background: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.alpha = 0.8
        view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    /// Set late to show text
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(message: String, view: UIView) {
        super.init(frame: UIScreen.main.bounds)
        addSubview(background)
        
        // config label content
        label.text = message
        addSubview(label)
        
        // Setup layout
        setUpUI(view: view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("[MovieDemo] ToastView - `init(coder:)` has not been implemented")
    }
    
    private func setUpUI(view: UIView) {
        self.alpha = 0
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.clipsToBounds = true
        
        view.addSubview(self)
        
        // Set up UI constraints
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        // Set up UI constraints
        NSLayoutConstraint.activate([
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            background.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            background.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            background.topAnchor.constraint(equalTo: label.topAnchor, constant: -24),
            background.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 24)
        ])
    }
}
