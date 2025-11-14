import Fluent
import Vapor

struct MoviesController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let movies = routes.grouped("movies")
        movies.get(use: self.index)
        movies.post(use: self.create)
        movies.group(":ID") { movie in
            movie.get(use: self.read)
            movie.delete(use: self.delete)
        }
    }

    @Sendable
    func index(req: Request) async throws -> View {
        let movies = try await Movie.query(on: req.db).all()

        return try await req.view.render("movies", ["movies": movies])
    }

    @Sendable
    func create(req: Request) async throws -> View {
        let movie = try req.content.decode(Movie.self)
        try await movie.save(on: req.db)

        return try await req.view.render("movie", ["movie": movie])
    }

    @Sendable
    func read(req: Request) async throws -> View {
        let movie = try await Movie.find(req.parameters.get("ID"), on: req.db)

        return try await req.view.render("movie", ["movie": movie])
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        let movie = try await Movie.find(req.parameters.get("ID"), on: req.db)
        try await movie?.delete(on: req.db)

        return .noContent
    }
}
