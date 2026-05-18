import Foundation

enum MyPageRootSection: Hashable {
    case profile
    case pager
}

enum MyPageRootItem: Hashable {
    case profile(ProfileData)
    case pagerHost
}
