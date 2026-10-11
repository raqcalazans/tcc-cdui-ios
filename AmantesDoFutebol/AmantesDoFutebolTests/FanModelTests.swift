import XCTest
@testable import AmantesDoFutebol

final class FanModelTests: XCTestCase {
    func testLocationAndFrequencyLabels() {
        let fan = FanFixtures.make()

        XCTAssertEqual(fan.location, "São Paulo, SP, Brasil")
        XCTAssertEqual(StadiumFrequency.allCases.map(\.title), ["Sempre", "Às vezes", "Raramente", "Nunca"])
        XCTAssertEqual(StadiumFrequency(rawValue: "AS_VEZES"), .asVezes)
    }
}
