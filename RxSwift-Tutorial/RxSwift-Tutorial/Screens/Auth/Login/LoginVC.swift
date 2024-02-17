//
//  LoginVC.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 12.02.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginVC: BaseVC {
    //MARK: - Constants
    private let viewModel: LoginViewModel = LoginViewModel()
    
    //MARK: - IBOutlet
    @IBOutlet private weak var emailTF: UITextField!
    @IBOutlet private weak var passwordTF: UITextField!
    @IBOutlet private weak var forgotPasswordButton: UIButton!
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    
    // MARK: - Validation
    private var everythingValid: Observable<Bool>!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        configureTextFields()
        subscribeIsLoad()
        textFieldValidation()
        signInTapped()
        signUpTapped()
        forgotPasswordTapped()
    }
    
    // MARK: Set Title
    private func setTitle() {
        title = "Login"
        navigationItem.titleView = UIView()
    }
    
    // MARK: - UI Configuration
    private func configureTextFields() {
        emailTF.addBorder(width: 2, color: UIColor.systemGray4)
        passwordTF.addBorder(width: 2, color: UIColor.systemGray4)
        
        let eyeImage = UIImage(systemName: "eye.slash.fill")!
        passwordTF.addToggleVisibilityButton(image: eyeImage)
        
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
        let emailValid = emailTF.rx.text // 1
            .orEmpty // 2
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { $0.isValidEmail(email: $0) } // 3
            .share(replay: 1) // 5
        
        let passwordValid = passwordTF.rx.text.orEmpty
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { $0.count >= 6 }
            .share(replay: 1)
        
        everythingValid = Observable
            .combineLatest(emailValid, passwordValid) { $0 && $1 } // 1
            .share(replay: 1)
        
        everythingValid
            .map { $0 ? UIColor.green : UIColor.red }
            .subscribe(onNext: { color in
                self.signInButton.configuration?.baseBackgroundColor = color
                self.signInButton.configuration?.baseForegroundColor = color
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    private func signInTapped() {
        signInButton.rx.tap
            .withLatestFrom(everythingValid)
            .subscribe(onNext: { [weak self] isValid in
                guard let self else { return }
                
                if isValid {
                    guard let email = self.emailTF.text,
                          let password = self.passwordTF.text else {
                        self.showAlert(title: "Alert!", message: "Email and Password required", buttonTitle: "Ok")
                        return
                    }
                    
                    viewModel.login(email: email, password: password,
                                         onSuccess: {                    
                        let vc: HomeVC = .instantiate()
                        let navVC = UINavigationController(rootViewController: vc)
                        self.view.window?.rootViewController = navVC
                        self.view.window?.makeKeyAndVisible()
                    })
                } else {
                    self.showAlert(title: "Alert!", message: "Email and Password required", buttonTitle: "Ok")
                }
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    private func signUpTapped() {
        signUpButton.rx.tap
            .subscribe(onNext: {[weak self] in
                let vc :RegisterVC = .instantiate()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    private func forgotPasswordTapped() {
        forgotPasswordButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let vc:ForgotPasswordVC = .instantiate()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: viewModel.disposeBag)
    }
}
