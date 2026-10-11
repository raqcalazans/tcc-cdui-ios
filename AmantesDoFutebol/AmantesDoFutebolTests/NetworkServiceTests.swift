import Foundation
import XCTest
@testable import AmantesDoFutebol

final class NetworkServiceTests: XCTestCase {
    private var service: NetworkService!

    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        service = NetworkService(session: URLSession(configuration: configuration), baseURL: "https://api.test")
    }

    override func tearDown() {
        StubURLProtocol.handler = nil
        service = nil
    }

    func testFetchTeamsDecodesTeamList() async throws {
        StubURLProtocol.handler = { request in
            XCTAssertEqual(request.url?.path, "/api/v1/teams")
            return NetworkFixtures.response(request, status: 200, body: #"[{"id":"FLA","name":"Flamengo"}]"#)
        }

        let teams = try await service.fetchTeams()

        XCTAssertEqual(teams, [TeamDTO(id: "FLA", name: "Flamengo")])
    }

    func testFetchTeamsRejectsNon200Response() async {
        StubURLProtocol.handler = { request in NetworkFixtures.response(request, status: 503, body: "[]") }
        await assertThrows { _ = try await self.service.fetchTeams() }
    }

    func testFetchFansDecodesList() async throws {
        StubURLProtocol.handler = { request in NetworkFixtures.response(request, status: 200, body: "[\(NetworkFixtures.fanJSON)]") }

        let fans = try await service.fetchFans()

        XCTAssertEqual(fans, [NetworkFixtures.fan])
    }

    func testFetchFansRejectsMalformedBody() async {
        StubURLProtocol.handler = { request in NetworkFixtures.response(request, status: 200, body: "invalid") }
        await assertThrows { _ = try await self.service.fetchFans() }
    }

    func testFetchFanDecodesOneRecord() async throws {
        StubURLProtocol.handler = { request in
            XCTAssertEqual(request.url?.path, "/api/v1/fans/4")
            return NetworkFixtures.response(request, status: 200, body: NetworkFixtures.fanJSON)
        }

        let fan = try await service.fetchFan(id: 4)
        XCTAssertEqual(fan, NetworkFixtures.fan)
    }

    func testFetchFanRejectsNotFound() async {
        StubURLProtocol.handler = { request in NetworkFixtures.response(request, status: 404, body: "{}") }
        await assertThrows { _ = try await self.service.fetchFan(id: 99) }
    }

    func testCreateAndUpdateEncodePayloadAndDecodeResult() async throws {
        let payload = FanPayload(name: "A", email: "a@b.com", birthDate: "2000-01-01", gender: "X", favoriteTeamId: "FLA", city: "Rio", state: "RJ", country: "Brasil", stadiumFrequency: .asVezes)
        StubURLProtocol.handler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.url?.path, "/api/v1/fans")
            try NetworkFixtures.assertRequestBody(request, contains: #""favoriteTeamId":"FLA""#)
            return NetworkFixtures.response(request, status: 201, body: NetworkFixtures.fanJSON)
        }
        let createdFan = try await service.createFan(payload: payload)
        XCTAssertEqual(createdFan, NetworkFixtures.fan)

        StubURLProtocol.handler = { request in
            XCTAssertEqual(request.httpMethod, "PUT")
            XCTAssertEqual(request.url?.path, "/api/v1/fans/4")
            try NetworkFixtures.assertRequestBody(request, contains: #""stadiumFrequency":"AS_VEZES""#)
            return NetworkFixtures.response(request, status: 200, body: NetworkFixtures.fanJSON)
        }
        let updatedFan = try await service.updateFan(id: 4, payload: payload)
        XCTAssertEqual(updatedFan, NetworkFixtures.fan)
    }

    func testDeleteAcceptsNoContent() async throws {
        StubURLProtocol.handler = { request in
            XCTAssertEqual(request.httpMethod, "DELETE")
            XCTAssertEqual(request.url?.path, "/api/v1/fans/4")
            return NetworkFixtures.response(request, status: 204, body: "")
        }

        try await service.deleteFan(id: 4)
    }

    func testDeleteRejectsServerError() async {
        StubURLProtocol.handler = { request in NetworkFixtures.response(request, status: 500, body: "") }
        await assertThrows { try await self.service.deleteFan(id: 4) }
    }

    func testInvalidBaseURLIsRejected() async {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        let invalidService = NetworkService(session: URLSession(configuration: configuration), baseURL: "http://[")

        await assertThrows { _ = try await invalidService.fetchFan(id: 1) }
        await assertThrows { try await invalidService.deleteFan(id: 1) }
        await assertThrows { _ = try await invalidService.fetchTeams() }
    }

    private func assertThrows(_ operation: () async throws -> Void, file: StaticString = #filePath, line: UInt = #line) async {
        do {
            try await operation()
            XCTFail("Esperava uma falha", file: file, line: line)
        } catch { }
    }
}
