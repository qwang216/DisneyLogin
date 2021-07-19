//
//  NetworkingHelpers.swift
//  Paywall
//
//  Copyright © 2020 Disney Streaming Services. All rights reserved.
//

import Foundation

extension URLSession {
  /// Use this `URLSession` so that your app always fetches the latest `paywall.json`
  static let paywall: URLSession = {
    var configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    configuration.urlCache = nil
    let session = URLSession(configuration: configuration)
    return session
  }()
}
