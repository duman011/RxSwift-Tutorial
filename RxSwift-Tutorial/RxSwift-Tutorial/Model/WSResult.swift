//
//  WSResult.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 7.02.2024.
//

import Foundation

// MARK: - WsError
class WsError {
    let message: String
    init(_ message: String) {
        self.message = message
    }
}

// MARK: - WsResult
enum WsResult<T> {
    case success(T)
    case failure(WsError)
}
