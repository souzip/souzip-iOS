import ProjectDescription

public enum BuildScripts {
    
    // MARK: - SwiftLint
    
    public static let swiftLint: TargetScript = .pre(
        script: """
        # mise 경로 추가
        if [ -d "$HOME/.local/share/mise/shims" ]; then
            export PATH="$HOME/.local/share/mise/shims:$PATH"
        fi
        
        # SwiftLint 실행
        if command -v swiftlint >/dev/null 2>&1; then
            swiftlint --config "${SRCROOT}/.swiftlint.yml" 2>/dev/null || swiftlint
        else
            echo "warning: SwiftLint not installed"
        fi
        """,
        name: "SwiftLint",
        basedOnDependencyAnalysis: false
    )
    
    // MARK: - Default Collections
    
    public static var app: [TargetScript] {
        [swiftLint]
    }
    
    public static var framework: [TargetScript] {
        [swiftLint]
    }
    
    public static var test: [TargetScript] {
        []
    }
}
