//
//  NetworkService.swift
//  RxSwift-Tutorial
//
//  Created by Yaşar Duman on 7.02.2024.
//

import Foundation
import RxSwift

protocol NetworkServiceInterface {
    func search(with query: String) -> Observable<WsResult<MovieResponse>>
}

final class NetworkService: NetworkServiceInterface {
    static let shared = NetworkService()
    private let decoder = JSONDecoder()
    private let manager: URLSession
    
    private init() {
        self.manager = NetworkService.getSession()
    }
    
    private static func getSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 20
        configuration.timeoutIntervalForRequest = 20
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return URLSession(configuration: configuration)
    }
    
    private func getURLComponent(path: String = "/", queries: [String: String]) -> String {
        var urlComponents = URLComponents()
        urlComponents.scheme = Endpoint.searchMovie.urlScheme
        urlComponents.host = Endpoint.searchMovie.baseURL
        urlComponents.path = path
        urlComponents.queryItems = queries.map { URLQueryItem(name: $0.key, value: $0.value) }
        print("NetworkService--> \(urlComponents.string!) adresine istek atılıyor...")
        return urlComponents.string!
    }
    
    func search(with query: String) -> Observable<WsResult<MovieResponse>> {
         return Observable.create { observer in
             let queries = ["api_key": Endpoint.searchMovie.apiKey, "query": query]
             let url = self.getURLComponent(path: Endpoint.searchMovie.path, queries: queries)
             
             self.manager.dataTask(with: URL(string: url)!) { data, response, error in
                 if let error = error {
                     observer.onNext(.failure(WsError(error.localizedDescription)))
                     observer.onCompleted()
                     return
                 }
                 
                 guard let httpResponse = response as? HTTPURLResponse else {
                     observer.onNext(.failure(WsError("Invalid response")))
                     observer.onCompleted()
                     return
                 }
                 
                 guard (200..<300) ~= httpResponse.statusCode else {
                     observer.onNext(.failure(WsError("Invalid status code: \(httpResponse.statusCode)")))
                     observer.onCompleted()
                     return
                 }
                 
                 guard let data = data else {
                     observer.onNext(.failure(WsError("Invalid data")))
                     observer.onCompleted()
                     return
                 }
                 
                 do {
                     let movieResponse = try self.decoder.decode(MovieResponse.self, from: data)
                     observer.onNext(.success(movieResponse))
                     observer.onCompleted()
                 } catch {
                     observer.onNext(.failure(WsError(error.localizedDescription)))
                     observer.onCompleted()
                 }
             }.resume()
             
             return Disposables.create()
         }
     }
}
