//
//  RMService.swift
//  RickAndMorty
//
//  Created by Sean Malek on 9/18/26.
//

import Foundation

protocol RMServiceProtocol {
    func searchCharacters(name: String) async throws -> [RMCharacter]
}

final class RMService: RMServiceProtocol {

    func searchCharacters(name: String) async throws -> [RMCharacter] {
        let baseURL = "https://rickandmortyapi.com/api/character/"

        var components = URLComponents(string: baseURL)
        components?.queryItems = [URLQueryItem(name: "name", value: name)]

        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch {
            throw NetworkError.requestFailed
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        if httpResponse.statusCode == 404 {
            return []
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }

        do {
            let decoded = try JSONDecoder().decode(RMCharactersResponse.self, from: data)
            return decoded.results
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
