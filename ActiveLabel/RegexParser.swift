//
//  RegexParser.swift
//  ActiveLabel
//
//  Created by Pol Quintana on 06/01/16.
//  Copyright © 2016 Optonaut. All rights reserved.
//

import Foundation

protocol RegexParserInterface {
    func getElements(from text: String, with pattern: ActiveType, range: NSRange) -> [NSTextCheckingResult]
}

final class RegexParser: RegexParserInterface {

    private let hashtagPattern = "(?:^|\\s|$)#[\\p{L}0-9_]*"
    private let mentionPattern = "(?:^|\\s|$|[.])@[\\p{L}0-9_]*"
    private let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    private let urlPattern = "(^|[\\s.:;?\\-\\]<\\(])" +
        "((https?://|www\\.|pic\\.)[-\\w;/?:@&=+$\\|\\_.!~*\\|'()\\[\\]%#,☺]+[\\w/#](\\(\\))?)" +
    "(?=$|[\\s',\\|\\(\\).:;?\\-\\[\\]>\\)])"
    
    /** Global cache that stores all the shared regexes across all of the ActiveLabel instances
        we need to share them across different ActiveLabels because creating new NSRegularExpression and NSDataDetector objects is expensive and we want  to reuse them instead.
     */
    private static var cachedRegularExpressions: [ActiveType : NSRegularExpression] = [:]

    func getElements(from text: String, with pattern: ActiveType, range: NSRange) -> [NSTextCheckingResult] {
        guard let regexForElement = getRegex(forActiveType: pattern) else { return [] }
        return regexForElement.matches(in: text, options: [], range: range)
    }

    private func getRegex(forActiveType activeType: ActiveType) -> NSRegularExpression? {
        // TODO: UT the equality of two custom patterns
        if let cachedRegex = RegexParser.cachedRegularExpressions[activeType] {
            return cachedRegex
        }
        
        switch activeType {
        case .phone:
            let types: NSTextCheckingResult.CheckingType = [.phoneNumber]
            guard let createdRegex = try? NSDataDetector(types: types.rawValue) else { return nil }
            RegexParser.cachedRegularExpressions[activeType] = createdRegex
            return createdRegex
        case .address:
            let types: NSTextCheckingResult.CheckingType = [.address]
            guard let createdRegex = try? NSDataDetector(types: types.rawValue) else { return nil }
            RegexParser.cachedRegularExpressions[activeType] = createdRegex
            return createdRegex
        case .date:
            let types: NSTextCheckingResult.CheckingType = [.date]
            guard let createdRegex = try? NSDataDetector(types: types.rawValue) else { return nil }
            RegexParser.cachedRegularExpressions[activeType] = createdRegex
            return createdRegex
        case .url:
            let createdRegex = try? NSRegularExpression(pattern: urlPattern, options: [.caseInsensitive])
            RegexParser.cachedRegularExpressions[activeType] = createdRegex
            return createdRegex
        case .email:
            let createdRegex = try? NSRegularExpression(pattern: emailPattern, options: [.caseInsensitive])
            RegexParser.cachedRegularExpressions[activeType] = createdRegex
            return createdRegex
        case .mention:
            let createdRegex = try? NSRegularExpression(pattern: mentionPattern, options: [.caseInsensitive])
            RegexParser.cachedRegularExpressions[activeType] = createdRegex
            return createdRegex
        case .hashtag:
            let createdRegex = try? NSRegularExpression(pattern: hashtagPattern, options: [.caseInsensitive])
            RegexParser.cachedRegularExpressions[activeType] = createdRegex
            return createdRegex
        case .custom(pattern: let pattern):
            let createdRegex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            RegexParser.cachedRegularExpressions[activeType] = createdRegex
            return createdRegex
        }
    }
}
