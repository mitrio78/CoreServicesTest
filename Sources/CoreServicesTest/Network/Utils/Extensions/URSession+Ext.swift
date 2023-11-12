//
//  File.swift
//  
//
//  Created by Dmitriy Grishechko on 12.11.2023.
//

import Foundation

// MARK: - URLSession

public extension URLSession {

    func performDataTask(with request: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            dataTask(with: request) { data, response, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                guard
                    let data,
                    let response
                else {
                    continuation.resume(throwing: NTError.noResponse(#file, #line))
                    return
                }

                continuation.resume(returning: (data, response))
            }
            .resume()
        }
    }
}
