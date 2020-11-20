//
//  SimpleButton.swift
//  MyTrainingBook
//
//  Created by Renato Sanchez on 14/10/20.
//  Copyright © 2020 Renato Sánchez. All rights reserved.
//

import UIKit

class SimpleButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpButton()
    }
    
    func setUpButton() {
        backgroundColor = UIColor(red: 0.435, green: 0.259, blue: 0.756, alpha: 1) // purple
        layer.cornerRadius = 10
        setTitleColor(.white , for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        heightAnchor.constraint(equalToConstant: 45.0).isActive = true
    }
}
