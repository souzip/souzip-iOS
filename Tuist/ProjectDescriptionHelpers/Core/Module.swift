import ProjectDescription

public enum Module: String, CaseIterable {
    case app = "App"
    case presentation = "Presentation"
    case domain = "Domain"
    case data = "Data"

    case networking = "Networking"
    case logger = "Logger"
    case analytics = "Analytics"
    case storage = "Storage"
    case ads = "Ads"

    case designSystem = "DesignSystem"
    case utils = "Utils"
}

public extension Module {
    var path: Path {
        switch self {
        case .app:
            .relativeToRoot("Projects/App")
        case .presentation, .domain, .data:
            .relativeToRoot("Projects/\(rawValue)")
        case .networking, .logger, .analytics, .storage, .ads:
            .relativeToRoot("Projects/Core/\(rawValue)")
        case .designSystem, .utils:
            .relativeToRoot("Projects/Shared/\(rawValue)")
        }
    }

    var product: Product {
        switch self {
        case .app:
            .app
        default:
            .framework
        }
    }
}
