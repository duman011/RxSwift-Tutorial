//
//  UIView+Ext.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 12.02.2024.
//

import UIKit

extension UIView {
    func addBorder(width: CGFloat, color: UIColor) {
         layer.borderWidth = width
         layer.borderColor = color.cgColor
     }
     
    // TODO: - KULANAMZSAK KALDIR !!
     func addCornerRadius(radius: CGFloat) {
         layer.cornerRadius = radius
         layer.masksToBounds = true
     }
}
