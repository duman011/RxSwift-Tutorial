//
//  ApplicationVariables.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 12.02.2024.
//

import Foundation

struct ApplicationVariables {
    
    private static let defaults = UserDefaults.standard
    
    private init() {}
    
    static var currentUserID: String?{
        get{
            return defaults.string(forKey: "currentUserID")
        } set {
            defaults.set(newValue, forKey: "currentUserID")
        }
    }
    
    static func resetApplicationVariables(){
        defaults.removeObject(forKey: "currentUserID")
    }
    
}
