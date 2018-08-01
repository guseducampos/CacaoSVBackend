//
//  MeetupSeed.swift
//  App
//
//  Created by  LaptopGCampos on 7/11/18.
//

import FluentPostgreSQL

struct MeetupSeed: Migration {
    
    typealias Database = PostgreSQLDatabase
    
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        let meetup = Meetup(id: nil, statusID: 1, name: "test", eventDate: Date(), createdAt: nil)
        return meetup.save(on: conn).toVoid()
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return Meetup.query(on: conn).filter(\.statusID == 1).delete()
    }
    
}
