//
//  Avatar.swift
//  ModelGen
//
//  Generated by [ModelGen]: https://github.com/hebertialmeida/ModelGen
//  Copyright © 2019 ModelGen. All rights reserved.
//

import Unbox
import RocketData

public struct Avatar: BaseModel, Equatable {

    // MARK: Instance Variables

    public let original: URL?
    public let small: URL?

    // MARK: - Initializers

    public init(original: URL?, small: URL?) {
        self.original = original
        self.small = small
    }

    public init(unboxer: Unboxer) throws {
        self.original =  unboxer.unbox(key: "original")
        self.small =  unboxer.unbox(key: "small")
    }

    // MARK: - Rocket Data Model

    public var modelIdentifier: String? {
        return nil
    }

    public func map(_ transform: (Model) -> Model?) -> Avatar? {
        return self
    }

    public func forEach(_ visit: (Model) -> Void) {
    }

    // MARK: - Builder

    public struct Builder {
        public var original: URL?
        public var small: URL?

        public init(copy: Avatar) {
            original = copy.original
            small = copy.small
        }

        public func build() -> Avatar {
            return Avatar(original: original, small: small)
        }
    }
}

// MARK: - Equatable

public func == (lhs: Avatar, rhs: Avatar) -> Bool {
    guard lhs.original == rhs.original else { return false }
    guard lhs.small == rhs.small else { return false }
    return true
}