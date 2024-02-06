//
//  PrepareVC.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 6.02.2024.
//

import UIKit

final class PrepareVC: UIViewController {
    // MARK: - Variables
    var window: UIWindow?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension PrepareVC {
    private func checkNetworkConnection() {
        if Reachability.isNetworkAvailable() {
            //viewModel.viewDidLoad()
        } else {
            self.showAlert(title: "Hata", message: "Lütfen internet bağlantınızı kontrol ediniz.", buttonTitle: "OK")
        }
    }
    
    private func prepareHomeVC() {
        let vc:HomeVC = .instantiate()
        let navVC = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = navVC
        self.window?.makeKeyAndVisible()
    }
}
