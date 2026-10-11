import XCTest
@testable import AmantesDoFutebol

@MainActor
final class FanListViewModelTests: XCTestCase {
    func testLoadsFansSortedByIDAndMapsTeamNames() async {
        let service = MockNetworkService()
        service.fans = [FanFixtures.make(id: 8), FanFixtures.make(id: 2)]
        service.teams = [TeamDTO(id: "PAL", name: "Palmeiras")]
        let viewModel = FanListViewModel(networkService: service)

        await viewModel.loadFans()

        XCTAssertEqual(viewModel.fans.map(\.id), [2, 8])
        XCTAssertEqual(viewModel.teamNames["PAL"], "Palmeiras")
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testKeepsFansWhenTeamsCannotLoad() async {
        let service = MockNetworkService()
        service.fans = [FanFixtures.make()]
        service.shouldFailTeams = true
        let viewModel = FanListViewModel(networkService: service)

        await viewModel.loadFans()

        XCTAssertEqual(viewModel.fans.count, 1)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testSetsErrorWhenFansCannotLoad() async {
        let service = MockNetworkService()
        service.shouldFailFans = true
        let viewModel = FanListViewModel(networkService: service)

        await viewModel.loadFans()

        XCTAssertTrue(viewModel.fans.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, "Não foi possível carregar os fãs. Verifique sua conexão e tente novamente.")
        XCTAssertFalse(viewModel.isLoading)
    }
}
