//
//  UITableView+Ext.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 8.02.2024.
//

import UIKit

extension UITableView {
    func registerCell<T: UITableViewCell>(_ cell: T.Type) {
        let className = String(describing: cell)
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forCellReuseIdentifier: className)
    }
}
