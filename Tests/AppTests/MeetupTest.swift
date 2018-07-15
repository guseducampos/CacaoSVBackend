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
        let profiles = try app.getRequest(to: "/api/meetup/currentSpeakers", method: .GET, decodeTo: [Profile].self)
        XCTAssertEqual(profiles.count, 1)
        XCTAssertEqual(profiles[0].email, "guseducampos@gmail.com")
        XCTAssertEqual(profiles[0].name, "Gustavo")
        conn.close()
    }
    
    static let allTests = [
        ("testCurrentMeetupSpeakers", testCurrentMeetupSpeakers)
    ]
}
