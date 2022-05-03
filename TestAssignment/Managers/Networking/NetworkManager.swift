//
//  NetworkManager.swift
//  TestAssignment
//
//  Created by Evgenii Kolgin on 29.04.2022.
//

import Combine
import Foundation

protocol NetworkService {
    func fetchPhotos() -> AnyPublisher<[Photo], Error>
    func searchPhotos(for query: String) -> AnyPublisher<[Photo], Error>
    func getPhotoDetails(with id: String) -> AnyPublisher<Photo, Error>
}

class NetworkManager: NetworkService {
    
    private var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func fetchPhotos() -> AnyPublisher<[Photo], Error> {
        guard let request = createRequest(endpoint: .randomPhotos, method: .get, parameters: ["count" : 10, "client_id" : APICredentials.API_KEY]) else { return Fail(error: NetworkError.badRequest).eraseToAnyPublisher() }
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: [Photo].self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func searchPhotos(for query: String) -> AnyPublisher<[Photo], Error> {
        guard let request = createRequest(endpoint: .search, method: .get, parameters: ["query" : query, "client_id" : APICredentials.API_KEY])
        else { return Fail(error: NetworkError.badRequest).eraseToAnyPublisher() }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: SearchResponse.self, decoder: decoder)
            .map { $0.results }
            .eraseToAnyPublisher()
    }
    
    func getPhotoDetails(with id: String) -> AnyPublisher<Photo, Error> {
        guard let request = createRequest(endpoint: .photo(id: id), method: .get, parameters: ["client_id" : APICredentials.API_KEY])
        else { return Fail(error: NetworkError.badRequest).eraseToAnyPublisher() }
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: Photo.self, decoder: decoder)
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




