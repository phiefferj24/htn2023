//
//  APIManager.swift
//  HTN2023
//
//  Created by Jim Phieffer on 9/16/23.
//

import Foundation

class APIManager {
    static let shared = APIManager()

    static let BASE_URL = "http://10.33.134.156:3000"

    struct BaseResponseBody<T: Codable>: Codable {
        let data: T
    }

    func sendCode(phone: String) async {
        struct RequestBody: Codable {
            let phone: String
        }
        let body = RequestBody(
            phone: phone.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        guard let url = URL(string: "\(Self.BASE_URL)/verify") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        _ = try? await URLSession.shared.data(for: request)
    }

    func verifyCode(phone: String, code: String) async -> Int? {
        struct RequestBody: Codable {
            let phone: String
            let code: String
        }
        struct ResponseBody: Codable {
            let id: Int
        }
        let body = RequestBody(
            phone: phone.trimmingCharacters(in: .whitespacesAndNewlines),
            code: code.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        guard let url = URL(string: "\(Self.BASE_URL)/verifycheck") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let (data, response) = try? await URLSession.shared.data(for: request), 
           let response = response as? HTTPURLResponse,
           response.statusCode - 200 < 100,
           let resData = try? JSONDecoder().decode(BaseResponseBody<ResponseBody>.self, from: data) {
            return resData.data.id
        }
        return nil
    }

    func setName(id: Int, phone: String, name: String) async {
        struct RequestBody: Codable {
            let phone: String
            let name: String
        }
        let body = RequestBody(
            phone: phone.trimmingCharacters(in: .whitespacesAndNewlines),
            name: name.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        guard let url = URL(string: "\(Self.BASE_URL)/users/\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try? JSONEncoder().encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        _ = try? await URLSession.shared.data(for: request)
    }

    func setInterests(id: Int, interests: [String]) async {
        struct RequestBody: Codable {
            let interests: [String]
        }
        let body = RequestBody(
            interests: interests
        )

        guard let url = URL(string: "\(Self.BASE_URL)/users/interests/add?userId=\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        _ = try? await URLSession.shared.data(for: request)
    }

    func setDeviceId(id: Int, deviceId: String) async {
        struct RequestBody: Codable {
            let deviceId: String
        }
        let body = RequestBody(
            deviceId: deviceId
        )

        guard let url = URL(string: "\(Self.BASE_URL)/users/deviceId/add?userId=\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try? JSONEncoder().encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        _ = try? await URLSession.shared.data(for: request)
    }

    func setSocial(id: Int, service: String, username: String) async {
        struct RequestBody: Codable {
            let service: String
            let username: String
        }
        let body = RequestBody(
            service: service,
            username: username
        )

        guard let url = URL(string: "\(Self.BASE_URL)/users/social/add?userId=\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        _ = try? await URLSession.shared.data(for: request)
    }

    func connect(id: Int, otherId: Int) async {
        struct RequestBody: Codable {
            let sender: Int
            let recipient: Int
        }
        let body = RequestBody(
            sender: id,
            recipient: otherId
        )

        guard let url = URL(string: "\(Self.BASE_URL)/users/social/connect") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        _ = try? await URLSession.shared.data(for: request)
    }

    struct ResponseBody2: Codable {
        let token: String
        let kickbackTime: Date
    }

    func joinLobby(id: Int) async -> ResponseBody2? {
        guard let url = URL(string: "\(Self.BASE_URL)/video/joinLobby?userId=\(id)") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        if let (data, response) = try? await URLSession.shared.data(for: request),
           let response = response as? HTTPURLResponse,
           response.statusCode - 200 < 100,
           let resData = try? decoder.decode(BaseResponseBody<ResponseBody2>.self, from: data) {
            return resData.data
        }
        return nil
    }

    struct User: Codable {
        let name: String
        let id: Int
        let avatar_url: String
    }

    func getUser(id: Int) async -> User? {
        guard let url = URL(string: "\(Self.BASE_URL)/users/\(id)") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let (data, response) = try? await URLSession.shared.data(for: request),
           let response = response as? HTTPURLResponse,
           response.statusCode - 200 < 100,
           let resData = try? JSONDecoder().decode(BaseResponseBody<User>.self, from: data) {
            return resData.data
        }
        return nil
    }

    struct Connection: Codable {
        let name: String
        let id: Int
        let connectionAge: String
        let avatar_url: String
    }

    func getConnections(id: Int) async -> [Connection] {
        guard let url = URL(string: "\(Self.BASE_URL)/users/social/connections?userId=\(id)") else { return [] }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let (data, response) = try? await URLSession.shared.data(for: request),
           let response = response as? HTTPURLResponse,
           response.statusCode - 200 < 100,
           let resData = try? JSONDecoder().decode(BaseResponseBody<[Connection]>.self, from: data) {
            return resData.data
        }
        return []
    }

    func getSocials(id: Int) async -> [Social] {
        guard let url = URL(string: "\(Self.BASE_URL)/users/social/accounts?userId=\(id)") else { return [] }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let (data, response) = try? await URLSession.shared.data(for: request),
           let response = response as? HTTPURLResponse,
           response.statusCode - 200 < 100,
           let resData = try? JSONDecoder().decode(BaseResponseBody<[Social]>.self, from: data) {
            return resData.data
        }
        return []
    }
}
