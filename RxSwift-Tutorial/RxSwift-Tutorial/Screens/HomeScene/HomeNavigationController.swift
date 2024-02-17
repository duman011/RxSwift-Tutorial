//
//  HomeNavigationController.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 12.02.2024.
//

import UIKit

final class HomeNavigationController: UINavigationController {

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarDesign()
    }
    
    // MARK: Set Nav Bar Design
    private func setNavBarDesign() {
        UIBarButtonItem.appearance().tintColor = UIColor.label
    }

}
