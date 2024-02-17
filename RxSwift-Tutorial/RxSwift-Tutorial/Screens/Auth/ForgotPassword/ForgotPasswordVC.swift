//
//  ForgotPasswordVC.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 12.02.2024.
//

import UIKit
import RxSwift
import RxCocoa


final class ForgotPasswordVC: BaseVC {
    
    //MARK: - Variables
    let viewModel: ForgotPasswordVM = ForgotPasswordVM()
    
    //MARK: - IBOutlet
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    // MARK: - Validation
    private var emailValid: Observable<Bool>!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
        subscribeIsLoad()
        textFieldValidation()
        submitTapped()
        signInTapped()
    }
    
    // MARK: - UI Configuration
    private func configureTextField() {
        emailTF.addBorder(width: 2, color: UIColor.systemGray4)
    }
    
    // MARK: Subscribe Is Load
    /// Yukleme animasyonuna observe olur.
    private func subscribeIsLoad() {
        self.viewModel
            .isLoad
            .subscribe { value in
                if (value.element ?? false) {
                    self.loadingState(true)
                } else {
                    self.loadingState(false)
                }
            }.disposed(by: self.viewModel.disposeBag)
    }
    
    private func textFieldValidation(){
        emailValid = emailTF.rx.text // 1
            .orEmpty // 2
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { $0.isValidEmail(email: $0) } // 3
            .share(replay: 1) // 5
    
        
        emailValid
            .map { $0 ? UIColor.green : UIColor.red }
            .subscribe(onNext: { color in
                self.submitButton.configuration?.baseBackgroundColor = color
                self.submitButton.configuration?.baseForegroundColor = color
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    
    private func submitTapped() {
        submitButton.rx.tap
            .withLatestFrom(emailValid)
            .subscribe(onNext: { [weak self] isValid in
                guard let self = self else { return }
                
                if isValid {
                    guard let email = self.emailTF.text else {
                        self.showAlert(title: "Alert!", message: "Email required", buttonTitle: "Ok")
                        return
                    }
                    
                    viewModel.resetPassword(email: email,
                                         onSuccess: {
                        self.showAlert(title: "Success", message: "Password reset email sent successfully!", buttonTitle: "Ok")
                    })
                } else {
                    self.showAlert(title: "Alert!", message: "Invalid email format", buttonTitle: "Ok")
                }
            })
            .disposed(by: viewModel.disposeBag)
    }

    
    private func signInTapped() {
        signInButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: viewModel.disposeBag)
    }
    
}
