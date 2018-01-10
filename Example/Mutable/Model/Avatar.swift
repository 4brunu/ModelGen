//
//  Avatar.swift
//  ModelGen
//
//  Generated by [ModelGen]: https://github.com/hebertialmeida/ModelGen
//  Copyright © 2018 ModelGen. All rights reserved.
//

import Unbox

public class Avatar: Equatable {

    // MARK: Instance Variables

    public var small: URL?
    public var original: URL?

    // MARK: - Initializers

    public init(small: URL?, original: URL?) {
        self.small = small
        self.original = original
    }

    public init(unboxer: Unboxer) throws {
        self.small =  unboxer.unbox(key: "small")
        self.original =  unboxer.unbox(key: "original")
    }
}

// MARK: - Equatable

public func == (lhs: Avatar, rhs: Avatar) -> Bool {
    guard lhs.small == rhs.small else { return false }
    guard lhs.original == rhs.original else { return false }
    return true
}
