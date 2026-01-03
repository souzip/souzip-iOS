import Foundation
import Networking

public enum SouvenirEndpoint {
    case getSouvenir(id: Int)
    case createSouvenir(data: MultipartSouvenirData)
    case updateSouvenir(id: Int, data: MultipartSouvenirData)
    case deleteSouvenir(id: Int)
    case getNearbySouvenirs(latitude: Double, longitude: Double, radiusMeter: Int?)
}

extension SouvenirEndpoint: APIEndpoint {
    public var path: String {
        switch self {
        case let .getSouvenir(id):
            "/api/souvenirs/\(id)"
        case .createSouvenir:
            "/api/souvenirs"
        case let .updateSouvenir(id, _):
            "/api/souvenirs/\(id)"
        case let .deleteSouvenir(id):
            "/api/souvenirs/\(id)"
        case .getNearbySouvenirs:
            "/api/souvenirs/nearby"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .getSouvenir, .getNearbySouvenirs:
            .get
        case .createSouvenir:
            .post
        case .updateSouvenir:
            .put
        case .deleteSouvenir:
            .delete
        }
    }

    public var headers: [String: String]? {
        switch self {
        case .createSouvenir, .updateSouvenir:
            nil // multipart는 NetworkClient에서 자동 처리
        default:
            ["Content-Type": "application/json"]
        }
    }

    public var parameters: [String: Any]? {
        switch self {
        case let .getNearbySouvenirs(latitude, longitude, radiusMeter):
            var params: [String: Any] = [
                "latitude": latitude,
                "longitude": longitude,
            ]
            if let radius = radiusMeter {
                params["radiusMeter"] = radius
            }
            return params
        default:
            return nil
        }
    }
}

// 생성과 수정 모두 MultipartEndpoint
extension SouvenirEndpoint: MultipartEndpoint {
    public func createMultipartBody(boundary: String) -> Data {
        switch self {
        case let .createSouvenir(data), let .updateSouvenir(_, data):
            buildMultipartBody(with: data, boundary: boundary)
        default:
            Data()
        }
    }

    private func buildMultipartBody(with data: MultipartSouvenirData, boundary: String) -> Data {
        var body = Data()

        // 1. JSON Part (souvenir) - 항상 포함
        if let jsonData = try? JSONEncoder().encode(data.souvenirRequest),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"souvenir\"; filename=\"souvenir.json\"\r\n")
            body.append("Content-Type: application/json\r\n\r\n")
            body.append(jsonString)
            body.append("\r\n")
        }

        // 2. Image Files Part - 있을 때만 추가
        if !data.imageFiles.isEmpty {
            for (index, imageData) in data.imageFiles.enumerated() {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"files\"; filename=\"image\(index + 1).jpg\"\r\n")
                body.append("Content-Type: image/jpeg\r\n\r\n")
                body.append(imageData)
                body.append("\r\n")
            }
        }

        body.append("--\(boundary)--\r\n")
        return body
    }
}

private extension Data {
    mutating func append(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        append(data)
    }
}
