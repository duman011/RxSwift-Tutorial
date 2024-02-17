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
            ExitAlert(title: "Hata", message: "Lütfen internet bağlantınızı kontrol ediniz.", buttonTitle: "OK")
        }
    }
    
    private func prepareHomeVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // MARK: - kullanıcı sürekli giriş yapmaması için yapılan işlem kullanıcıyı hatırlama işlemi
            if ApplicationVariables.currentUserID != nil {
                let vc:HomeVC = .instantiate()
                let homeNavVC = UINavigationController(rootViewController: vc)
                self.view.window?.rootViewController = homeNavVC
                self.view.window?.makeKeyAndVisible()
            }else {
                let vc:LoginVC = .instantiate()
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalTransitionStyle = .crossDissolve
                navVC.modalPresentationStyle = .fullScreen
                self.present(navVC, animated: true)
            }
        }
    }
}
