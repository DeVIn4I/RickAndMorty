//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Razumov Pavel on 14.04.2025.
//

import Foundation

/// Object that represents a single API call
final class RMRequest {
    // https://rickandmortyapi.com/api/character/2
    
    /// API Constants
    private struct Constants {
        static let baseURLString = "https://rickandmortyapi.com/api"
    }
    
    private let endpoint: RMEndpoint
    private let pathComponents: [String]
    private let queryParameters: [URLQueryItem]
    
    /// Constructed url for the api request in string format
    private var urlString: String {
        var string = Constants.baseURLString
        string += "/" + endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach { string += "/\($0)" }
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            
            let argumentString = queryParameters
                .compactMap {
                    guard let value = $0.value else { return nil }
                    return "\($0.name)=\(value)" }
                .joined(separator: "&")
            string += argumentString
        }
        
        return string
    }
    
    public var url: URL? {
        URL(string: urlString)
    }
    
    public let httpMethod = "GET"
    
    public init(
        endpoint: RMEndpoint,
        pathComponents: [String] = [],
        queryParameters: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
}

extension RMRequest {
    static let listCharactersRequest = RMRequest(endpoint: .character)
}
