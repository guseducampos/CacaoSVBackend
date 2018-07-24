//
//  ProfileController.swift
//  App
//
//  Created by  LaptopGCampos on 7/9/18.
//

import Vapor
import Fluent

struct MeetupController: RouteCollection {
    
    func boot(router: Router) throws {
        let publicRoutes = router.grouped("meetup")
        publicRoutes.get("currentSpeakers", use: currentSpeakers)
        publicRoutes.get("currentMeetup",   use: currentMeetup)
        publicRoutes.get("currentTalks",    use: currentTalks)
    }
    
    func currentTalks(_ request: Request) throws -> Future<[Talk]> {
        return try getMeetup(byStatus: .scheduled, on: request).flatMap { meetup in
            return try self.getTalksFrom(meetup: meetup, on: request)
        }
    }
    
    func currentSpeakers(_ request: Request) throws -> Future<[Profile]> {
        return try currentTalks(request).flatMap { talks -> Future<[Profile]> in
            return talks.map { $0.speaker.get(on: request) }.flatten(on: request)
        }
    }
    
    func currentMeetup(_ request: Request) throws -> Future<Meetup> {
        return try getMeetup(byStatus: .scheduled, on: request)
    }
    
    private func getMeetup(byStatus status: Status, on request: Request) throws -> Future<Meetup> {
        return  Meetup.query(on: request).filter(\.statusID == status.rawValue).first().unwrap(or: Abort(.notFound))
    }
    
    private func getTalksFrom(meetup: Meetup, on request: Request) throws -> Future<[Talk]> {
        return try meetup.talks.query(on: request).all().whenIsEmpty(Abort(.notFound))
    }
}
