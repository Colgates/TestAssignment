//
//  NetworkManager.swift
//  TestAssignment
//
//  Created by Evgenii Kolgin on 29.04.2022.
//

import Foundation

import Combine
import Foundation

protocol NetworkServiceProtocol {
}

class NetworkService: NetworkServiceProtocol {
    
    func fetchCategoriesList() throws -> AnyPublisher<[NewsCategory], Error> {
        guard let request = createRequest(endpoint: .categoriesList, method: .get) else { throw NetworkError.badRequest }
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: CategoriesList.self, decoder: JSONDecoder())
            .map { $0.list }
            .eraseToAnyPublisher()
    }
    
    func fetchNewsList(with id: Int, page: Int) throws -> AnyPublisher<[News], Error> {
        guard let request = createRequest(endpoint: .newsList(id: id), method: .get, parameters: ["page" : page]) else { throw NetworkError.badRequest }
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: NewsList.self, decoder: JSONDecoder())
            .map { $0.list }
            .eraseToAnyPublisher()
    }
    
    func fetchDetailsForNews(with id: Int) throws -> AnyPublisher<News, Error> {
        guard let request = createRequest(endpoint: .newsDetails, method: .get, parameters: ["id" : id]) else { throw NetworkError.badRequest }
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: NewsDetails.self, decoder: JSONDecoder())
            .map { $0.news }
            .eraseToAnyPublisher()
    }
    
    private func createRequest(endpoint: Endpoint, method: Method, parameters: [String: Any]? = nil) -> URLRequest? {
        
        let urlString = Endpoint.baseURL + endpoint.description
        
        guard let url = URL(string: urlString) else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        if let params = parameters {
            switch method {
            case .get:
                var urlComponent = URLComponents(string: urlString)
                urlComponent?.queryItems = params.map { URLQueryItem(name: $0, value: "\($1)") }
                urlRequest.url = urlComponent?.url
            case .post, .delete, .patch:
                let bodyData = try? JSONSerialization.data(withJSONObject: params, options: [])
                urlRequest.httpBody = bodyData
            }
        }
        return urlRequest
    }
}
