//
//  ProfileSeed.swift
//  App
//
//  Created by  LaptopGCampos on 7/11/18.
//

import FluentPostgreSQL

struct ProfileSeed: Migration {
    
    typealias Database = PostgreSQLDatabase
    
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        let profile = Profile(id: nil,
                              name: "Gustavo", lastname: "Campos", email: "guseducampos@gmail.com",
                              password: nil, currentJob: "iOS Developer",
                              profileDescription: "iOS dev", gitProfile: "test",
                              twitter: "test", linkedin: "test", createdAt: nil)
        return profile.save(on: conn).toVoid()
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return .done(on: conn)
    }
}
