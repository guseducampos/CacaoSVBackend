//
//  TalkSeed.swift
//  App
//
//  Created by  LaptopGCampos on 7/11/18.
//

import FluentPostgreSQL
import Vapor

struct TalkSeed: Migration {
    
    typealias Database = PostgreSQLDatabase
    
    static func prepare(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return flatMap(to: Talk.self, getSpeaker(on: conn), getMeetup(on: conn)) { (profile, meetup) -> Future<Talk> in
            return Talk(id: nil, meetupId: try meetup.requireID(), speakerId: try profile.requireID(), topic: "Swift", description: "Programming Language", createdAt: nil).save(on: conn)
            }.toVoid()
        
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return .done(on: conn)
    }
    
    
    private static func getSpeaker(on conn: PostgreSQLConnection) -> Future<Profile> {
        return ProfileType.query(on: conn).filter(\.id == 1).unwrapFirst(or: Abort(.notFound)).flatMap { profileType in
            return try  profileType.profiles.query(on: conn).unwrapFirst(or: Abort(.notFound))
        }
    }
    
    private static func getMeetup(on conn: PostgreSQLConnection) -> Future<Meetup> {
        return Meetup.query(on: conn).unwrapFirst(or: Abort(.notFound))
    }
}
