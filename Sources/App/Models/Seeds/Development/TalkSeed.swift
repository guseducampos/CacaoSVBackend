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
            return Talk(id: nil, meetupId: try meetup.requireID(), speakerId: profile.profileId, topic: "Swift", description: "Programming Language", createdAt: nil).save(on: conn)
            }.toVoid()
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return .done(on: conn)
    }
    
    private static func getSpeaker(on conn: PostgreSQLConnection) -> Future<ProfileTypePivot> {
        return ProfileTypePivot.query(on: conn).filter(\.profileTypeId == ProfileTypes.speaker.rawValue).unwrapFirst(or: Abort(.notFound,  reason: "there are no profile pivot with profile type speaker"))
    }
    
    private static func getMeetup(on conn: PostgreSQLConnection) -> Future<Meetup> {
        return Meetup.query(on: conn).unwrapFirst(or: Abort(.notFound, reason: "There are no meetups"))
    }
}
