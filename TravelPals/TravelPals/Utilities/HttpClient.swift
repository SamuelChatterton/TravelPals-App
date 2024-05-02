//HttpClient
import Foundation

enum HttpMethods: String {
    case POST, GET, PUT, DELETE
}

enum MIMEType: String {
    case JSON = "application/json"
}

enum HttpHeaders: String {
    case contentType = "content-type"
}

enum HttpError: Error {
    case badURL, badResponse, errorDecodingData, invalidURL
}

class HttpClient{
    private init() {}
    
    static let shared = HttpClient()
    
    //Fetch data from a URL
    func fetch<T: Codable>(url: URL) async throws -> [T] {
        let (data, response) = try await URLSession.shared.data(from:url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
        
        guard let object = try? JSONDecoder().decode([T].self, from: data) else {
            throw HttpError.errorDecodingData
        }
        return object
    }

    //Send data to a URL
    func sendData<T: Codable>(to url: URL, object: T, httpMethod: String) async throws {
        var request = URLRequest(url: url)

        print("Sending Request to \(url)")
        print("HTTP Method: \(httpMethod)")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
        print("Request Body: \(String(data: try JSONEncoder().encode(object) ?? Data(), encoding: .utf8) ?? "")")

        request.httpMethod = httpMethod
        request.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HttpHeaders.contentType.rawValue)

        request.httpBody = try? JSONEncoder().encode(object)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Unexpected response type.")
                throw HttpError.badResponse
            }

            print("Response Status Code: \(httpResponse.statusCode)")
            print("Response Body: \(String(data: data, encoding: .utf8) ?? "")")

            guard httpResponse.statusCode == 200 else {
                print("Server returned an error: \(httpResponse.statusCode)")
                throw HttpError.badResponse
            }
        } catch {
            print("Error sending request: \(error)")
            throw HttpError.badResponse
        }
    }

    //Delete data at a URL
    func delete(at id: UUID, url: URL) async throws {
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethods.DELETE.rawValue
        
        let(_, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
    }
}
