import Testing
import VaporTesting

@testable import TheEntertainmentDatabase

@Suite("App Tests")
struct TheEntertainmentDatabaseTests {
    @Test("Test Hello World Route")
    func helloWorld() async throws {
        try await withApp(configure: configure) { app in
            try await app.testing().test(
                .GET, "hello",
                afterResponse: { res async in
                    #expect(res.status == .ok)
                    #expect(res.body.string == "Hello, world!")
                })
        }
    }
}
