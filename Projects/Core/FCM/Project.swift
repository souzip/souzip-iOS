import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    .fcm,
    additionalBaseSettings: [
        "PRODUCT_NAME": "FCM",
        "ENABLE_MODULE_VERIFIER": "NO",
        "CLANG_ENABLE_MODULE_VERIFIER": "NO",
    ]
)
