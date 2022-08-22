//
//  ApiService.swift
//  SwiftUIWeather
//
//  Created by Игорь Пинаев on 19.08.2022.
//

import Foundation
import Combine

class ApiService<Endpoint: EndpointProtocol> {
    
    func request(from endpoint: Endpoint) -> AnyPublisher<Data, Error> {
        guard let request = buildRequest(from: endpoint) else {
            return Fail(error: ApiError.urlError)
                .eraseToAnyPublisher()
        }
        
        return executeRequest(request)
    }
}

private extension ApiService {
    
    func buildRequest(from endpoint: Endpoint) -> URLRequest? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.params.map { URLQueryItem(name: $0, value: $1) }
        
        guard let url = urlComponents.url else { return nil }
        
        return URLRequest(url: url)
    }
    
    func executeRequest(_ request: URLRequest) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: request)
            .mapError { $0 }
            .map(\.data)
            .eraseToAnyPublisher()
    }
}
