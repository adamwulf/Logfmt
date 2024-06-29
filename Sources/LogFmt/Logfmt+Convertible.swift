//
//  File.swift
//  
//
//  Created by Adam Wulf on 6/29/24.
//

import Foundation

/// Protocol for objects that can be converted to Logfmt strings
public protocol CustomLogfmtStringConvertible: Loggable {
    /// The Logfmt description of the object
    var loggingDescription: String { get }
}

public protocol CustomLogfmtDictionaryConvertible: Loggable {
    /// The Logfmt description of the object
    var loggingDictionary: [String: Loggable] { get }
}
