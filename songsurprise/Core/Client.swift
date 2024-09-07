//
//  Client.swift
//  songsurprise
//
//  Created by resoul on 07.09.2024.
//

import Supabase
import Foundation

class Client {
    
    static let http = Client()
    
    private init() {}
    
    func supabase() -> SupabaseClient {
        let uri = ProcessInfo.processInfo.environment["PUBLIC_URI"] ?? ""
        let anonKey = ProcessInfo.processInfo.environment["PUBLIC_ANON_KEY"] ?? ""
        
        return SupabaseClient(supabaseURL: URL(string: uri)!, supabaseKey: anonKey)
    }
}
