//
//  StorageManager.swift
//  songsurprise
//
//  Created by resoul on 08.09.2024.
//

import UIKit

class StorageManager {
    static let shared = StorageManager()
    private init() {}
    private let fileManager = FileManager.default
    
    enum StorageError: Error, CustomStringConvertible {
        case fileError
        var description: String {
            switch self {
            case .fileError:
                return "file error"
            }
        }
    }
    
    func getAudioFile(endpoint: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let file = directory(endpoint: endpoint) else {
            completion(Result.failure(StorageError.fileError))
            return
        }
        
        guard fileManager.fileExists(atPath: file.path) == false else {
            completion(Result.success(file))
            return
        }
        
        let task = URLSession.shared.dataTask(with: endpoint) { data, response, error in
            if let data = data {
                do {
                    try data.write(to: file, options: .atomic)
                    DispatchQueue.main.async {
                        completion(Result.success(file))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(Result.failure(error.localizedDescription as! Error))
                    }
                }
            }
        }
        task.resume()
    }
    
    func cacheAudioFiles() {
        let client = Client.http.supabase()
        DispatchQueue.global(qos: .background).async {
            Task {
                let tracks:[Track] = try await client
                    .from("songs")
                    .select()
                    .execute()
                    .value
                for track in tracks {
                    let endpoint = try client.storage.from("audio").getPublicURL(path: track.endpoint)
                    self.cacheFile(endpoint: endpoint)
                }
            }
        }
    }
    
    func clearCache() {
        guard let cacheURL = cacheURL else {
            return
        }
        
        do {
            let directory = try fileManager.contentsOfDirectory(at: cacheURL, includingPropertiesForKeys: nil)
            for file in directory {
                try fileManager.removeItem(at: file)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func cacheFile(endpoint: URL) {
        guard let file = directory(endpoint: endpoint) else {
            return
        }
        
        guard fileManager.fileExists(atPath: file.path) == false else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: endpoint) { data, response, error in
            if let data = data {
                do {
                    try data.write(to: file, options: .atomic)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    private func directory(endpoint: URL) -> URL? {
        guard let cache = self.cacheURL else {
            return nil
        }
        
        return cache.appendingPathComponent(endpoint.lastPathComponent)
    }
    
    private lazy var cacheURL: URL? = {
        return fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
    }()
}
