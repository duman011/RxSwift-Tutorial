//
//  UIViewController+Ext.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 6.02.2024.
//

import UIKit


extension UIViewController {
    func ExitAlert(title:String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: { _ in
            exit(0)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title:String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: { _ in
            self.dismiss(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Storyboard'ı Main olan viewController'ları set etmek için kullanılır. Main dışındakiler de hata fırlatacaktır.
    static func instantiate<T>() -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "\(T.self)") as? T else {
            fatalError("Controller bulunamadı.")
        }
        return controller
    }
}
