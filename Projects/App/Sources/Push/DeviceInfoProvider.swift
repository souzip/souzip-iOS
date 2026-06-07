import UIKit
import Utils

struct DeviceInfo {
    let deviceModel: String
    let osVersion: String
    let appVersion: String
}

enum DeviceInfoProvider {
    static func current() -> DeviceInfo {
        DeviceInfo(
            deviceModel: deviceModel(),
            osVersion: UIDevice.current.systemVersion,
            appVersion: AppInfo.version
        )
    }

    private static func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)

        return withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(cString: $0)
            }
        }
    }
}
