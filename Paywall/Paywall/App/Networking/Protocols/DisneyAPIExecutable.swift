//
//  DisneyAPIExecutable.swift
//  Paywall
//
//  Created by Jason wang on 7/18/21.
//  Copyright © 2021 Disney Streaming Services. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

protocol APIExecutable {
    var baseURLString: String { get }
    var relativePath: String { get }
    var url: URL? { get }
    var method: HTTPMethod { get }
    func executeRequest(session: URLSession, completion: @escaping (Result<Data, APIError>) -> Void) -> URLSessionDataTask?
}

extension APIExecutable {
    var absoluteURLString: String {
        baseURLString + relativePath
    }
    var url: URL? {
        URL(string: absoluteURLString)
    }

    /// HTTP Request method with Data as a request response
    /// - Parameters:
    ///   - session: Default is set to shared Session but can be override with any URLSession
    ///   - completion: Result type with Data as succes or APIError enum as failure call
    /// - Returns: Returns optional URLSessionDataTask that can either call resume or cancel current request
    func executeRequest(session: URLSession = .shared, completion: @escaping (Result<Data, APIError>) -> Void) -> URLSessionDataTask? {
        guard let url = url else {
            completion(.failure(.invalidURL))
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        return session.dataTask(with: request) { data, response, err in
            guard let urlResponse = response as? HTTPURLResponse, (200...299).contains(urlResponse.statusCode) else {
                completion(.failure(.invalidURLResponse(err, response)))
                return
            }

            guard let validData = data else {
                completion(.failure(.invalidDataResponse))
                return
            }

            completion(.success(validData))
        }
    }
}


protocol DisneyAPIConfigurable: APIExecutable {
    func requestDecodable<T: Decodable>(session: URLSession, objType: T.Type, complection: @escaping (Result<T,APIError>) -> Void) -> URLSessionDataTask?
}

extension DisneyAPIConfigurable {
    var baseURLString: String {
        "http://localhost:8000/"
    }
    /// Default value of HTTPMethod is GET
    var method: HTTPMethod {
        .GET
    }

    /// HTTP Request with Decodable as a response
    /// - Parameters:
    ///   - session: Default is set to shared Session but can be override with any URLSession
    ///   - objType: Object that conforms to Decodable
    ///   - complection: Result type with Decodable object as succes or APIError enum as failure call
    /// - Returns: Returns optional URLSessionDataTask that can either call resume or cancel current request
    func requestDecodable<T: Decodable>(session: URLSession = .shared, objType: T.Type, complection: @escaping (Result<T,APIError>) -> Void) -> URLSessionDataTask? {
        return executeRequest(session: session) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedResponse = try JSONDecoder().decode(objType.self, from: data)
                    complection(.success(decodedResponse))
                } catch {
                    complection(.failure(.jsonDecoderError(String(describing: objType.self), error)))
                }
            case .failure(let err):
                complection(.failure(err))
            }
        }
    }
}
