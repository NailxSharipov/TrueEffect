//
//  ImageCacher.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 04.04.2022.
//

import SwiftUI

private struct Cache {
    let stamp: TimeInterval
    let image: UIImage
}

actor ImageCacher {

    private var storage = [String: Cache]()
    private let maxCount: Int
    private let maxLifeTime: TimeInterval
    
    init(maxCount: Int = 200, maxLifeTime time: TimeInterval = 10 * 60) {
        self.maxCount = maxCount
        maxLifeTime = time
    }
    
    func get(key: String) async -> UIImage? {
        storage[key]?.image
    }
    
    func put(key: String, image: UIImage) async {
        storage[key] = Cache(stamp: Date().timeIntervalSince1970, image: image)
        self.clean()
    }
    
    private func clean() {
        guard storage.count < maxCount else { return }
        
        struct Element {
            let key: String
            let cache: Cache
        }

        var elements = storage.enumerated().map({ Element(key: $0.element.key, cache: $0.element.value) }).sorted(by: { $0.cache.stamp > $1.cache.stamp })
        let now = Date().timeIntervalSince1970
        var isTimeGone = false
        while storage.count > maxCount || isTimeGone {
            let last = elements.removeLast()
            storage[last.key] = nil
            
            if let last = elements.last {
                isTimeGone = now - last.cache.stamp > maxLifeTime
            } else {
                break // no more elements
            }
        }
    }
    
}

