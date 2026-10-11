import Foundation
import XCTest
@testable import AmantesDoFutebol

enum NetworkFixtures {
    static let fanJSON = #"{"id":4,"name":"Ana","email":"ana@example.com","birthDate":"1990-01-02","gender":"Feminino","favoriteTeamId":"FLA","city":"Rio","state":"RJ","country":"Brasil","stadiumFrequency":"SEMPRE"}"#
    static let fan = Fan(id: 4, name: "Ana", email: "ana@example.com", birthDate: "1990-01-02", gender: "Feminino", favoriteTeamId: "FLA", city: "Rio", state: "RJ", country: "Brasil", stadiumFrequency: .sempre)

    static func response(_ request: URLRequest, status: Int, body: String) -> (HTTPURLResponse, Data) {
        let response = HTTPURLResponse(url: request.url!, statusCode: status, httpVersion: nil, headerFields: nil)!
        return (response, Data(body.utf8))
    }

    static func assertRequestBody(_ request: URLRequest, contains value: String) throws {
        let data: Data
        if let httpBody = request.httpBody {
            data = httpBody
        } else if let stream = request.httpBodyStream {
            data = try readBody(from: stream)
        } else {
            throw NSError(domain: "NetworkFixtures", code: 1, userInfo: [NSLocalizedDescriptionKey: "A requisição não contém um corpo."])
        }

        let body = String(decoding: data, as: UTF8.self)
        XCTAssertTrue(body.contains(value), body)
    }

    private static func readBody(from stream: InputStream) throws -> Data {
        stream.open()
        defer { stream.close() }

        var data = Data()
        var buffer = [UInt8](repeating: 0, count: 1_024)
        while stream.hasBytesAvailable {
            let bytesRead = stream.read(&buffer, maxLength: buffer.count)
            if bytesRead < 0 {
                throw stream.streamError ?? NSError(domain: "NetworkFixtures", code: 2)
            }
            if bytesRead == 0 { break }
            data.append(contentsOf: buffer.prefix(bytesRead))
        }
        return data
    }
}
