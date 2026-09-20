//
//  RMCharacterRowView.swift
//  RickAndMorty
//
//  Created by Sean Malek on 9/18/26.
//

import SwiftUI

struct RMCharacterRowView: View {
    let character: RMCharacter

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: character.image)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Image(systemName: "photo")
                        .foregroundStyle(.secondary)
                default:
                    ProgressView()
                }
            }
            .frame(width: 56, height: 56)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(character.name)
                    .font(.headline)
                Text(character.species)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(character.name), \(character.species)")
    }
}

#Preview {
    RMCharacterRowView(character: RMCharacter(id: 1, name: "Rick", status: "Alive", species: "Human", type: "", origin: Origin(name: "Earth"), image: "", created: ""))
}
