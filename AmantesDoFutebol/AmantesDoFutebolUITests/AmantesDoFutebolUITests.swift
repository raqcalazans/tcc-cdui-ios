import XCTest

final class AmantesDoFutebolUITests: XCTestCase {
    @MainActor
    func testScreenshotHomeScreen() {
        let app = launchScreenshotApp()

        XCTAssertTrue(app.navigationBars["Amantes do Futebol"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.descendants(matching: .any)["fanRow_1"].waitForExistence(timeout: 5))
        attachScreenshot(of: app, named: "Home")
    }

    @MainActor
    func testScreenshotRegistrationScreen() {
        let app = launchScreenshotApp()
        let addButton = app.buttons["addFanButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()

        XCTAssertTrue(app.navigationBars["Cadastro de fã"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.textFields["birthDateField"].exists)
        XCTAssertTrue(app.descendants(matching: .any)["genderPicker"].exists)
        attachScreenshot(of: app, named: "Cadastro de fã")
    }

    @MainActor
    func testScreenshotFanDetailsScreen() {
        let app = launchScreenshotApp()
        let fanRow = app.descendants(matching: .any)["fanRow_1"]
        XCTAssertTrue(fanRow.waitForExistence(timeout: 5))
        fanRow.tap()

        XCTAssertTrue(app.navigationBars["Detalhes do fã"].waitForExistence(timeout: 5))
        let nameRow = app.descendants(matching: .any)["detailRow_Nome"]
        let birthDateRow = app.descendants(matching: .any)["detailRow_Data de nascimento"]
        XCTAssertTrue(nameRow.waitForExistence(timeout: 5))
        let nameContent = "\(nameRow.label) \(String(describing: nameRow.value ?? ""))"
        XCTAssertTrue(nameContent.contains("Camila Torres"), nameContent)
        XCTAssertTrue(birthDateRow.waitForExistence(timeout: 5))
        let birthDateContent = "\(birthDateRow.label) \(String(describing: birthDateRow.value ?? ""))"
        XCTAssertTrue(birthDateContent.contains("14/08/1995"), birthDateContent)
        XCTAssertTrue(app.buttons["deleteFanButton"].exists)
        attachScreenshot(of: app, named: "Detalhes do fã")
    }

    @MainActor
    func testHomeShowsAppNameAndAddButton() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.navigationBars["Amantes do Futebol"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["addFanButton"].exists)
    }

    @MainActor
    func testAddButtonOpensFanRegistrationForm() {
        let app = XCUIApplication()
        app.launch()
        let addButton = app.buttons["addFanButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5))
        addButton.tap()

        XCTAssertTrue(app.navigationBars["Cadastro de fã"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.textFields["Nome"].exists)
        XCTAssertTrue(app.textFields["E-mail"].exists)
        XCTAssertTrue(app.textFields["birthDateField"].exists)
        XCTAssertTrue(app.descendants(matching: .any)["genderPicker"].exists)
        XCTAssertTrue(app.buttons["Cadastrar fã"].exists)
    }

    @MainActor
    private func launchScreenshotApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["--screenshot-tests"]
        app.launch()
        return app
    }

    @MainActor
    private func attachScreenshot(of app: XCUIApplication, named name: String) {
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)

        let repositoryRoot = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        let screenshotsDirectory = repositoryRoot.appendingPathComponent("Screenshots", isDirectory: true)
        let fileName = name == "Home" ? "Home.png" : name == "Cadastro de fã" ? "Cadastro.png" : "Detalhes.png"

        do {
            try FileManager.default.createDirectory(at: screenshotsDirectory, withIntermediateDirectories: true)
            try screenshot.pngRepresentation.write(to: screenshotsDirectory.appendingPathComponent(fileName), options: .atomic)
        } catch {
            XCTFail("Não foi possível salvar o screenshot \(fileName): \(error)")
        }
    }
}
