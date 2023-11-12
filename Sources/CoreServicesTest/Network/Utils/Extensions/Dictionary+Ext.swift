//
//  File.swift
//  
//
//  Created by Dmitriy Grishechko on 12.11.2023.
//

import Foundation

extension Dictionary {
    static func + (lhs: Self, rhs: Self) -> Self {
        var leftCopy = lhs
        rhs.forEach { (key, value) in
            leftCopy[key] = value
        }

        return leftCopy
    }

    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
}
