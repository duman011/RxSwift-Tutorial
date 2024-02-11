//
//  PrepareVC.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 6.02.2024.
//

import UIKit

final class PrepareVC: UIViewController {
  
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Praper VC Açıldı")
        checkNetworkConnection()
    }
}

extension PrepareVC {
    private func checkNetworkConnection() {
        if Reachability.isNetworkAvailable() {
            prepareHomeVC()
        } else {
            showAlert(title: "Hata", message: "Lütfen internet bağlantınızı kontrol ediniz.", buttonTitle: "OK")
        }
    }
    
    private func prepareHomeVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let vc:RegisterVC = .instantiate()
            let navVC = UINavigationController(rootViewController: vc)
            self.view.window?.rootViewController = navVC
        }
    }
}
