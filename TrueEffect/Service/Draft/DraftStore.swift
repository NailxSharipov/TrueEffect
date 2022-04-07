//
//  DraftStore.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 01.04.2022.
//

import Foundation
import ImageIO
import UIKit

final class DraftStore {
    
    enum Folder: String, CaseIterable {
        case storage
        case original
        case edited
        case thumbnail
        case meta
    }

    private let storage = FileStorage()
    private let cacher = ImageCacher()
    
    init() {
        Task {
            await prepare()
        }
    }
    
    func prepare() async {
        _ = await storage.store { fileManager in
            for store in Folder.allCases {
                fileManager.createIfNotExist(folder: store)
            }
            return true
        }
    }

    func save(name: String, folder: Folder, data: Data) async -> Bool {
        await storage.store { fileManager in
            let path = fileManager.url(folder: folder).appendingPathComponent(name, isDirectory: false).path
            if fileManager.fileExists(atPath: path) {
                try? fileManager.removeItem(atPath: path)
            }
            let success = fileManager.createFile(atPath: path, contents: data, attributes: nil)
            return success
        }
    }
    
    func read(name: String, folder: Folder) async -> CGImageSource? {
        await storage.read { fileManager in
            let url = fileManager.url(folder: folder).appendingPathComponent(name, isDirectory: false)
            let source = CGImageSourceCreateWithURL(url as CFURL, nil)
            return source
        }
    }

    func copy(url: URL, name: String, folder: Folder) async -> Bool {
        let success = await storage.store { fileManager in
            let destination = fileManager.url(folder: folder).appendingPathComponent(name, isDirectory: false)
            if fileManager.fileExists(atPath: destination.path) {
                try? fileManager.removeItem(atPath: destination.path)
            }
            do {
                try fileManager.copyItem(at: url, to: destination)
                return true
            } catch {
                return false
            }
        }
        
        return success
    }
    
    func load() async -> [String] {
        return await storage.read { fileManager in
            let path = fileManager.url(folder: .original).path
            
            guard let list = try? fileManager.contentsOfDirectory(atPath: path) else {
                return []
            }

            return list
        } ?? []
    }
    
    func loadThumbnail(name: String, size: CGSize) async -> UIImage? {
        if let image = await cacher.get(key: name) {
            return image
        }
        
        return await storage.read { fileManager in
            let url = fileManager.url(folder: .thumbnail)
            if let data = try? Data(contentsOf: url) {
                return UIImage(data: data)
            } else {
                return nil
            }
        }
    }
    
}

private extension FileManager {
    
    func url(folder: DraftStore.Folder) -> URL {
        guard var urlPath = self.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("user don't have self folder")
        }
        
        urlPath.appendPathComponent(DraftStore.Folder.storage.rawValue, isDirectory: true)
        
        if folder != .storage {
            urlPath.appendPathComponent(folder.rawValue, isDirectory: true)
        }
        
        return urlPath
    }
    
    func createIfNotExist(folder: DraftStore.Folder) {
        let url = self.url(folder: folder)
        if !self.fileExists(atPath: url.path) {
            try? self.createDirectory(at: url, withIntermediateDirectories: true)
        }
    }
}

private extension Dictionary where Key == FileAttributeKey, Value == Any {

    var modificationDate: Date {
        if let modification = self[FileAttributeKey.modificationDate] as? Date {
            return modification
        }
        if let creation = self[FileAttributeKey.creationDate] as? Date {
            return creation
        }
        return Date()
    }
    
}
