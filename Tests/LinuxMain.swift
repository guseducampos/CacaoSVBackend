import XCTest

@testable import AppTests

XCTMain([
    testCase(MeetupTest.allTests),
    testCase(ProfileControllerTest.allTests)
])
