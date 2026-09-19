//
//  NetworkError.swift
//  RickAndMorty
//
//  Created by Sean Malek on 9/18/26.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case requestFailed
    case invalidResponse
    case decodingFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed:
            return "Network request failed"
        case .invalidResponse:
            return "Data response invalid"
        case .decodingFailed:
            return "JSON decoding failed"
        }
    }
}
