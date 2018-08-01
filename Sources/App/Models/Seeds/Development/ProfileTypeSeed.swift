//
//  ProfileTypeSeed.swift
//  App
//
//  Created by  LaptopGCampos on 7/11/18.
//

import FluentPostgreSQL

struct ProfileTypeSeed: Migration {
    
    typealias Database = PostgreSQLDatabase
    
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        let profileType = ProfileType(id: nil, name: "Speaker", createdAt: nil)
        return profileType.save(on: conn).toVoid()
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return ProfileType.query(on: conn).filter(\.name == "Speaker").delete()
    }
}
