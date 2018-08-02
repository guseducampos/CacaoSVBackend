//
//  Meetup.swift
//  App
//
//  Created by Gustavo Campos on 7/1/18.
//

import FluentPostgreSQL
import Vapor

enum Status: Int, CustomStringConvertible {
    case scheduled = 1
    case done
    case cancelled
    case inProgress
    
    var description: String {
        switch self {
        case .scheduled:
            return "Scheduled"
        case .done:
            return "Done"
        case .cancelled:
            return "Cancelled"
        case .inProgress:
            return "In Progress"
        }
    }
}

struct Meetup: PostgreSQLUUIDModel {
    
    static let IdKey: IDKey = \.id
    
    var id: UUID?
    
    var statusID: MeetupStatus.ID
    
    var name: String
    
    var eventDate: Date
    
    var createdAt: Date?

    static let createdAtKey: TimestampKey? = \.createdAt
}

extension Meetup {
    
    var meetupStatus: Parent<Meetup, MeetupStatus> {
        return parent(\.statusID)
    }
    
    var talks: Children<Meetup, Talk> {
        return children(\.meetupId)
    }
}

extension Meetup: Migration {
    
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
             builder.reference(from: \Meetup.statusID, to: \MeetupStatus.id)
        }
    }
}

extension Meetup: Content {}

extension Meetup: Parameter {}
