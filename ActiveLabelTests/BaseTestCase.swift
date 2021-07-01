//
//  BaseTestCase.swift
//  ActiveLabelTests
//
//  Created by Alex Bush | Upkeep on 6/29/21.
//  Copyright © 2021 Optonaut. All rights reserved.
//

import XCTest
@testable import ActiveLabel

extension ActiveElement: Equatable {}

public func ==(a: ActiveElement, b: ActiveElement) -> Bool {
    switch (a, b) {
    case (.mention(let a), .mention(let b)) where a == b: return true
    case (.hashtag(let a), .hashtag(let b)) where a == b: return true
    case (.url(let a), .url(let b)) where a == b: return true
    case (.custom(let a), .custom(let b)) where a == b: return true
    case (.phone(let a), .phone(let b)) where a == b: return true
    case (.address(let a), .address(let b)) where a == b: return true
    case (.date(let a), .date(let b)) where a == b: return true
    default: return false
    }
}

class BaseTestCase: XCTestCase {
    let label = ActiveLabel()
    let customEmptyType = ActiveType.custom(pattern: "")
    
    var activeElements: [ActiveElement] {
        return label.activeElements.flatMap({$0.1.compactMap({$0.element})})
    }
    
    var currentElementString: String? {
        guard let currentElement = activeElements.first else { return nil }
        switch currentElement {
        case .mention(let mention): return mention
        case .hashtag(let hashtag): return hashtag
        case .url(let url, _): return url
        case .custom(let element): return element
        case .email(let element): return element
        case .phone(let element): return element
        case .address(let element): return element
        case .date(let element): return element
        }
    }
    
    var currentElementType: ActiveType? {
        guard let currentElement = activeElements.first else { return nil }
        switch currentElement {
        case .mention: return .mention
        case .hashtag: return .hashtag
        case .url: return .url
        case .custom: return customEmptyType
        case .email: return .email
        case .phone: return .phone
        case .address: return .address
        case .date: return .date
        }
    }
    
    func activeElements(perType type: ActiveElement) -> [ActiveElement] {
        return activeElements.filter({ (activeElement) -> Bool in
            switch (type, activeElement) {
            case (.phone(_), .phone(_)):
                return true
            case (.email(_), .email(_)):
                return true
            case (.url(_, _), .url(_, _)):
                return true
            case (.mention(_), .mention(_)):
                return true
            case (.hashtag(_), .hashtag(_)):
                return true
            case (.address(_), .address(_)):
                return true
            case (.date(_), .date(_)):
                return true
            case (.custom(_), .custom(_)):
                return true
            default:
                return false
            }
        })
    }
}
