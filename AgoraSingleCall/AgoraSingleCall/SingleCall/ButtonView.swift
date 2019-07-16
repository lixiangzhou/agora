//
//  ButtonView.swift
//  AgoraSingleCall
//
//  Created by Macbook Pro on 2019/7/16.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class ButtonView: UIView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: 80, height: 90))
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let button = UIButton()
    let titleLabel = UILabel()
    // MARK: - Private Property
    
}

// MARK: - UI
extension ButtonView {
    private func setUI() {
        
        addSubview(button)
        addSubview(titleLabel)
        
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        
        let btnWH: CGFloat = 60
        let btnX: CGFloat = (frame.width - btnWH) * 0.5
        
        button.frame = CGRect(x: btnX, y: 0, width: btnWH, height: btnWH)
        titleLabel.frame = CGRect(x: 0, y: btnWH, width: frame.width, height: frame.height - btnWH)
    }
}

// MARK: - Action
extension ButtonView {
    
}

// MARK: - Helper
extension ButtonView {
    
}

// MARK: - Other
extension ButtonView {
    
}

// MARK: - Public
extension ButtonView {
    
}
