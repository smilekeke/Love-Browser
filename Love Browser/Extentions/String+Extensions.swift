//
//  String+Extensions.swift
//  Love Browser
//
//  Created by 豆子 on 2022/11/15.
//

import Foundation

public typealias RegEx = NSRegularExpression

public func regex(_ pattern: String, _ options: NSRegularExpression.Options = []) -> NSRegularExpression {
    return (try? NSRegularExpression(pattern: pattern, options: options))!
}

extension RegEx {
    // from https://stackoverflow.com/a/25717506/73479
    static let hostName = regex("^(((?!-)[A-Za-z0-9-]{1,63}(?<!-)\\.)*[A-Za-z0-9-]{2,63})$", .caseInsensitive)
    // from https://stackoverflow.com/a/30023010/73479
    static let ipAddress = regex("^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$",
                                 .caseInsensitive)
}

extension String {

    static let localhost = "localhost"
    
    func length() -> Int {
        self.utf16.count
    }
    
    var fullRange: NSRange {
        return NSRange(location: 0, length: length())
    }
    
    func trimmingWhitespace() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func dropping(prefix: String) -> String {
        return hasPrefix(prefix) ? String(dropFirst(prefix.count)) : self
    }

    func dropping(suffix: String) -> String {
        return hasSuffix(suffix) ? String(dropLast(suffix.count)) : self
    }

    func droppingWwwPrefix() -> String {
        self.dropping(prefix: "www.")
    }
    
    func autofillNormalized() -> String {
        let autofillCharacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters).union(.symbols)
        
        var normalizedString = self

        normalizedString = normalizedString.removingCharacters(in: autofillCharacterSet)
        normalizedString = normalizedString.folding(options: .diacriticInsensitive, locale: .current)
        normalizedString = normalizedString.localizedLowercase
        
        return normalizedString
    }

    
    var isValidHost: Bool {
        return isValidHostname || isValidIpHost
    }

    var isValidHostname: Bool {
        return matches(.hostName)
    }

    var isValidIpHost: Bool {
        return matches(.ipAddress)
    }

    func matches(_ regex: NSRegularExpression) -> Bool {
        let matches = regex.matches(in: self, options: .anchored, range: self.fullRange)
        return matches.count == 1
    }

    func matches(pattern: String, options: NSRegularExpression.Options = [.caseInsensitive]) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            return false
        }
        return matches(regex)
    }
    
    func appendedString() -> String {
//    https://active-purple-earwig.faviconkit.com/
//    https://www.google.com/s2/favicons?domain=&size=
        let url = "https://active-purple-earwig.faviconkit.com/" + self + "/32"
        
        return url
        
    }
    
    // watchListHistory
    // cover: https://imagecdn.me/cover/2019-one-k-concert.png"
    // url: https://viewasian.co//drama/2019-one-k-concert
    // watchurl: https://viewasian.co/watch/2019-one-k-concert/watching.html
    func TransUrlStringToTitle() -> String {
        if self.contains("https://viewasian.co/watch/") {
            guard let str = self.components(separatedBy: "watch/").last?.components(separatedBy: "/").first else{ return ""}
            return str
        } else if self.contains("https://viewasian.co//drama/"){
            guard let str = self.components(separatedBy: "drama/").last?.components(separatedBy: "/").first else{ return ""}
            return str
        }
        return ""
    }
}

public extension StringProtocol {

    // Replaces plus symbols in a string with the space character encoding
    // Space UTF-8 encoding is 0x20
    func encodingPlusesAsSpaces() -> String {
        return replacingOccurrences(of: "+", with: "%20")
    }

    func percentEncoded(withAllowedCharacters allowedCharacters: CharacterSet) -> String {
        if let percentEncoded = self.addingPercentEncoding(withAllowedCharacters: allowedCharacters) {
            return percentEncoded
        }
        assertionFailure("Unexpected failure")
        return components(separatedBy: allowedCharacters.inverted).joined()
    }

    func removingCharacters(in set: CharacterSet) -> String {
        let filtered = unicodeScalars.filter { !set.contains($0) }
        return String(String.UnicodeScalarView(filtered))
    }

}


