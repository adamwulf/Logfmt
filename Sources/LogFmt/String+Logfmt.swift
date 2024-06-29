//
//  String+Logfmt.swift
//
//
//  Created by Adam Wulf on 12/4/22.
//

import Foundation

public extension String {
    /// Format the input object as lotfmt as best as possible. Supports dictionaries, arrays, strings, numbers, CustomStringConvertables
    /// - seealso: https://www.brandur.org/logfmt
    static func logfmt(_ object: Any) -> String {
        return Self.logfmt(object, attribute: "")
    }
}

private extension String {
    /// Format the input object as lotfmt as best as possible. Supports dictionaries, arrays, strings, numbers, CustomStringConvertables
    /// - Parameters:
    ///   - object: The object to format
    ///   - attribute: The attribute to use when formatting the object
    /// - Returns: The formatted string
    /// - seealso: https://www.brandur.org/logfmt
    static func logfmt(_ object: Any, attribute: String) -> String {
        switch object {
        case let object as String:
            return format(attribute: attribute, value: object)
        case let object as [String: Any]:
            return object.sorted(by: { $0.key < $1.key }).map({ keyVal in
                return logfmt(keyVal.value, attribute: attribute.dot(keyVal.key))
            }).joined(separator: " ")
        case let object as [Any]:
            let mapped = object.map({ item, index in
                return logfmt(item, attribute: attribute.dot("\(index)"))
            })
            return mapped.joined(separator: " ")
        case let object as CustomLogfmtStringConvertible:
            return logfmt(object.loggingDescription, attribute: attribute)
        case let object as CustomLogfmtDictionaryConvertible:
            return logfmt(object.loggingDictionary, attribute: attribute)
        case let object as CustomStringConvertible:
            return logfmt(object.description, attribute: attribute)
        case let object as OptionalProtocol:
            switch object.isSome() {
            case true:
                return logfmt(object.unwrap(), attribute: attribute)
            case false:
                return logfmt("[none]", attribute: attribute)
            }
        case let object as CustomDebugStringConvertible:
            return logfmt(object.debugDescription, attribute: attribute)
        default:
            return logfmt("\(object)", attribute: attribute)
        }
    }

    /// Format the attribute and value as a logfmt string
    /// - Parameters:
    ///   - attribute: The attribute to use when formatting the object
    ///   - value: The value to use when formatting the object
    /// - Returns: The formatted string
    static func format(attribute: String, value: String) -> String {
        let attribute = attribute.replacingOccurrences(of: " ", with: "_")
        let value = value.contains(charactersIn: "\" ") ? value.slashEscape("\"").wrapInQuotes() : value
        if attribute.isEmpty {
            return value
        } else if value.isEmpty {
            return attribute
        } else {
            return attribute + "=" + value
        }
    }
}
