//
//  UIImageView+Extensions.swift
//  Paywall
//
//  Created by Jason wang on 7/18/21.
//  Copyright © 2021 Disney Streaming Services. All rights reserved.
//

import UIKit

protocol ImageCachable {
    func cache(image: UIImage, url: String)
    func getCacheImage(url: String) -> UIImage?
}

class ImageCacher: ImageCachable {
    static let shared = ImageCacher()
    private init() {}

    let imageCacher = NSCache<NSString, UIImage>()

    func cache(image: UIImage, url: String) {
        let url = url as NSString
        imageCacher.setObject(image, forKey: url)
    }

    func getCacheImage(url: String) -> UIImage? {
        let url = url as NSString
        return imageCacher.object(forKey: url)
    }
}

extension UIImageView {

    /// Convenient way of fetching Image with options of caching
    /// - Parameters:
    ///   - urlPath: URL string of the image
    ///   - imageCacher: Image Cache protocol that comforms to cache(image:url:) and getCacheImage(url:)
    /// - Returns: URLSessionDataTask, gives the consumer the flexibility of resume() and cancel() task
    @discardableResult
    func fetchImage(urlPath: String, imageCacher: ImageCachable? = ImageCacher.shared) -> URLSessionDataTask? {
        if let cachedImage = imageCacher?.getCacheImage(url: urlPath) {
            self.image = cachedImage
            return nil
        }
        let request = GetImageData(relativePath: urlPath).executeRequest(session: .paywall) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let imageData):
                    self.image = UIImage(data: imageData)
                    imageCacher?.cache(image: self.image!, url: urlPath)
                case .failure(let error):
                    print(error.devErrorDescription)
                    self.image = UIImage(named: "place-holder")
                }
            }
        }
        return request
    }
}
