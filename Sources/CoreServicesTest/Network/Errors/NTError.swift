//
//  File.swift
//  
//
//  Created by Dmitriy Grishechko on 12.11.2023.
//

import Foundation

public enum NTError: Error {
    case emptyResponse
    case urlBuildError
    case invalidResponse
    case invalidRequest
    case decodingError
    case connectionError(errorMessage: String)
    case noResponse(String, Int)
}
