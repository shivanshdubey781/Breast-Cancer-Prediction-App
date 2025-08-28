//
//  NetworkManager.swift
//  BreastCancerPredictorApp
//
//  Created by Shivansh Dubey on 17/07/25.
//

import Foundation

class NetworkManager: NSObject{
    static let shared = NetworkManager()
    private override init() {}

    func fetchPrediction(with request: URLRequest, completion: @escaping (Data?, URLResponse?, (any Error)?) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, response, error)
        }.resume()
        
    }

}
