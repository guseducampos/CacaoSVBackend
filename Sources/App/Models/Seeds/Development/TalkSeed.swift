//
//  TalkSeed.swift
//  App
//
//  Created by  LaptopGCampos on 7/11/18.
//

import FluentPostgreSQL


struct TalkSeed: Migration {
    
    typealias Database = PostgreSQLDatabase
    
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        let talk = Talk(id: nil, meetupId: 1, speakerId: 1, topic: "Swift", description: "Programming Language", createdAt: nil)
        return talk.save(on: conn).map {_ in ()}
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return .done(on: conn)
    }
    
}
