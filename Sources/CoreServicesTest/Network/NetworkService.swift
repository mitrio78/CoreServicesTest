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

    public func performRequest<Response: Decodable>(request: RequestDataProtocol) async throws -> (Response, Data, URLResponse) {
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

            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                return (response, data, urlResponse)
            } catch {
                throw error
            }
        } catch {
            throw error
        }
    }
}
