import ProjectDescription

public enum Module: String, CaseIterable {
    case app = "App"
    case presentation = "Presentation"
    case domain = "Domain"
    case data = "Data"
    
    case networking = "Networking"
    case logger = "Logger"
    case keychain = "Keychain"
    case userDefaults = "Userdefaults"

    case designSystem = "DesignSystem"
    case utils = "Utils"
}

extension Module {
    public var path: Path {
        switch self {
        case .app:
            return .relativeToRoot("Projects/App")
        case .presentation, .domain, .data:
            return .relativeToRoot("Projects/\(rawValue)")
        case .networking, .logger, .keychain, .userDefaults:
            return .relativeToRoot("Projects/Core/\(rawValue)")
        case .designSystem, .utils:
            return .relativeToRoot("Projects/Shared/\(rawValue)")
        }
    }
    
    public var product: Product {
        switch self {
        case .app:
            return .app
        default:
            return .framework
        }
    }
}
