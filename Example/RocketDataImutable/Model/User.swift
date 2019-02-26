//
//  User.swift
//  ModelGen
//
//  Generated by [ModelGen]: https://github.com/hebertialmeida/ModelGen
//  Copyright © 2019 ModelGen. All rights reserved.
//

import Unbox
import RocketData

/// Definition of a User
public struct User: BaseModel, Equatable {

    // MARK: Instance Variables

    public let email: String
    public let createdAt: Date
    public let avatar: Avatar
    public let companies: [Company]
    public let fullName: String
    public let id: Int
    public let currentCompanyId: Int
    public let timezone: String?

    public static let propertyMapping: [String: String]? = [
        "createdAt": "created_at", "fullName": "full_name", "currentCompanyId": "current_company_id"
    ]

    // MARK: - Initializers

    public init(email: String, createdAt: Date, avatar: Avatar, companies: [Company], fullName: String, id: Int, currentCompanyId: Int, timezone: String?) {
        self.email = email
        self.createdAt = createdAt
        self.avatar = avatar
        self.companies = companies
        self.fullName = fullName
        self.id = id
        self.currentCompanyId = currentCompanyId
        self.timezone = timezone
    }

    public init(unboxer: Unboxer) throws {
        self.email = try unboxer.unbox(key: "email")
        self.createdAt = try unboxer.unbox(key: "created_at", formatter: Date.serverDateFormatter())
        self.avatar = try unboxer.unbox(key: "avatar")
        self.companies = try unboxer.unbox(key: "companies")
        self.fullName = try unboxer.unbox(key: "full_name")
        self.id = try unboxer.unbox(key: "id")
        self.currentCompanyId = try unboxer.unbox(key: "current_company_id")
        self.timezone =  unboxer.unbox(key: "timezone")
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

        return User(email: email, createdAt: createdAt, avatar: avatar, companies: companies, fullName: fullName, id: id, currentCompanyId: currentCompanyId, timezone: timezone)
    }

    public func forEach(_ visit: (Model) -> Void) {
        visit(avatar)
        companies.forEach(visit)
    }

    // MARK: - Builder

    public struct Builder {
        public var email: String
        public var createdAt: Date
        public var avatar: Avatar
        public var companies: [Company]
        public var fullName: String
        public var id: Int
        public var currentCompanyId: Int
        public var timezone: String?

        public init(copy: User) {
            email = copy.email
            createdAt = copy.createdAt
            avatar = copy.avatar
            companies = copy.companies
            fullName = copy.fullName
            id = copy.id
            currentCompanyId = copy.currentCompanyId
            timezone = copy.timezone
        }

        public func build() -> User {
            return User(email: email, createdAt: createdAt, avatar: avatar, companies: companies, fullName: fullName, id: id, currentCompanyId: currentCompanyId, timezone: timezone)
        }
    }
}

// MARK: - Equatable

public func == (lhs: User, rhs: User) -> Bool {
    guard lhs.email == rhs.email else { return false }
    guard lhs.createdAt == rhs.createdAt else { return false }
    guard lhs.avatar == rhs.avatar else { return false }
    guard lhs.companies == rhs.companies else { return false }
    guard lhs.fullName == rhs.fullName else { return false }
    guard lhs.id == rhs.id else { return false }
    guard lhs.currentCompanyId == rhs.currentCompanyId else { return false }
    guard lhs.timezone == rhs.timezone else { return false }
    return true
}