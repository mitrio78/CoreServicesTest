//
//  NetworkService.swift
//
//  Created by Dmitriy Grishechko on 11.05.2023.
//

import UIKit

// MARK: - Network API Service

public final class NetworkService: NetworkServiceProtocol {

    public init() { }

    // MARK: - Methods

    public func performRequest(request: RequestDataProtocol) async throws -> (Data, URLResponse, URLRequest) {
        let configuration = URLSessionConfiguration.default

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
            let (data, response) = try await session.performDataTask(with: urlRequest)
            return (data, response, urlRequest)
        } catch {
            throw error
        }
    }
}
