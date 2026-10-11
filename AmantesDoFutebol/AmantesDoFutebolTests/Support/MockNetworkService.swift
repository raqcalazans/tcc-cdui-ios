@testable import AmantesDoFutebol

final class MockNetworkService: NetworkServiceProtocol {
    var fans: [Fan] = []
    var teams: [TeamDTO] = []
    var shouldFailFans = false
    var shouldFailTeams = false
    var shouldFailSave = false
    var shouldFailFetchFan = false
    var shouldFailDelete = false
    var createCount = 0
    var updateCount = 0
    var updatedID: Int?
    var deletedID: Int?
    var lastPayload: FanPayload?

    func fetchTeams() async throws -> [TeamDTO] {
        if shouldFailTeams { throw TestError.network }
        return teams
    }

    func fetchFans() async throws -> [Fan] {
        if shouldFailFans { throw TestError.network }
        return fans
    }

    func fetchFan(id: Int) async throws -> Fan {
        if shouldFailFetchFan { throw TestError.network }
        return fans.first { $0.id == id } ?? FanFixtures.make(id: id)
    }

    func createFan(payload: FanPayload) async throws -> Fan {
        if shouldFailSave { throw TestError.network }
        createCount += 1
        lastPayload = payload
        return FanFixtures.make()
    }

    func updateFan(id: Int, payload: FanPayload) async throws -> Fan {
        if shouldFailSave { throw TestError.network }
        updateCount += 1
        updatedID = id
        lastPayload = payload
        return FanFixtures.make(id: id)
    }

    func deleteFan(id: Int) async throws {
        if shouldFailDelete { throw TestError.network }
        deletedID = id
    }
}
