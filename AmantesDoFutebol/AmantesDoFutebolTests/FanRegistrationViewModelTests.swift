import XCTest
@testable import AmantesDoFutebol

@MainActor
final class FanRegistrationViewModelTests: XCTestCase {
    func testDefaultsAndLoadsFirstTeam() async {
        let service = MockNetworkService()
        service.teams = [TeamDTO(id: "FLA", name: "Flamengo")]
        let viewModel = FanRegistrationViewModel(networkService: service)

        XCTAssertFalse(viewModel.isEditing)
        XCTAssertEqual(viewModel.name, "")
        XCTAssertEqual(viewModel.stadiumFrequency, .nunca)
        await viewModel.loadTeams()

        XCTAssertEqual(viewModel.favoriteTeamId, "FLA")
        XCTAssertEqual(viewModel.teams.count, 1)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testGenderOptionsAreTheSupportedChoices() {
        XCTAssertEqual(FanRegistrationViewModel.genderOptions, ["Feminino", "Masculino", "Não Binário"])
    }

    func testBirthDateInputAddsSeparatorsAsUserTypes() {
        let viewModel = FanRegistrationViewModel(networkService: MockNetworkService())

        viewModel.updateBirthDateInput("03071990")

        XCTAssertEqual(viewModel.birthDate, "03/07/1990")
    }

    func testBirthDateInputLimitsDigitsAndPreservesPartialSeparators() {
        let viewModel = FanRegistrationViewModel(networkService: MockNetworkService())

        viewModel.updateBirthDateInput("031219901234")

        XCTAssertEqual(viewModel.birthDate, "03/12/1990")
    }

    func testExistingISODateIsDisplayedInBrazilianFormat() {
        let fan = FanFixtures.make()
        let viewModel = FanRegistrationViewModel(fan: fan, networkService: MockNetworkService())

        XCTAssertEqual(viewModel.birthDate, "02/01/1990")
    }

    func testKeepsExistingTeamWhenLoadingTeams() async {
        let service = MockNetworkService()
        service.teams = [TeamDTO(id: "PAL", name: "Palmeiras")]
        let viewModel = FanRegistrationViewModel(fan: FanFixtures.make(favoriteTeamId: "FLA"), networkService: service)

        await viewModel.loadTeams()

        XCTAssertTrue(viewModel.isEditing)
        XCTAssertEqual(viewModel.favoriteTeamId, "FLA")
    }

    func testEmptyTeamCatalogKeepsTeamUnselected() async {
        let viewModel = FanRegistrationViewModel(networkService: MockNetworkService())

        await viewModel.loadTeams()

        XCTAssertTrue(viewModel.teams.isEmpty)
        XCTAssertEqual(viewModel.favoriteTeamId, "")
    }

    func testTeamLoadFailureSetsMessage() async {
        let service = MockNetworkService()
        service.shouldFailTeams = true
        let viewModel = FanRegistrationViewModel(networkService: service)

        await viewModel.loadTeams()

        XCTAssertEqual(viewModel.errorMessage, "Não foi possível carregar os times. Tente novamente.")
    }

    func testCreateTrimsFieldsAndSubmitsPayload() async throws {
        let service = MockNetworkService()
        service.teams = [TeamDTO(id: "FLA", name: "Flamengo")]
        let viewModel = FanRegistrationViewModel(networkService: service)
        await viewModel.loadTeams()
        fillForm(viewModel)

        try await viewModel.save()

        XCTAssertEqual(service.createCount, 1)
        XCTAssertEqual(service.lastPayload?.name, "Ana Silva")
        XCTAssertEqual(service.lastPayload?.email, "ana@example.com")
        XCTAssertEqual(service.lastPayload?.birthDate, "1990-02-03")
        XCTAssertEqual(service.lastPayload?.gender, "Feminino")
        XCTAssertEqual(service.lastPayload?.favoriteTeamId, "FLA")
        XCTAssertEqual(service.lastPayload?.city, "Rio")
        XCTAssertEqual(service.lastPayload?.state, "RJ")
        XCTAssertEqual(service.lastPayload?.country, "Brasil")
        XCTAssertEqual(service.lastPayload?.stadiumFrequency, .sempre)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testUpdateUsesFanID() async throws {
        let service = MockNetworkService()
        service.teams = [TeamDTO(id: "FLA", name: "Flamengo")]
        let viewModel = FanRegistrationViewModel(fan: FanFixtures.make(id: 17), networkService: service)
        await viewModel.loadTeams()

        try await viewModel.save()

        XCTAssertEqual(service.updateCount, 1)
        XCTAssertEqual(service.updatedID, 17)
    }

    func testSaveFailureResetsLoadingAndPropagatesError() async {
        let service = MockNetworkService()
        service.teams = [TeamDTO(id: "FLA", name: "Flamengo")]
        service.shouldFailSave = true
        let viewModel = FanRegistrationViewModel(networkService: service)
        await viewModel.loadTeams()
        fillForm(viewModel)

        do {
            try await viewModel.save()
            XCTFail("Esperava que o erro de rede fosse propagado")
        } catch {
            XCTAssertEqual(error as? TestError, .network)
        }
        XCTAssertFalse(viewModel.isLoading)
    }

    private func fillForm(_ viewModel: FanRegistrationViewModel) {
        viewModel.name = " Ana Silva "
        viewModel.email = " ana@example.com "
        viewModel.birthDate = " 03/02/1990 "
        viewModel.gender = " Feminino "
        viewModel.favoriteTeamId = "FLA"
        viewModel.city = " Rio "
        viewModel.state = " RJ "
        viewModel.country = " Brasil "
        viewModel.stadiumFrequency = .sempre
    }
}
