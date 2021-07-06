//
//  ActiveType.swift
//  ActiveLabel
//
//  Created by Johannes Schickling on 9/4/15.
//  Copyright © 2015 Optonaut. All rights reserved.
//

import Foundation

enum ActiveElement {
    case mention(String)
    case hashtag(String)
    case email(String)
    case url(original: String, trimmed: String)
    case phone(String)
    case address(String)
    case date(String)
    case custom(String)
    
    static func create(with activeType: ActiveType, text: String) -> ActiveElement {
        switch activeType {
        case .mention: return mention(text)
        case .hashtag: return hashtag(text)
        case .email: return email(text)
        case .phone: return phone(text)
        case .url: return url(original: text, trimmed: text)
        case .address: return address(text)
        case .date: return date(text)
        case .custom: return custom(text)
        }
    }
}

public enum ActiveType {
    case mention
    case hashtag
    case url
    case email
    case phone
    case address
    case date
    case custom(pattern: String)
}

extension ActiveType: Hashable, Equatable {
    /// NOTE: this is for using it as a key in dictionaries
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .mention: hasher.combine(-1)
        case .hashtag: hasher.combine(-2)
        case .url: hasher.combine(-3)
        case .email: hasher.combine(-4)
        case .phone: hasher.combine(-5)
        case .address: hasher.combine(-6)
        case .date: hasher.combine(-7)
        case .custom(let regex): hasher.combine(regex)
        }
    }
}

public func ==(lhs: ActiveType, rhs: ActiveType) -> Bool {
    switch (lhs, rhs) {
    case (.mention, .mention): return true
    case (.hashtag, .hashtag): return true
    case (.url, .url): return true
    case (.email, .email): return true
    case (.phone, .phone): return true
    case (.address, .address): return true
    case (.date, .date): return true
    case (.custom(let pattern1), .custom(let pattern2)): return pattern1 == pattern2
    default: return false
    }
}
