//
//  MovieError.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 7.02.2024.
//
import Foundation

// MARK: - Custom Error Enum
enum MovieError: String, Error {
    case invalidUrl             = "Url Dönüştürülemedi. Please try again."
    case invalidResponse        = "Invalid response from the server. Please try again."
    case invalidData            = "The data received from the server was invalid Please try again."
}

