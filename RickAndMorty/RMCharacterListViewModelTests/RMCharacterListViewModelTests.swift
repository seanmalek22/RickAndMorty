//
//  RMCharacterListViewModelTests.swift
//  RMCharacterListViewModelTests
//
//  Created by Sean Malek on 9/19/26.
//

import Testing
@testable import RickAndMorty

final class RMMockService: RMServiceProtocol {
    var mockedResult: Result<[RMCharacter], Error> = .success([])
    private(set) var lastQuery: String?

    func searchCharacters(name: String) async throws -> [RMCharacter] {
        lastQuery = name
        switch mockedResult {
        case .success(let characters):
            return characters
        case .failure(let error):
            throw error
        }
    }
}

@MainActor
struct RMCharacterListViewModelTests {

    @Test func searchPopulatesCharactersOnSuccess() async throws {
        let mockService = RMMockService()
        let testCharacter = RMCharacter(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "",
            origin: Origin(name: "Earth (C-137)"),
            image: "https://example.com/rick.png",
            created: "2017-11-04T18:48:46.250Z"
        )
        mockService.mockedResult = .success([testCharacter])

        let viewModel = RMCharacterListViewModel(service: mockService)
        viewModel.searchText = "rick"

        try await Task.sleep(nanoseconds: 500_000_000)

        #expect(viewModel.characters.count == 1)
        #expect(viewModel.characters.first?.name == "Rick Sanchez")
        #expect(mockService.lastQuery == "rick")
        #expect(viewModel.isLoading == false)
    }

    @Test func emptySearchClearsResults() {
        let viewModel = RMCharacterListViewModel(service: RMMockService())
        viewModel.searchText = ""
        #expect(viewModel.characters.isEmpty)
    }
}
