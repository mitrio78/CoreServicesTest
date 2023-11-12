//
//  NetworkService.swift
//
//  Created by Dmitriy Grishechko on 11.05.2023.
//

import UIKit

// MARK: - Network API Service

public struct ResponseModel {
    public var response: Decodable?
    public var data: Data?
    public var urlResponse: URLResponse

    public init(response: Decodable? = nil, data: Data? = nil, urlResponse: URLResponse) {
        self.response = response
        self.data = data
        self.urlResponse = urlResponse
    }
}

public final class NetworkService: NetworkServiceProtocol {

    public init() { }

    // MARK: - Methods

    public func makeRequest<Response: Decodable>(request: RequestDataProtocol, responseType: Response.Type?) async throws -> ResponseModel {
        do {
            let (response, data) = try await performRequest(request: request)
            var model = ResponseModel(urlResponse: response)

            if let responseType {
                do {
                    let response = try JSONDecoder().decode(responseType, from: data)
                    model.response = response
                } catch {
                    throw error
                }
            } else {
                model.data = data
            }
            return model
        } catch {
            throw error
        }
    }

    func performRequest(request: RequestDataProtocol) async throws -> (response: URLResponse, data: Data) {
        let urlRequest: URLRequest

        do {
            guard let newRequest = try request.createRequest() else {
                throw NTError.invalidRequest
            }

            urlRequest = newRequest
        } catch {
            throw error
        }

        let session = request.createSession()

        do {
            let (data, urlResponse) = try await session.performDataTask(with: urlRequest)
            return (urlResponse, data)
        } catch {
            throw error
        }
    }
}
