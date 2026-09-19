//
//  RMCharacterListView.swift
//  RickAndMorty
//
//  Created by Sean Malek on 9/18/26.
//

import SwiftUI

struct RMCharacterListView: View {
    @State private var viewModel = RMCharacterListViewModel()

    var body: some View {
        NavigationStack {
            List {
                if viewModel.searchText.isEmpty {
                    ContentUnavailableView(
                        "Search for a Character",
                        systemImage: "magnifyingglass",
                        description: Text("Type a name to find characters from Rick and Morty.")
                    )
                } else if let errorMessage = viewModel.errorMessage, viewModel.characters.isEmpty {
                    ContentUnavailableView(
                        "No Results",
                        systemImage: "person.crop.circle.badge.questionmark",
                        description: Text(errorMessage)
                    )
                } else {
                    ForEach(viewModel.characters) { character in
                        NavigationLink(value: character) {
                            RMCharacterRowView(character: character)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Characters")
            .searchable(text: $viewModel.searchText, prompt: "Search by name")
            .navigationDestination(for: RMCharacter.self) { character in
                RMCharacterDetailView(character: character)
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }
}

#Preview {
    RMCharacterListView()
}
