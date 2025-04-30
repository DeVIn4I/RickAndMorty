//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Razumov Pavel on 28.04.2025.
//

import UIKit

final class RMCharacterInfoCollectionViewCellViewModel {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    public var title: String { type.displayTitle }
    public var displayValue: String {
        if value.isEmpty { return "None" }
        
        if let date = Self.dateFormatter.date(from: value),
           type == .created {
            return Self.shortDateFormatter.string(from: date)
        }

        return value
    }
    
    public var iconImage: UIImage? {
        type.iconImage
    }
    
    public var tintColor: UIColor { type.tintColor }
    
    private let value: String
    private let type: `Type`
    
    enum `Type` {
        case status
        case gender
        case type
        case species
        case origin
        case location
        case created
        case episodesCount
        
        var tintColor: UIColor {
            switch self {
            case .status:
                return .systemBlue
            case .gender:
                return .systemRed
            case .type:
                return .systemPink
            case .species:
                return .systemPurple
            case .origin:
                return .systemGreen
            case .location:
                return .systemOrange
            case .created:
                return .systemBrown
            case .episodesCount:
                return .systemYellow
            }
        }
        
        var iconImage: UIImage? {
            switch self {
            case .status:
                return UIImage(systemName: "bolt.heart")
            case .gender:
                return UIImage(systemName: "person.circle")
            case .type:
                return UIImage(systemName: "poweroutlet.type.c")
            case .species:
                return UIImage(systemName: "accessibility")
            case .origin:
                return UIImage(systemName: "globe")
            case .location:
                return UIImage(systemName: "location.circle")
            case .created:
                return UIImage(systemName: "plus.circle")
            case .episodesCount:
                return UIImage(systemName: "movieclapper")
            }
        }
        
        var displayTitle: String {
            switch self {
            case .status:
                return "Status"
            case .gender:
                return "Gender"
            case .type:
                return "Type"
            case .species:
                return "Species"
            case .origin:
                return "Origin"
            case .location:
                return "Location"
            case .created:
                return "Created"
            case .episodesCount:
                return "Total Episodes"
            }
        }
    }
    
    init(type: `Type`, value: String) {
        self.value = value
        self.type = type
    }
}
