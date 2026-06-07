import ProjectDescription

public enum BuildScripts {
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

    // MARK: - GoogleService-Info.plist

    public static let copyGoogleServiceInfo: TargetScript = .pre(
        script: """
        ROOT_DIR="${SRCROOT}"
        while [ ! -f "${ROOT_DIR}/Config/Example.xcconfig" ] && [ "${ROOT_DIR}" != "/" ]; do
            ROOT_DIR=$(dirname "${ROOT_DIR}")
        done

        if [ "${CONFIGURATION}" = "Debug" ]; then
            SOURCE_PLIST="${ROOT_DIR}/Config/GoogleService-Info-Debug.plist"
        else
            SOURCE_PLIST="${ROOT_DIR}/Config/GoogleService-Info-Release.plist"
        fi

        DEST_DIR="${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
        mkdir -p "${DEST_DIR}"

        if [ ! -f "${SOURCE_PLIST}" ]; then
            echo "error: Firebase plist not found at ${SOURCE_PLIST}."
            echo "Place GoogleService-Info-Debug.plist and GoogleService-Info-Release.plist in Config/. See Config/Example.xcconfig."
            exit 1
        fi

        cp "${SOURCE_PLIST}" "${DEST_DIR}/GoogleService-Info.plist"
        echo "Copied ${SOURCE_PLIST} -> ${DEST_DIR}/GoogleService-Info.plist"
        """,
        name: "Copy GoogleService-Info.plist",
        basedOnDependencyAnalysis: false
    )

    // MARK: - Default Collections

    public static var app: [TargetScript] {
        [copyGoogleServiceInfo, swiftFormat]
    }

    public static var framework: [TargetScript] {
        [swiftFormat]
    }

    public static var test: [TargetScript] {
        []
    }
}
