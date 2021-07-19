//
//  APIError.swift
//  Paywall
//
//  Created by Jason wang on 7/18/21.
//  Copyright © 2021 Disney Streaming Services. All rights reserved.
//

import Foundation

enum APIError {
    case invalidURL
    case invalidURLResponse(Error?, URLResponse?)
    case invalidDataResponse
    case jsonDecoderError(String, Error)
}

extension APIError {
    /// Description to help Developers debug
    var devErrorDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL String"
        case .invalidURLResponse(let err, let response):
            let errDescription = err?.localizedDescription ?? "N/A"
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            return "Invalid Response/status. error: \(errDescription), statusCode: \(String(describing: statusCode))"
        case .invalidDataResponse:
            return "Response Data return nil"
        case .jsonDecoderError(let decodableObj, let err):
            return "Check Decodable Objc: \(decodableObj). \nJOSONDecoder err: \n\(err)"
        }
    }
}

extension APIError: LocalizedError {
    /// Error Description for display to the User
    var errorDescription: String? {
        "Something went wrong with Network call, please try again later"
    }
}
