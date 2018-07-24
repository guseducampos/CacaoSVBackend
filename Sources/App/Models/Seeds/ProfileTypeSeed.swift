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
        let profiles = [ProfileType(id: nil, name: "Community", createdAt: nil).save(on: conn),
                           ProfileType(id: nil, name: "Speaker", createdAt: nil).save(on: conn),
                           ProfileType(id: nil, name: "Admin", createdAt: nil).save(on: conn)]
        return profiles.flatten(on: conn).map { _ in  ()}
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return .done(on: conn)
    }
}
