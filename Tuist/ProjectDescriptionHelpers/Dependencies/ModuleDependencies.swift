import ProjectDescription

public enum ModuleDependencies {
    public static func dependencies(for module: Module) -> [TargetDependency] {
        switch module {
        case .app:
            return [
                .module(.presentation),
                .module(.domain),
                .module(.data),
                .module(.logger),
                .module(.designSystem)
            ]
            
        case .presentation:
            return [
                .module(.domain),
                .module(.logger),
                .module(.designSystem),
                .module(.utils),
                .external(.rxSwift),
                .external(.rxCocoa),
                .external(.snapKit),
                .external(.kingfisher)
            ]
            
        case .domain:
            return [
                .module(.utils),
                .module(.logger)
            ]
            
        case .data:
            return [
                .module(.domain),
                .module(.networking),
                .module(.logger),
                .module(.utils)
            ]
            
        case .networking:
            return [
                .module(.logger)
            ]
            
        case .logger:
            return []
            
        case .designSystem:
            return [
                .module(.logger),
                .module(.utils)
            ]
            
        case .utils:
            return []
        }
    }
}
