//Controller for Users
import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.get(use:index)
        users.post(use: create)
        users.put(use: update)
        users.group(":userID") { user in
            user.delete(use: delete)
        }
    }
    
    func index(req: Request) throws -> EventLoopFuture<[User]> {
        return User.query(on: req.db).all()
    }
    
    func create(req:Request) throws -> EventLoopFuture<HTTPStatus>{
        let user = try req.content.decode(User.self)
        return user.save(on: req.db).transform(to: .ok)
    }
    
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let user = try req.content.decode(User.self)
        
        return User.find(user.id ,on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{
                $0.username = user.username
                return $0.update(on: req.db).transform(to: .ok)
            }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{ $0.delete(on: req.db)}
            .transform(to: .ok)
    }
}
