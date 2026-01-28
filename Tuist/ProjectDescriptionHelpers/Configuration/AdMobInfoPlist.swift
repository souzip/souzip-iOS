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
            .dictionary(["SKAdNetworkIdentifier": "2fnua5tdw4.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "ydx93a7ass.skadnetwork"]),
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
            .dictionary(["SKAdNetworkIdentifier": "mlmmfzh3r3.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "v4nxqhlyqp.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "wzmmz9fp6w.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "su67r6k2v3.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "yclnxrl5pm.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "t38b2kh725.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "7ug5zh24hu.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "gta9lk7p23.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "vutu7akeur.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "y5ghdn5j9k.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "v9wttpbfk9.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "n38lu8286q.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "47vhws6wlr.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "kbd757ywx3.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "9t245vhmpl.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "a2p9lx4jpn.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "22mmun2rn5.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "44jx6755aq.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "k674qkevps.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "4468km3ulz.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "2u9pt9hc89.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "8s468mfl3y.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "klf5c3l5u5.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "ppxm28t8ap.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "kbmxgpxpgc.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "uw77j35x4d.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "578prtvx9j.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "4dzt52r2t5.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "tl55sbb4fm.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "c3frkrj4fj.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "e5fvkxwrpn.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "8c4e2ghe7u.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "3rd42ekr43.skadnetwork"]),
            .dictionary(["SKAdNetworkIdentifier": "97r2b46745.skadnetwork"]),
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
