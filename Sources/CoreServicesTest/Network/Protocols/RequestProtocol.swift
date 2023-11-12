//
//  RequestProtocol.swift
//  
//
//  Created by Dmitriy Grishechko on 12.11.2023.
//

import Foundation

// MARK: - RequestDataProtocol

public protocol RequestDataProtocol {
    var scheme: Scheme { get }
    var baseURL: String { get }
    var port: Int? { get }
    var urlPath: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get set }
    var requestGetParams: [String: String]? { get set }
    var bodyParams: Encodable? { get }
}

// MARK: - RequestDataProtocol

public extension RequestDataProtocol {
   func createRequest() throws -> URLRequest? {

        // MARK: - build URL

       var urlComponents = URLComponents()
       urlComponents.scheme = scheme.rawValue
       urlComponents.host = baseURL
       urlComponents.path = urlPath

       if let port {
           urlComponents.port = port
       }

       guard let url = urlComponents.url else {
           return nil
       }

        // MARK: - build request

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // MARK: - add headers

        if let headers = headers {
                for (key, value) in headers {
                    urlRequest.setValue(value, forHTTPHeaderField: key)
                }
            }

        // MARK: - check for queryItems

       if let params = requestGetParams,
          !params.isEmpty,
          var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
           var queryItems: [URLQueryItem] = []

           params.forEach { key, value in
               queryItems.append(URLQueryItem(name: key, value: value))
           }

           urlComponents.queryItems = queryItems
           urlRequest.url = urlComponents.url
       }

        // MARK: - check for body

        if let body = bodyParams {
            do {
                let bodyData = try JSONEncoder().encode(body)
                urlRequest.httpBody = bodyData
            } catch {
                throw error
            }
        }

        return urlRequest
    }

    func createSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30

        return URLSession(configuration: configuration)
    }
}
