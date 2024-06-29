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
    static func logfmt(_ object: Loggable) -> String {
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
            return logfmt(object.logfmtDescription, attribute: attribute)
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

private extension String {
    /// Joins this `String` with the input `str` by joining them with a `.` separator
    /// - Parameters:
    ///   - str: The string to append after a `.`
    /// - Returns: The string concatenated with a `.` and the input string
    func dot(_ str: String) -> String {
        if self.isEmpty {
            return str
        } else {
            return "\(self).\(str)"
        }
    }

    /// Format the input string by wrapping it in quotes
    /// - Parameters:
    ///   - str: The string to wrap
    /// - Returns: The wrapped string
    func wrapInQuotes() -> String {
        return "\"\(self)\""
    }

    /// Checks if the receiver contains any of the characters in the given string.
    /// - Parameter characters: The characters to check for.
    /// - Returns: `true` if the receiver contains any of the given characters, `false` otherwise.
    func contains(charactersIn characters: String) -> Bool {
        return characters.contains(where: { self.contains($0) })
    }

    /// Escapes the given characters in the receiver with a backslash.
    /// - Parameter characters: The characters to escape.
    /// - Returns: The escaped string.
    func slashEscape(_ characters: String) -> String {
        var result = ""
        for char in self {
            if char == "\\" {
                result += "\\\\"
            } else if characters.contains(char) {
                result += "\\\(char)"
            } else {
                result += String(char)
            }
        }
        return result
    }

}

protocol OptionalProtocol {
    func isSome() -> Bool
    func unwrap() -> Any
}

extension Optional: OptionalProtocol {
    func isSome() -> Bool {
        switch self {
        case .none: return false
        case .some: return true
        }
    }

    func unwrap() -> Any {
        switch self {
        case .none: preconditionFailure("trying to unwrap nil")
        case .some(let unwrapped): return unwrapped
        }
    }
}

/// An extension to the Sequence protocol to add convenience methods.
public extension Sequence {
    /// A convenience method to map a sequence.
    /// - Parameter transform: A closure that takes an element of the sequence and its index, and returns a value.
    /// - Returns: An array of values returned by the `transform` closure.
    ///
    /// # Example Use
    ///
    /// ```
    /// let myArray = [1, 2, 3, 4, 5]
    /// let doubleNumbers = myArray.map { (number, index) -> Int in
    ///     return number * 2
    /// }
    /// // doubleNumbers == [2, 4, 6, 8, 10]
    /// ```
    func map<ElementOfResult>(_ transform: (Self.Element, Int) throws -> ElementOfResult) rethrows -> [ElementOfResult] {
        var ret: [ElementOfResult] = []
        var index = 0
        for item in self {
            ret.append(try transform(item, index))
            index += 1
        }
        return ret
    }
}
