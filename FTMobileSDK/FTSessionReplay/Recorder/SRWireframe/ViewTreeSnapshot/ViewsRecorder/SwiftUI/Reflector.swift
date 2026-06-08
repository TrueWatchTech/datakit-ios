//
//  Reflector.swift
//  FTMobileSDK
//
//  Created by hulilei on 2026/6/8.
//  Copyright © 2026 DataFlux-cn. All rights reserved.
//

#if os(iOS)

import Foundation

struct FTReflector {
    struct Lazy<T> where T: FTReflection {
        let reflect: () throws -> T
    }

    enum Error: Swift.Error, CustomStringConvertible {
        case notFound(path: [String], subjectType: String, availableLabels: [String])
        case typeMismatch(path: [String], expectedType: String, actualType: String, subjectType: String)

        var description: String {
            switch self {
            case let .notFound(path, subjectType, availableLabels):
                return "notFound(path: \(path.joined(separator: ".")), subject: \(subjectType), available: \(availableLabels))"
            case let .typeMismatch(path, expectedType, actualType, subjectType):
                return "typeMismatch(path: \(path.joined(separator: ".")), expected: \(expectedType), actual: \(actualType), subject: \(subjectType))"
            }
        }
    }

    let subject: Any
    private let mirror: FTReflectionMirror

    private var subjectType: String {
        String(reflecting: mirror.subjectType)
    }

    private var availableLabels: [String] {
        Self.availableLabels(in: mirror)
    }

    var displayStyle: FTReflectionDisplayStyle {
        switch mirror.displayStyle {
        case .class:
            return .class
        case .struct:
            return .struct
        case let .enum(caseName):
            return .enum(caseName)
        case .tuple:
            return .tuple
        case .nilValue:
            return .nilValue
        default:
            return .opaque
        }
    }

    init(subject: Any) {
        let mirror = FTReflectionMirror(reflecting: subject)
        self.subject = mirror.subject
        self.mirror = mirror
    }

    func descendantIfPresent(_ first: Any, _ rest: Any...) -> Any? {
        descendant(paths: [first] + rest)
    }

    func descendantIfPresent<T>(_ first: Any, _ rest: Any...) -> T? {
        descendant(paths: [first] + rest) as? T
    }

    func descendantIfPresent<T>(type: T.Type = T.self, _ first: Any, _ rest: Any...) -> T? where T: FTReflection {
        do {
            return try descendant(type: type, first, rest)
        } catch {
            return nil
        }
    }

    func descendant<T>(_ first: Any, _ rest: Any...) throws -> T {
        let paths = [first] + rest
        guard let value = descendant(paths: paths) else {
            throw Error.notFound(path: Self.pathLabels(paths), subjectType: subjectType, availableLabels: availableLabels)
        }
        guard let typed = value as? T else {
            throw Error.typeMismatch(
                path: Self.pathLabels(paths),
                expectedType: String(reflecting: T.self),
                actualType: Self.typeName(of: value),
                subjectType: subjectType
            )
        }
        return typed
    }

    func descendant<T>(_ first: Any, _ rest: Any...) throws -> T where T: FTReflection {
        let paths = [first] + rest
        guard let value = descendant(paths: paths) else {
            throw Error.notFound(path: Self.pathLabels(paths), subjectType: subjectType, availableLabels: availableLabels)
        }
        return try reflect(type: T.self, value)
    }

    func descendant<T>(type: T.Type = T.self, _ first: Any, _ rest: [Any]) throws -> T where T: FTReflection {
        try descendant(type: type, [first] + rest)
    }

    func descendant<T>(type: T.Type = T.self, _ first: Any, _ rest: Any...) throws -> T where T: FTReflection {
        try descendant(type: type, [first] + rest)
    }

    func descendant<T>(type: T.Type = T.self, _ paths: [Any]) throws -> T where T: FTReflection {
        guard let value = descendant(paths: paths) else {
            throw Error.notFound(path: Self.pathLabels(paths), subjectType: subjectType, availableLabels: availableLabels)
        }
        return try reflect(type: type, value)
    }

    func descendantArray<Element>(_ first: Any, _ rest: Any...) throws -> [Element] where Element: FTReflection {
        let paths = [first] + rest
        guard let value = descendant(paths: paths) else {
            throw Error.notFound(path: Self.pathLabels(paths), subjectType: subjectType, availableLabels: availableLabels)
        }
        guard let subject = value as? [Any] else {
            throw Error.typeMismatch(
                path: Self.pathLabels(paths),
                expectedType: String(reflecting: [Any].self),
                actualType: Self.typeName(of: value),
                subjectType: subjectType
            )
        }
        return subject.compactMap { try? reflect($0) }
    }

    func descendantDictionary<Key, Value>(_ first: Any, _ rest: Any...) throws -> [Key: Value] where Key: FTReflection, Key: Hashable, Value: FTReflection {
        let paths = [first] + rest
        guard let subject = descendant(paths: paths) else {
            throw Error.notFound(path: Self.pathLabels(paths), subjectType: subjectType, availableLabels: availableLabels)
        }
        return try reflectDictionary(subject, path: Self.pathLabels(paths))
    }

    func reflect<T>(type: T.Type = T.self, _ subject: Any?) throws -> T where T: FTReflection {
        try T(from: FTReflector(subject: subject as Any))
    }

    private func descendant(paths: [Any]) -> Any? {
        var mirrorPaths: [FTReflectionMirror.Path] = []
        for path in paths {
            guard let mirrorPath = FTReflectionMirror.Path(path) else {
                return nil
            }
            mirrorPaths.append(mirrorPath)
        }
        return mirror.descendant(mirrorPaths)
    }

    static func typeName(of value: Any) -> String {
        String(reflecting: Swift.type(of: value))
    }

    static func availableLabels(in value: Any) -> [String] {
        availableLabels(in: FTReflectionMirror(reflecting: value))
    }

    private static func availableLabels(in mirror: FTReflectionMirror) -> [String] {
        let ownLabels: [String]
        if let keyPaths = mirror.keyPaths {
            ownLabels = keyPaths.sorted { $0.value < $1.value }.map(\.key)
        } else {
            ownLabels = mirror.children.enumerated().map { index, child in
                child.label ?? "#\(index)"
            }
        }
        guard let superclassMirror = mirror.superclassMirror else {
            return ownLabels
        }
        return ownLabels + availableLabels(in: superclassMirror)
    }

    private static func pathLabels(_ paths: [Any]) -> [String] {
        paths.map { FTReflectionMirror.Path($0)?.label ?? String(describing: $0) }
    }

    private func reflectDictionary<Key, Value>(_ subject: Any, path: [String]) throws -> [Key: Value] where Key: FTReflection, Key: Hashable, Value: FTReflection {
        if let dictionary = subject as? [AnyHashable: Any] {
            return dictionary.reduce(into: [:]) { result, element in
                guard let key = try? reflect(type: Key.self, element.key.base),
                      let value = try? reflect(type: Value.self, element.value) else {
                    return
                }
                result[key] = value
            }
        }
        throw Error.typeMismatch(
            path: path,
            expectedType: String(reflecting: [AnyHashable: Any].self),
            actualType: Self.typeName(of: subject),
            subjectType: Self.typeName(of: subject)
        )
    }
}

extension FTReflector.Lazy: FTReflection {
    init(from reflector: FTReflector) throws {
        reflect = { try T(from: reflector) }
    }
}

#endif
