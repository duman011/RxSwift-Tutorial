//
//  UITextField+Ext.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 12.02.2024.
//

import UIKit

extension UITextField {
    func addToggleVisibilityButton(image: UIImage) {
        let button = UIButton(configuration: .plain())
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(toggleVisibility), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        self.rightView = button
        self.rightViewMode = .always
    }
    
    @objc func toggleVisibility(_ sender: UIButton) {
        self.isSecureTextEntry.toggle()
        let imageName = self.isSecureTextEntry ? "eye.slash.fill" : "eye.fill"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
