import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {

    let routeGrouped = router.grouped("api")
    
    let meetupController = MeetupController()
    let profileController = ProfileController()
    
    try routeGrouped.register(collection: meetupController, profileController)
}
