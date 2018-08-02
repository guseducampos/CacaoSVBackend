//
//  Profile_ProfileTypeSeed.swift
//  App
//
//  Created by  LaptopGCampos on 7/11/18.
//

import FluentPostgreSQL
import Vapor

struct ProfileTypePivotSeed: Migration {

    typealias Database = PostgreSQLDatabase
    
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return Profile.query(on: conn).unwrapFirst(or: Abort(.notFound, reason: "there is no profiles")).flatMap { profile -> Future<ProfileTypePivot> in
            return try ProfileTypePivot(id: nil, profileId: profile.requireID(), profileTypeId: 1, createdAt: nil).save(on: conn)
            }.toVoid()
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return .done(on: conn)
    }
}
