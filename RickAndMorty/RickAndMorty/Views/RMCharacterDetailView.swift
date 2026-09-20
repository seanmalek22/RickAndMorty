//
//  RMCharacterDetailView.swift
//  RickAndMorty
//
//  Created by Sean Malek on 9/18/26.
//

import SwiftUI

struct RMCharacterDetailView: View {
    let character: RMCharacter

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: character.image)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                    default:
                        ProgressView()
                    }
                }
                .frame(maxWidth: .infinity)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Image of \(character.name)")
                .accessibilityAddTraits(.isImage)

                VStack(alignment: .leading, spacing: 8) {
                    detailRow(label: "Species", value: character.species)
                    detailRow(label: "Status", value: character.status)
                    detailRow(label: "Origin", value: character.origin.name)
                    if !character.type.isEmpty {
                        detailRow(label: "Type", value: character.type)
                    }
                    detailRow(label: "Created", value: character.formattedCreatedDate)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(
                    item: shareText,
                    preview: SharePreview(character.name)
                )
            }
        }
    }

    private var shareText: String {
        """
        \(character.name)
        Species: \(character.species)
        Status: \(character.status)
        Origin: \(character.origin.name)
        """
    }

    private func detailRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.body)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    RMCharacterDetailView(character: RMCharacter(id: 1, name: "Rick", status: "Alive", species: "Human", type: "", origin: Origin(name: "Earth"), image: "", created: ""))
}
