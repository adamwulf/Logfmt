// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

class Logfmt<Category: RawRepresentable> where Category.RawValue == String {
    enum Level: Int, CaseIterable, Comparable {
        case verbose = 0
        case debug = 1
        case info = 2
        case warning = 3
        case error = 4

        public static func < (lhs: Level, rhs: Level) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
    }

    // MARK: - Log Level

    // This is the maximum allowed level that logging can be set to.
    // This prevents a user from setting logging too restrictively and
    // us not being able to debug a situation because logs are sparse.
    var requiredLogLevel: Level = .info {
        didSet {
            minLogLevel = min(requiredLogLevel, minLogLevel)
        }
    }

    private var minLogLevel: Level = .verbose
    var logLevel: Level {
        get {
            return minLogLevel
        }
        set {
            let oldValue = logLevel
            let updatedLevel = min(requiredLogLevel, newValue)
            if oldValue != updatedLevel {
                minLogLevel = updatedLevel
//                logfmt(level: .info, category: "logging", context: ["level": ["from": oldValue, "to": updatedLevel]])
            }
        }
    }

    init(with logLevel: Level, requiredLevel: Level? = nil) {
        self.requiredLogLevel = requiredLevel ?? logLevel
        self.logLevel = logLevel
    }

    // MARK: - Public Methods

    /// log something which you are really interested but which is not an issue or error (normal priority)
    func info(_ category: Category,
              file: String = #file,
              function: String = #function,
              line: Int = #line,
              context: [String: Loggable]? = nil) {
        logfmt(level: .info, category: category.rawValue, file: file, function: function, line: line, context: context)
    }

    /// log something which may cause big trouble soon (high priority)
    func warning(_ category: Category,
                 file: String = #file,
                 function: String = #function,
                 line: Int = #line,
                 context: [String: Loggable]? = nil) {
        logfmt(level: .warning, category: category.rawValue, file: file, function: function, line: line, context: context)
    }

    /// log something which will keep you awake at night (highest priority)
    func error(_ category: Category,
               file: String = #file,
               function: String = #function,
               line: Int = #line,
               context: [String: Loggable]? = nil) {
        logfmt(level: .error, category: category.rawValue, file: file, function: function, line: line, context: context)
    }

    /// log something which will keep you awake at night (highest priority)
    func custom(level: Level,
                category: Category,
                file: String = #file,
                function: String = #function,
                line: Int = #line,
                context: [String: Loggable]? = nil) {
        logfmt(level: level, category: category.rawValue, file: file, function: function, line: line, context: context)
    }

    private func logfmt(level: Level,
                        category: String,
                        file: String = #file,
                        function: String = #function,
                        line: Int = #line,
                        context: [String: Loggable]? = nil) {
        guard let context = context else { return }
        print(String.logfmt(context))
    }
}
