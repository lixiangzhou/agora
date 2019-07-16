//
//  AgoraNameTimeView.swift
//  AgoraSingleCall
//
//  Created by Macbook Pro on 2019/7/16.
//Copyright © 2019 sphr. All rights reserved.
//

import UIKit

class AgoraNameTimeView: UIView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 100, height: 125))
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Property
    let nameLabel = UILabel()
    let timeLabel = UILabel()
    // MARK: - Private Property
    
}

// MARK: - UI
extension AgoraNameTimeView {
    private func setUI() {
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        
        timeLabel.font = UIFont.systemFont(ofSize: 16)
        timeLabel.textColor = .white
        timeLabel.textAlignment = .center
        
        addSubview(nameLabel)
        addSubview(timeLabel)
        
        nameLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: 20)
        timeLabel.frame = CGRect(x: 0, y: nameLabel.frame.maxY + 10, width: frame.width, height: 20)
        
        frame.size.height = timeLabel.frame.maxY
    }
}
