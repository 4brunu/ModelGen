//
//  User.swift
//  ModelGen
//
//  Generated by [ModelGen]: https://github.com/hebertialmeida/ModelGen
//  Copyright © 2018 ModelGen. All rights reserved.
//

import Unbox
import RocketData

/// Definition of a User
public struct User: BaseModel, Equatable {

    // MARK: Instance Variables

    public let email: String
    public let id: Int
    public let timezone: String?
    public let fullName: String
    public let createdAt: Date
    public let avatar: Avatar
    public let currentCompanyId: Int
    public let companies: [Company]

    public static let propertyMapping: [String: String]? = [
        "fullName": "full_name", 
        "createdAt": "created_at", 
        "currentCompanyId": "current_company_id"
    ]

    // MARK: - Initializers

    public init(email: String, id: Int, timezone: String?, fullName: String, createdAt: Date, avatar: Avatar, currentCompanyId: Int, companies: [Company]) {
        self.email = email
        self.id = id
        self.timezone = timezone
        self.fullName = fullName
        self.createdAt = createdAt
        self.avatar = avatar
        self.currentCompanyId = currentCompanyId
        self.companies = companies
    }

    public init(unboxer: Unboxer) throws {
        self.email = try unboxer.unbox(key: "email")
        self.id = try unboxer.unbox(key: "id")
        self.timezone =  unboxer.unbox(key: "timezone")
        self.fullName = try unboxer.unbox(key: "full_name")
        self.createdAt = try unboxer.unbox(key: "created_at", formatter: Date.serverDateFormatter())
        self.avatar = try unboxer.unbox(key: "avatar")
        self.currentCompanyId = try unboxer.unbox(key: "current_company_id")
        self.companies = try unboxer.unbox(key: "companies")
    }

    // MARK: - Rocket Data Model

    public var modelIdentifier: String? {
        return "User:\(id)"
    }

    public func map(_ transform: (Model) -> Model?) -> User? {
        guard let avatar = transform(self.avatar) as? Avatar else { return nil }

        let companies = self.companies.flatMap { model in
          return transform(model) as? Company
        }

        return User(email: email, id: id, timezone: timezone, fullName: fullName, createdAt: createdAt, avatar: avatar, currentCompanyId: currentCompanyId, companies: companies)
    }

    public func forEach(_ visit: (Model) -> Void) {
        visit(avatar)
        companies.forEach(visit)
    }

    // MARK: - Builder

    public struct Builder {
        public var email: String
        public var id: Int
        public var timezone: String?
        public var fullName: String
        public var createdAt: Date
        public var avatar: Avatar
        public var currentCompanyId: Int
        public var companies: [Company]

        public init(copy: User) {
            email = copy.email
            id = copy.id
            timezone = copy.timezone
            fullName = copy.fullName
            createdAt = copy.createdAt
            avatar = copy.avatar
            currentCompanyId = copy.currentCompanyId
            companies = copy.companies
        }

        public func build() -> User {
            return User(email: email, id: id, timezone: timezone, fullName: fullName, createdAt: createdAt, avatar: avatar, currentCompanyId: currentCompanyId, companies: companies)
        }
    }
}

// MARK: - Equatable

public func == (lhs: User, rhs: User) -> Bool {
    guard lhs.email == rhs.email else { return false }
    guard lhs.id == rhs.id else { return false }
    guard lhs.timezone == rhs.timezone else { return false }
    guard lhs.fullName == rhs.fullName else { return false }
    guard lhs.createdAt == rhs.createdAt else { return false }
    guard lhs.avatar == rhs.avatar else { return false }
    guard lhs.currentCompanyId == rhs.currentCompanyId else { return false }
    guard lhs.companies == rhs.companies else { return false }
    return true
}