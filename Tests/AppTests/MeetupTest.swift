//
//  MeetupTest.swift
//  App
//
//  Created by  LaptopGCampos on 7/12/18.
//

@testable import App
import XCTest
import Vapor
import FluentPostgreSQL

final class MeetupTest: XCTestCase {
    
    func testCurrentMeetupSpeakers() throws {
        let app = try Application.testable()
        let conn = try app.newConnection(to: .psql).wait()
        let responder = try app.make(Responder.self)
        let request = HTTPRequest(method: .GET, url: "/api/meetup/currentSpeakers")
        let wrappedRequest = Request(http: request, using: app)
        let response = try responder.respond(to: wrappedRequest).wait()
        let data = response.http.body.data
        let profiles = try JSONDecoder().decode([Profile].self, from: data!)
        
        XCTAssertEqual(profiles.count, 1)
        XCTAssertEqual(profiles[0].email, "guseducampos@gmail.com")
        XCTAssertEqual(profiles[0].name, "Gustavo")
        
        conn.close()
    }
    
    
}
