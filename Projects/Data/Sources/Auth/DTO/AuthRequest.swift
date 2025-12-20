struct LoginRequest: Encodable {
    let accessToken: String
}

struct RefreshRequest: Encodable {
    let refreshToken: String
}
