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
        let profileType = [ProfileType(id: nil, name: "Speaker", createdAt: nil).save(on: conn), ProfileType(id: nil, name: "Administrator", createdAt: nil).save(on: conn), ProfileType(id: nil, name: "Community", createdAt: nil).save(on: conn)]
        return profileType.flatten(on: conn).toVoid()
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return .done(on: conn)
    }
}

struct ProfileMoreTypesSeed: Migration {
    
    typealias Database = PostgreSQLDatabase
    
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        let profileType = [ProfileType(id: nil, name: "Administrator", createdAt: nil).save(on: conn), ProfileType(id: nil, name: "Community", createdAt: nil).save(on: conn)]
        return profileType.flatten(on: conn).toVoid()
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return .done(on: conn)
    }
}
