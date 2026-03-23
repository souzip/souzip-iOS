import DesignSystem
import Domain
import UIKit

extension ProfileImageType {
    var image: UIImage? {
        switch self {
        case .red: .dsProfileRed
        case .yellow: .dsProfileYellow
        case .purple: .dsProfilePurple
        case .blue: .dsProfileBlue
        }
    }

    var selectedImage: UIImage? {
        switch self {
        case .red: .dsProfileRedSelected
        case .yellow: .dsProfileYellowSelected
        case .purple: .dsProfilePurpleSelected
        case .blue: .dsProfileBlueSelected
        }
    }
}
