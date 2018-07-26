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
    }
    
    func currentSpeakers(_ request: Request) throws -> Future<[Profile]> {
        return Meetup.speakersForMeetup(withStatus: .scheduled, on: request)
    }
}
