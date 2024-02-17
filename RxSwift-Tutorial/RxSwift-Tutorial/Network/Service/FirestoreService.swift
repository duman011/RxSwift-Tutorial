//
//  FirestoreService.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 12.02.2024.
//

import FirebaseFirestore

protocol FirestoreServiceProtocol {
    func getDocuments<T: Codable>(reference: CollectionReference, onSuccess: @escaping ([T]) -> Void, onError: @escaping (Error) -> Void)
    func setData(reference: DocumentReference, data: [String : Any], onSuccess: (() -> Void)?, onError: @escaping (Error) -> Void)
    func deleteDocument(reference: DocumentReference, onSuccess: (() -> Void)?, onError: @escaping (Error) -> Void)
    func checkDocumentExists(reference: DocumentReference, onSuccess: @escaping (Bool) -> Void, onError: @escaping (Error) -> Void)
}

final class FirestoreService: FirestoreServiceProtocol {
    
    static let shared = FirestoreService()
    
    private init() {}
    
    // MARK: - Get Documents
    // Firestore koleksiyonundaki belgeleri çeker ve belgelere ait verileri belirtilen türdeki bir modelle eşleştirerek başarılı bir şekilde döndürür.
    func getDocuments<T: Codable>(reference: CollectionReference, onSuccess: @escaping ([T]) -> Void, onError: @escaping (Error) -> Void) {
        reference.getDocuments { snapshot, error in
            if let error { onError(error) }
            guard let documents = snapshot?.documents else { return }
            let response = documents.compactMap({try? $0.data(as: T.self)})
            onSuccess(response)
        }
    }
    
    // MARK: - Set Data
    // Firestore'da belirtilen referans üzerine veri set eder ve işlem başarıyla gerçekleşirse belirtilen @escaping bloğunu çağırır.
    func setData(reference: DocumentReference, data: [String : Any], onSuccess: (() -> Void)?, onError: @escaping (Error) -> Void) {
        reference.setData(data) { error in
            if let error { onError(error) }
            onSuccess?()
        }
    }
    
    // MARK: - Delete Document
    // Firestore'da belirtilen belgeyi siler ve işlem başarıyla gerçekleşirse belirtilen @escaping bloğunu çağırır.
    func deleteDocument(reference: DocumentReference, onSuccess: (() -> Void)? = nil, onError: @escaping (Error) -> Void) {
        reference.delete { error in
            if let error { onError(error) }
            onSuccess?()
        }
    }
    
    // MARK: - Check Document Existence
    // Firestore'da belirtilen belgenin var olup olmadığını kontrol eder ve sonucu belirtilen @escaping bloğu aracılığıyla bildirir.
    func checkDocumentExists(reference: DocumentReference, onSuccess: @escaping (Bool) -> Void, onError: @escaping (Error) -> Void) {
        reference.getDocument { snapshot, error in
            if let error { onError(error) }
            if let document = snapshot { onSuccess(document.exists) }
        }
    }
}
