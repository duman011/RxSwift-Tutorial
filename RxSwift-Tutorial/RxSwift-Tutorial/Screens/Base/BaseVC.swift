//
//  BaseVC.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 6.02.2024.
//

import UIKit


class BaseVC: UIViewController {

    lazy var loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = view.center
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(loadingView)
    }
    
    func loadingState(_ status: Bool) {
        DispatchQueue.main.async {
            switch status {
            case true:
                self.loadingView.startAnimating()
            case false:
                self.loadingView.stopAnimating()
            }
        }
    }

}
