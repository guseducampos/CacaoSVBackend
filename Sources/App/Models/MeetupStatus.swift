//
//  MeetupStatus.swift
//  App
//
//  Created by Gustavo Campos on 7/1/18.
//

import FluentPostgreSQL

struct MeetupStatus: PostgreSQLModel, Migration {
    
    var id: Int?
    
    var name: String
    
    var createdAt: Date?
    
    var meetups: Children<MeetupStatus, Meetup> {
        return children(\.statusID)
    }
    
    static let createdAtKey: TimestampKey? = \.createdAt
    
    static func revert(on connection: PostgreSQLConnection) -> Future<Void> {
         return Database.delete(MeetupStatus.self, on: connection)
    }
}
