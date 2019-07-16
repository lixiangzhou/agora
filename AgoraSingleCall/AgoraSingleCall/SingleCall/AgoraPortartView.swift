//
//  AgoraPortartView.swift
//  AgoraSingleCall
//
//  Created by Macbook Pro on 2019/7/16.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class AgoraPortartView: UIView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        //
        // height：70 + 5 + 20 + 5 + 25
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 100, height: 125))
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let iconView = UIImageView(image: UIImage(named: "default_portrait"))
    let nameLabel = UILabel()
    let statusLabel = UILabel()
    // MARK: - Private Property
    private let contentView = UIView()
}

// MARK: - UI
extension AgoraPortartView {
    private func setUI() {
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textAlignment = .center
        
        statusLabel.textColor = .white
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.systemFont(ofSize: 18)
        
        let iconWH: CGFloat = 70
        let iconX = (frame.width - iconWH) * 0.5
        
        iconView.frame = CGRect(x: iconX, y: 0, width: iconWH, height: iconWH)
        
        nameLabel.frame = CGRect(x: 0, y: iconWH + 5, width: frame.width, height: 20)
        
        statusLabel.frame = CGRect(x: 0, y: nameLabel.frame.maxY + 5, width: frame.width, height: 25)
        
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(statusLabel)
    }
}

// MARK: - Helper
extension AgoraPortartView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
}
