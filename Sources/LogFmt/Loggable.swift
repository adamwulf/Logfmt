//
//  File.swift
//  
//
//  Created by Adam Wulf on 6/29/24.
//

import Foundation

/// Protocol for objects that can be converted to Logfmt strings
public protocol CustomLogfmtStringConvertible {
    /// The Logfmt description of the object
    var logfmtDescription: String { get }
}

protocol Loggable: Any { }

extension Optional: Loggable { }

extension Dictionary: Loggable where Value == Loggable, Key == String { }

extension Array: Loggable where Element: Loggable { }

extension String: Loggable { }

extension Int: Loggable { }

extension UInt: Loggable { }

extension UInt64: Loggable { }

extension Double: Loggable { }

extension Float: Loggable { }

extension CGFloat: Loggable { }

extension Bool: Loggable { }
