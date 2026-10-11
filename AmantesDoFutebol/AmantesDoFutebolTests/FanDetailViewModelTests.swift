import XCTest
@testable import AmantesDoFutebol

@MainActor
final class FanDetailViewModelTests: XCTestCase {
    func testRefreshLoadsFanAndTeamName() async {
        let service = MockNetworkService()
        service.fans = [FanFixtures.make()]
        service.teams = [TeamDTO(id: "FLA", name: "Flamengo")]
        let viewModel = FanDetailViewModel(fan: FanFixtures.make(), networkService: service)

        await viewModel.refresh()

        XCTAssertEqual(viewModel.fan.id, 4)
        XCTAssertEqual(viewModel.formattedBirthDate, "02/01/1990")
        XCTAssertNotEqual(viewModel.ageDescription, "—")
        XCTAssertEqual(viewModel.favoriteTeamName, "Flamengo")
        XCTAssertNil(viewModel.errorMessage)
    }

    func testRefreshUsesTeamIDWhenCatalogFails() async {
        let service = MockNetworkService()
        service.fans = [FanFixtures.make()]
        service.shouldFailTeams = true
        let viewModel = FanDetailViewModel(fan: FanFixtures.make(), networkService: service)

        await viewModel.refresh()

        XCTAssertEqual(viewModel.favoriteTeamName, "FLA")
        XCTAssertNil(viewModel.errorMessage)
    }

    func testRefreshFailureSetsMessage() async {
        let service = MockNetworkService()
        service.shouldFailFetchFan = true
        let viewModel = FanDetailViewModel(fan: FanFixtures.make(), networkService: service)

        await viewModel.refresh()

        XCTAssertEqual(viewModel.errorMessage, "Não foi possível atualizar os dados deste fã.")
    }

    func testDeleteDelegatesFanID() async throws {
        let service = MockNetworkService()
        let viewModel = FanDetailViewModel(fan: FanFixtures.make(id: 22), networkService: service)

        try await viewModel.delete()

        XCTAssertEqual(service.deletedID, 22)
    }

    func testDeletePropagatesError() async {
        let service = MockNetworkService()
        service.shouldFailDelete = true
        let viewModel = FanDetailViewModel(fan: FanFixtures.make(), networkService: service)

        do {
            try await viewModel.delete()
            XCTFail("Esperava que a falha ao excluir fosse propagada")
        } catch {
            XCTAssertEqual(error as? TestError, .network)
        }
    }
}
