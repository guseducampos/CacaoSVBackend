import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    let meetupController = MeetupController()
    
    try router.register(collection: meetupController)
}
