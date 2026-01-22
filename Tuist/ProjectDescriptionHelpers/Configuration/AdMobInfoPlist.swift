import ProjectDescription

public enum AdMobInfoPlist {
    // MARK: - Privacy Configuration
    
    private static let privacy: [String: Plist.Value] = [
        "NSUserTrackingUsageDescription": "맞춤형 광고를 제공하기 위해 추적 권한이 필요합니다."
    ]
    
    // MARK: - AdMob Configuration
    
    private static let admobSettings: [String: Plist.Value] = [
        "GADApplicationIdentifier": "$(ADMOB_APP_ID)",
        "ADMOB_BANNER_AD_UNIT_ID": "$(ADMOB_BANNER_AD_UNIT_ID)",
        
        // SKAdNetwork IDs
        "SKAdNetworkItems": .array([
            .dictionary(["SKAdNetworkIdentifier": "cstr6suwn9.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "4fzdc2evr5.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "4pfyvq9l8r.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "2fnua5tdw4.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "ydx93a7ass.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "5a6flpkh64.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "p78axxw29g.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "v72qych5uu.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "ludvb6z3bs.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "cp8zw746q7.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "3sh42y64q3.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "c6k4g5qg8m.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "s39g8k73mm.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "3qy4746246.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "f38h382jlk.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "hs6bdukanm.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "v4nckre9u5.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "wzmmz9fp6w.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "yclnxrl5pm.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "t38b2kh725.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "7ug5zh24hu.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "9rd848q2bz.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "n6fk4nfna4.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "kbd757ywx3.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "9t245vhmpl.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "4468km3ulz.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "2u9pt9hc89.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "8s468mfl3y.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "av6w8kgt66.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "klf5c3l5u5.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "ppxm28t8ap.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "424m5254lk.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "uw77j35x4d.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "578prtvx9j.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "4dzt52r2t5.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "e5fvkxwrpn.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "8c4e2ghe7u.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "zq492l623r.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "3qcr597p9d.skadnetwork"])
        ])
    ]
    
    // MARK: - Public Configuration
    
    public static var configuration: [String: Plist.Value] {
        privacy.merging(admobSettings)
    }
}

// MARK: - Extensions

private extension Dictionary where Key == String, Value == Plist.Value {
    func merging(_ other: [String: Plist.Value]) -> [String: Plist.Value] {
        self.merging(other) { _, new in new }
    }
}
