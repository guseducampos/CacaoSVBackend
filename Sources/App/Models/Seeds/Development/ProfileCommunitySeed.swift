//
//  ProfileCommunitySeed.swift
//  App
//
//  Created by  LaptopGCampos on 8/23/18.
//

import FluentPostgreSQL
import Vapor

struct ProfileCommunitySeed: Migration {
    
    typealias Database = PostgreSQLDatabase
    
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return Profile.query(on: conn).unwrapFirst(or: Abort(.notFound, reason: "there is no profiles")).flatMap { profile -> Future<ProfileTypePivot> in
            return try ProfileTypePivot(id: nil, profileId: profile.requireID(), profileTypeId: ProfileTypes.community.rawValue, createdAt: nil).save(on: conn)
            }.toVoid()
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return .done(on: conn)
    }
}
