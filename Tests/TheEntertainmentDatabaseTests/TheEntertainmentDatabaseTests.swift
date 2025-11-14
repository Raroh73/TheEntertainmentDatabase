import Testing
import VaporTesting

@testable import TheEntertainmentDatabase

@Suite("App Tests")
struct TheEntertainmentDatabaseTests {
    private func withApp(_ test: (Application) async throws -> Void) async throws {
        let app = try await Application.make(.testing)
        do {
            try await configure(app)
            try await app.autoMigrate()
            try await test(app)
            try await app.autoRevert()
        } catch {
            try? await app.autoRevert()
            try await app.asyncShutdown()
            throw error
        }
        try await app.asyncShutdown()
    }

    @Test("Test Hello World Route")
    func helloWorld() async throws {
        try await withApp { app in
            try await app.testing().test(
                .GET, "hello",
                afterResponse: { res async in
                    #expect(res.status == .ok)
                    #expect(res.body.string == "Hello, world!")
                })
        }
    }

    @Test("Get an Index")
    func getIndex() async throws {
        try await withApp { app in
            let movies = [
                Movie(title: "Test Title", year: 2000, description: "Test Description"),
                Movie(title: "Test Title 2", year: 2001, description: "Test Description 2"),
            ]
            try await movies.create(on: app.db)

            let view: String = try await app.view.render("movies", ["movies": movies]).get().data
                .string

            try await app.testing().test(
                .GET, "movies",
                afterResponse: { res async throws in
                    #expect(res.status == .ok)
                    #expect(res.body.string == view)
                    let model = try await Movie.query(on: app.db).all()
                    #expect(model[0].title == movies[0].title)
                    #expect(model[1].title == movies[1].title)
                })
        }
    }

    @Test("Post a Movie")
    func postMovie() async throws {
        try await withApp { app in
            let movie = Movie(title: "Test Title", year: 2000, description: "Test Description")

            let view: String = try await app.view.render("movie", ["movie": movie]).get().data
                .string

            try await app.testing().test(
                .POST, "movies", beforeRequest: { req in try req.content.encode(movie) },
                afterResponse: { res async throws in
                    #expect(res.status == .ok)
                    #expect(res.body.string == view)
                    let model = try await Movie.query(on: app.db).first()
                    #expect(model?.title == movie.title)
                })
        }
    }

    @Test("Read a Movie")
    func getMovie() async throws {
        try await withApp { app in
            let movie = Movie(title: "Test Title", year: 2000, description: "Test Description")
            try await movie.create(on: app.db)

            let view: String = try await app.view.render("movie", ["movie": movie]).get().data
                .string

            try await app.testing().test(
                .GET, "movies/\(movie.requireID())",
                afterResponse: { res async throws in
                    #expect(res.status == .ok)
                    #expect(res.body.string == view)
                    let model = try await Movie.query(on: app.db).first()
                    #expect(model?.title == movie.title)
                })
        }
    }

    @Test("Delete a Movie")
    func deleteMovie() async throws {
        try await withApp { app in
            let movie = Movie(title: "Test Title", year: 2000, description: "Test Description")
            try await movie.create(on: app.db)

            try await app.testing().test(
                .DELETE, "movies/\(movie.requireID())",
                afterResponse: { res async throws in
                    #expect(res.status == .noContent)
                    let model = try await Movie.find(movie.id, on: app.db)
                    #expect(model == nil)
                })
        }
    }
}
