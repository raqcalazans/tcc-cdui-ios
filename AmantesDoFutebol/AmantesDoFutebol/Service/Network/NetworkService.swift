import Foundation

class NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()
    private let baseURL: String
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, baseURL: String = "http://localhost:8080") {
        self.session = session
        self.baseURL = baseURL
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    func fetchTeams() async throws -> [TeamDTO] {
        guard let url = URL(string: "\(baseURL)/api/v1/teams") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try decoder.decode([TeamDTO].self, from: data)
    }
    
    func fetchFans() async throws -> [Fan] {
        try await request(path: "/api/v1/fans", method: "GET")
    }

    func fetchFan(id: Int) async throws -> Fan {
        try await request(path: "/api/v1/fans/\(id)", method: "GET")
    }

    func createFan(payload: FanPayload) async throws -> Fan {
        try await request(path: "/api/v1/fans", method: "POST", payload: payload)
    }

    func updateFan(id: Int, payload: FanPayload) async throws -> Fan {
        try await request(path: "/api/v1/fans/\(id)", method: "PUT", payload: payload)
    }

    func deleteFan(id: Int) async throws {
        guard let url = URL(string: "\(baseURL)/api/v1/fans/\(id)") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let (_, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }

    private func request<Response: Decodable>(
        path: String,
        method: String,
        payload: (any Encodable)? = nil
    ) async throws -> Response {
        guard let url = URL(string: "\(baseURL)\(path)") else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let payload {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(AnyEncodable(payload))
        }
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try decoder.decode(Response.self, from: data)
    }
}

private struct AnyEncodable: Encodable {
    private let encodeValue: (Encoder) throws -> Void

    init(_ value: any Encodable) { encodeValue = value.encode }
    func encode(to encoder: Encoder) throws { try encodeValue(encoder) }
}
