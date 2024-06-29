//
//  File.swift
//  
//
//  Created by Adam Wulf on 6/29/24.
//

import Foundation

extension String {
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
