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
        let publicRoutes = router.grouped("api", "meetup")
        publicRoutes.get("currentSpeakers", use: currentSpeakers)
        publicRoutes.get("currentMeetup", use: currentMeetup)
        publicRoutes.get("currentTalks", use: currentTalks)
    }
    
    func currentSpeakers(_ request: Request) throws -> Future<[Profile]> {
        return Meetup.speakersForMeetup(withStatus: .scheduled, on: request)
    }
    
    func currentMeetup(_ request: Request) throws -> Future<Meetup> {
        return  Meetup.meetup(byStatus: .scheduled, on: request)
    }
    
    func currentTalks(_ request: Request) throws -> Future<[Talk]> {
       return Meetup.meetupTalks(withStatus: .scheduled, on: request)
    }
}
