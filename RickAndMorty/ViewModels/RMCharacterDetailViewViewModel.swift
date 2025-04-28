//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Razumov Pavel on 23.04.2025.
//

import Foundation


final class RMCharacterDetailViewViewModel {
    private let character: RMCharacter
    
    enum SectionType: CaseIterable {
        case photo
        case information
        case episodes
    }
    
    public let sections = SectionType.allCases
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    public var title: String {
        character.name.uppercased()
    }
    
    public var requestUrl: URL? {
        return URL(string: character.url)
    }
    
}
