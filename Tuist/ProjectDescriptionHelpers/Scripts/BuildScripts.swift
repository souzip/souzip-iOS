import ProjectDescription

public enum BuildScripts {
    
    // MARK: - SwiftLint
    
    public static let swiftLint: TargetScript = .pre(
        script: """
        # mise 경로 추가
        if [ -d "$HOME/.local/share/mise/shims" ]; then
            export PATH="$HOME/.local/share/mise/shims:$PATH"
        fi
        
        # 프로젝트 루트 디렉토리 찾기
        ROOT_DIR="${SRCROOT}"
        while [ ! -f "${ROOT_DIR}/.swiftlint.yml" ] && [ "${ROOT_DIR}" != "/" ]; do
            ROOT_DIR=$(dirname "${ROOT_DIR}")
        done
        
        # SwiftLint 실행
        if command -v swiftlint >/dev/null 2>&1; then
            if [ -f "${ROOT_DIR}/.swiftlint.yml" ]; then
                swiftlint --config "${ROOT_DIR}/.swiftlint.yml" 2>/dev/null || swiftlint
            else
                swiftlint
            fi
        else
            echo "warning: SwiftLint not installed"
        fi
        """,
        name: "SwiftLint",
        basedOnDependencyAnalysis: false
    )
    
    // MARK: - SwiftFormat
    
    public static let swiftFormat: TargetScript = .pre(
        script: """
        # mise 경로 추가
        if [ -d "$HOME/.local/share/mise/shims" ]; then
            export PATH="$HOME/.local/share/mise/shims:$PATH"
        fi
        
        # 프로젝트 루트 디렉토리 찾기
        ROOT_DIR="${SRCROOT}"
        while [ ! -f "${ROOT_DIR}/.swiftformat" ] && [ "${ROOT_DIR}" != "/" ]; do
            ROOT_DIR=$(dirname "${ROOT_DIR}")
        done
        
        # SwiftFormat 실행 (자동 수정)
        if command -v swiftformat >/dev/null 2>&1; then
            if [ -f "${ROOT_DIR}/.swiftformat" ]; then
                echo "🎨 SwiftFormat 실행 중..."
                swiftformat "${SRCROOT}" --config "${ROOT_DIR}/.swiftformat"
                echo "✅ SwiftFormat 완료"
            else
                echo "warning: .swiftformat config file not found"
            fi
        else
            echo "warning: SwiftFormat not installed. Run: mise install"
        fi
        """,
        name: "SwiftFormat",
        basedOnDependencyAnalysis: false
    )
    
    // MARK: - Default Collections
    
    public static var app: [TargetScript] {
        [swiftFormat, swiftLint]
    }
    
    public static var framework: [TargetScript] {
        [swiftFormat, swiftLint]
    }
    
    public static var test: [TargetScript] {
        []
    }
}
