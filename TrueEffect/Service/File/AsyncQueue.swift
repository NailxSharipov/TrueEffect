//
//  AsyncQueue.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 01.04.2022.
//

import Foundation

final class AsyncQueue {
    
    private let queue: DispatchQueue

    init(label: String) {
        self.queue = DispatchQueue(label: label)
    }

    init(queue: DispatchQueue) {
        self.queue = queue
    }
    
    func put<Result>(flags: DispatchWorkItemFlags = [], body: @escaping () -> (Result)) async -> Result {
        return await withCheckedContinuation { [weak self] continuation in
            self?.queue.async(flags: flags) {
                let result = body()
                continuation.resume(returning: result)
            }
        }
    }

}
