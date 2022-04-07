//
//  FileStorage.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 01.04.2022.
//

import Foundation

final class FileStorage {
    
    private let asyncQueue = AsyncQueue(label: "FileStorage_SerialQueue")
    private let fileManager = FileManager.default
    
    func createFolder(url: URL) async {
        await asyncQueue.put(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            if !self.fileManager.fileExists(atPath: url.absoluteString) {
                try? self.fileManager.createDirectory(at: url, withIntermediateDirectories: false)
            }
        }
    }

    func read<Result>(body: @escaping (FileManager) -> (Result?)) async -> Result? {
        await asyncQueue.put { [weak self] in
            guard let self = self else { return nil }
            return body(self.fileManager)
        }
    }
    
    func store(body: @escaping (FileManager) -> (Bool)) async -> Bool {
        await asyncQueue.put { [weak self] in
            guard let self = self else { return false }
            return body(self.fileManager)
        }
    }

}
