//
//  RegisterViewModel.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 12.02.2024.
//

import Foundation

final class RegisterViewModel: BaseViewModel{
    //MARK: - Properties
    private let  firebaseAuthManager: FirebaseAuthManagerProtocol
    
    //MARK: - Initializers
    init(firebaseAuthManager: FirebaseAuthManagerProtocol = FirebaseAuthManager.shared) {
        self.firebaseAuthManager = firebaseAuthManager
    }
    
    // MARK: - Register
    func register(email: String, password: String, onSuccess: @escaping () -> Void) {
        isLoad.accept(true)
        
        firebaseAuthManager.register(email: email,
                                     password: password) {[weak self] in
            guard let self else {return}
           
            onSuccess()
            isLoad.accept(false)
        } onError: { [weak self] error in
            guard let self else {return}
            
            isLoad.accept(false)
            print(error.localizedDescription)
        }
    }
}
