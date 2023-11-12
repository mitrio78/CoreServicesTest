//
//  Protocols.swift
//  Modul 15
//
//  Created by Dmitriy Grishechko on 03.09.2023.
//

import UIKit

// MARK: - NetworkServiceProtocol

public protocol NetworkServiceProtocol {
    func performRequest<Response: Decodable>(request: RequestDataProtocol) async throws -> (Response, Data, URLResponse)
}
