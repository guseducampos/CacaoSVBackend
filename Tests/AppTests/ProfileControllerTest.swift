//
//  ProfileControllerTest.swift
//  App
//
//  Created by  LaptopGCampos on 7/24/18.
//

@testable import App
import XCTest
import Vapor
import FluentPostgreSQL

final class ProfileControllerTest: BaseTest {
    
    func testGetCommunityMembers() throws {
        let profiles = try app.getRequest(to: "/api/profile/communityMembers", method: .GET, decodeTo: [Profile].self)
        dump(profiles)
        XCTAssertEqual(profiles.count, 1)
        XCTAssertEqual(profiles.first?.email, "guseducampos@gmail.com")
        XCTAssertEqual(profiles.first?.name, "Gustavo")
    }
    
    func testEmptyCommunityMembers() throws {
        var profileTypePivot = try ProfileTypePivot.query(on: conn).filter(\.profileTypeId == ProfileTypes.community.rawValue).first().unwrap(or: Abort(.notFound)).wait()
        profileTypePivot.profileTypeId = 2
        _ = try profileTypePivot.update(on: conn).wait()
        let response = try app.sendRequest(to: "/api/profile/communityMember", method: .GET)
        XCTAssertEqual(response.http.status.code, 404)
        try reset()
    }
    
    static let allTests = [
        ("testGetCommunityMembers", testGetCommunityMembers),
        ("testEmptyCommunityMembers", testEmptyCommunityMembers)
    ]
}
