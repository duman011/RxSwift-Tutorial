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
    
    @IBOutlet weak var animationView: UIView!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initalize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initalize()
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
    func configrations(_ name:GIF) {
        if !self.animationView.subviews.isEmpty {
            self.lottieAnimationView.removeFromSuperview()
        }
        self.lottieAnimationView = .init(name: name.rawValue)
        self.lottieAnimationView.frame = self.animationView.bounds
        self.lottieAnimationView.contentMode = .scaleAspectFit
        self.lottieAnimationView.loopMode = .loop
        self.animationView.addSubview(lottieAnimationView)
        self.lottieAnimationView.play()
    }
}
