//
//  DisneyNetworkService.swift
//  Paywall
//
//  Created by Jason wang on 7/18/21.
//  Copyright © 2021 Disney Streaming Services. All rights reserved.
//

import Foundation

protocol DisneyNetworkServiceable {
    func getLoginPreference(completion: @escaping (Result<LoginPreference, APIError>) -> Void)
}

class DisneyNetworkService: DisneyNetworkServiceable {
    func getLoginPreference(completion: @escaping (Result<LoginPreference, APIError>) -> Void) {
        let preference = GetLoginPreference()
        let request = preference.requestDecodable(session: .paywall, objType: LoginPreference.self) { result in
            switch result {
            case .success(let preference):
                completion(.success(preference))
            case .failure(let err):
                print(err.devErrorDescription)
                completion(.failure(err))
            }
        }
        request?.resume()
    }
}
