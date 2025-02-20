//
//  APIService.swift
//  Weather App
//
//  Created by Jayashis Barua on 10/02/25.
//

import Foundation

public class hourlyAPIService {
    
    public static let shared = hourlyAPIService()
    
    // MARK: - API Error Handling
    public enum APIError: Error {
        case invalidURL
        case networkError(_ errorString: String)
        case noData
        case decodingError(_ errorString: String)
        case serverError(_ statusCode: Int)
    }
    
    // MARK: - Fetch JSON Data
    public func getJSON<T: Decodable>(
        urlString: String,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        
        // Validate URL
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.networkError(error.localizedDescription)))
                return
            }
            
            // Validate HTTP Response
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }
            
            // Ensure we received data
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            // Configure JSON Decoder
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            
            // Decode JSON
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError(error.localizedDescription)))
            }
            
        }.resume()
    }
}
