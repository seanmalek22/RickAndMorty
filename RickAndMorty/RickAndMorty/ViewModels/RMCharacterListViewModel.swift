//
//  RMCharacterListViewModel.swift
//  RickAndMorty
//
//  Created by Sean Malek on 9/18/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class RMCharacterListViewModel {
    var searchText: String = "" {
        didSet { search() }
    }
    private(set) var characters: [RMCharacter] = []
    private(set) var isLoading: Bool = false
    var errorMessage: String?

    private let service: RMServiceProtocol
    private var searchTask: Task<Void, Never>?

    init(service: RMServiceProtocol = RMService()) {
        self.service = service
    }

    private func search() {
        searchTask?.cancel()

        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            characters = []
            errorMessage = nil
            isLoading = false
            return
        }

        searchTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 250_000_000)
            guard !Task.isCancelled else { return }
            await self?.performSearch(query: query)
        }
    }

    private func performSearch(query: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let results = try await service.searchCharacters(name: query)
            let currentQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !Task.isCancelled, query == currentQuery else { return }
            characters = results
            if results.isEmpty {
                errorMessage = "No characters found for \"\(query)\"."
            }
        } catch {
            let currentQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !Task.isCancelled, query == currentQuery else { return }
            characters = []
            errorMessage = error.localizedDescription
        }
    }
}
