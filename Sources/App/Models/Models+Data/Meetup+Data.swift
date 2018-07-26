//
//  Meetup+Data.swift
//  App
//
//  Created by  LaptopGCampos on 7/26/18.
//

import Vapor
import Fluent

extension Meetup {
    
    static func speakersForMeetup(withStatus status: Status, on request: Request) -> Future<[Profile]> {
        return Meetup.query(on: request).filter(\.statusID == Status.scheduled.rawValue).unwrapFirst(or: Abort(.notFound)).flatMap { meetup -> Future<[Profile]> in
            return try speakersFor(meetup: meetup, on: request)
        }
    }
    
    static func speakersFor(meetup: Meetup, on request: Request) throws -> Future<[Profile]> {
        return try meetup.talks.query(on: request).all().flatMap { talks -> Future<[Profile]> in
            return talks.map { $0.speaker.get(on: request) }.flatten(on: request)
        }
    }
}
