import ProjectDescription

public extension TargetDependency {
    
    static func module(_ module: Module) -> TargetDependency {
        .project(target: module.rawValue, path: module.path)
    }
    
    static func external(_ library: ExternalLibrary) -> TargetDependency {
        .external(name: library.rawValue)
    }
}
