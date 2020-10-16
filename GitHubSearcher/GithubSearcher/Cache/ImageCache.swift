//
//  ImageCache.swift
//  GithubSearcher
//
//  Created by DanielGaribay on 6/9/20.
//  Copyright © 2020 DanielGaribay. All rights reserved.
//

import UIKit

final class ImageCache {
    
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, NSData>()
    
    private init() {}
    
    func getImage(url: String) -> Data? {
        return cache.object(forKey: url as NSString) as Data?
    }
    
    func saveImage(url: String, image: Data) {
        cache.setObject(image as NSData, forKey: url as NSString)
    }
}
