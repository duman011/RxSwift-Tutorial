//
//  RegisterVC.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 11.02.2024.
//
import UIKit
import RxSwift
import RxCocoa

final class RegisterVC: BaseVC {
    //MARK: - Variables
    let viewModel: RegisterViewModel = RegisterViewModel()
    
    //MARK: - IBOutlet
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var rePasswordTF: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    // MARK: - Validation
    private var everythingValid: Observable<Bool>!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        subscribeIsLoad()
        textFieldValidation()
        signUpTapped()
        signInTapped()
    }
    
    // MARK: - UI Configuration
    private func configureTextFields() {
        userNameTF.addBorder(width: 2, color: UIColor.systemGray4)
        emailTF.addBorder(width: 2, color: UIColor.systemGray4)
        passwordTF.addBorder(width: 2, color: UIColor.systemGray4)
        rePasswordTF.addBorder(width: 2, color: UIColor.systemGray4)
        
        let eyeImage = UIImage(systemName: "eye.slash.fill")!
        passwordTF.addToggleVisibilityButton(image: eyeImage)
        rePasswordTF.addToggleVisibilityButton(image: eyeImage)
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
    
    // MARK: - RX Bindings
    // MARK: - RX Bindings
    private func textFieldValidation(){
        let emailValid = emailTF.rx.text // 1
            .orEmpty // 2
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { $0.isValidEmail(email: $0) } // 3
            .share(replay: 1) // 5
        
        let passwordValid = passwordTF.rx.text.orEmpty
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { $0.isValidPassword(password: $0) }
            .share(replay: 1)
        
        let rePasswordValid = rePasswordTF.rx.text.orEmpty
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { $0 == self.passwordTF.text }
            .share(replay: 1)
        
        everythingValid = Observable
            .combineLatest(emailValid, passwordValid, rePasswordValid) { $0 && $1 && $2 } // 1
            .share(replay: 1)
        
        everythingValid
            .map { $0 ? UIColor.green : UIColor.red }
            .subscribe(onNext: { color in
                self.signUpButton.configuration?.baseBackgroundColor = color
                self.signUpButton.configuration?.baseForegroundColor = color
            })
            .disposed(by: viewModel.disposeBag)
    }

    
   
    private func signUpTapped() {
        signUpButton.rx.tap
            .withLatestFrom(everythingValid)
            .subscribe(onNext: { [weak self] isValid in
                guard let self else { return }
                
                guard let email = self.emailTF.text,
                      let password = self.passwordTF.text,
                      let rePassword = rePasswordTF.text else {
                    showAlert(title: "Alert!", message: "Email and Password required", buttonTitle: "Ok")
                    return
                }
                
                guard email.isValidEmail(email: email) else {
                    showAlert(title: "Alert!", message: "Email Invalid", buttonTitle: "Ok")
                    return
                }
                
                guard password.count >= 6 else {
                    showAlert(title: "Alert!", message: "Password must be at least 6 characters", buttonTitle: "Ok")
                    return
                }
                
                guard password.containsDigits(password) else {
                    showAlert(title: "Alert!", message: "Password must contain at least 1 digit", buttonTitle: "Ok")
                    return
                }
                
                guard password.containsLowerCase(password) else {
                    showAlert(title: "Alert!", message: "Password must contain at least 1 lowercase character", buttonTitle: "Ok")
                    return
                }
                
                guard password.containsUpperCase(password) else {
                    showAlert(title: "Alert!", message: "Password must contain at least 1 uppercase character", buttonTitle: "Ok")
                    return
                }
                
                guard password == rePassword else {
                    showAlert(title: "Alert!", message: "Password and password repeat are not the same", buttonTitle: "Ok")
                    return
                }
                
                guard password.isValidPassword(password: password) else {
                    showAlert(title: "Alert!", message: "Password Invalid", buttonTitle: "Ok")
                    return
                }
                
                if isValid {
                    viewModel.register(email: email, password: password,
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
    
    private func signInTapped() {
        signInButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: viewModel.disposeBag)
    }
}
