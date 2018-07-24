//
//  Profile_ProfileTypeSeed.swift
//  App
//
//  Created by  LaptopGCampos on 7/11/18.
//

import FluentPostgreSQL

struct ProfileTypePivotSeed: Migration {

    typealias Database = PostgreSQLDatabase
    
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        let profileTypePivot = ProfileTypePivot(id: nil, profileId: 1, profileTypeId: 1, createdAt: nil)
        return profileTypePivot.save(on: conn).map {_ in ()}
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return .done(on: conn)
    }
}
