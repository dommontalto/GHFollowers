//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Dom Montalto on 10/7/2023.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    let baseURL = "https://api.github.com/users/"
    
    private init() {}
    
    func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, ErrorMessage?) -> Void) {
        
        let endpoint = baseURL + "\(username)/followers?=per_pages=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(nil, ErrorMessage.invalidUsername)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(nil, ErrorMessage.unableToComplete)
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, ErrorMessage.invalidResponse)
                return
            }
            
            guard let data = data else {
                completed(nil, ErrorMessage.invalidData)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(followers, nil)
            } catch {
                completed(nil, ErrorMessage.invalidData)
            }
        }
        task.resume()
    }
}
