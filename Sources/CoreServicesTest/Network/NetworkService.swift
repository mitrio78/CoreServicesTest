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

    public func makeDataRequest(request: RequestDataProtocol) async throws -> Data {
        let (_, data) = try await performRequest(request: request)
        return data
    }

    public func makeRequest<Response: Decodable>(request: RequestDataProtocol, responseType: Response.Type) async throws -> Response {
        do {
            let (_, data) = try await performRequest(request: request)

            do {
                let response = try JSONDecoder().decode(responseType, from: data)
                return response
            } catch {
                throw error
            }

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
