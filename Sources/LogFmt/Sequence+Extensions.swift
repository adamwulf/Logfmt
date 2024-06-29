//
//  File.swift
//  
//
//  Created by Adam Wulf on 6/29/24.
//

import Foundation

/// An extension to the Sequence protocol to add convenience methods.
extension Sequence {
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
