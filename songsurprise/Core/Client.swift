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
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }
        
        guard let anonString = dict["PUBLIC_ANON_KEY"] as? String else {
            fatalError("Anon key not set in plist")
        }
        
        return SupabaseClient(
            supabaseURL: URL(string: "https://lqcqxkbjgpoygmczrlap.supabase.co")!,
            supabaseKey: anonString
        )
    }
    // deprecated
//    func supabase() -> SupabaseClient {
//        let uri = ProcessInfo.processInfo.environment["PUBLIC_URI"] ?? ""
//        let anonKey = ProcessInfo.processInfo.environment["PUBLIC_ANON_KEY"] ?? ""
//        
//        return SupabaseClient(supabaseURL: URL(string: uri)!, supabaseKey: anonKey)
//    }
}
