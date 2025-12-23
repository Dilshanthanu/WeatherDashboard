//
//  ApiError.swift
//  MovieMate
//
//  Created by Dilshan Thanushka on 2025-11-19.
//

import Foundation

enum ApiError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL. Please check the endpoint."
        case .invalidResponse:
            return "Server returned an invalid response."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}
