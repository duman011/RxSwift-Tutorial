//
//  UIEmptyView.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 6.02.2024.
//

import UIKit
import Lottie

enum GIF: String {
    case searchEmpty = "search.json"
    case searchError = "searchError.json"
}

final class UIEmptyView: UIView {
    
    //MARK: - Variables
    private var lottieAnimationView: LottieAnimationView!
    
    //MARK: - IBOutlet
    @IBOutlet private weak var animationView: UIView!
    @IBOutlet private weak var infoLabel: UILabel!
    
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initalize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initalize() {
        if let viewFromXib = Bundle.main.loadNibNamed("UIEmptyView",
                                                      owner: self,
                                                      options: nil)?[0] as? UIView {
            viewFromXib.frame = self.bounds
            self.addSubview(viewFromXib)
        }
    }
}

extension UIEmptyView {
    func configrations(_ name: GIF) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if !animationView.subviews.isEmpty {
                lottieAnimationView.removeFromSuperview()
            }
            lottieAnimationView = .init(name: name.rawValue)
            lottieAnimationView.frame = animationView.bounds
            lottieAnimationView.contentMode = .scaleAspectFit
            lottieAnimationView.loopMode = .loop
            animationView.addSubview(lottieAnimationView)
            lottieAnimationView.play()
            
            //change info label
            if name == .searchEmpty {
                infoLabel.text = "Lütfen bilgi almak istediğiniz film için arama yapınız!"
            } else {
                infoLabel.text = "Aradıgınız film bulunamadı!"
            }
        }
    }
}

