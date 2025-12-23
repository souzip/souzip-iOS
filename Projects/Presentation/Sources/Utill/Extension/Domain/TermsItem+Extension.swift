import Domain
import UIKit

extension TermsItem {
    var checkboxImage: UIImage? {
        isAgreed ? .dsIconCheckSelected : .dsIconCheck
    }

    var displayTitle: String {
        let prefix = isRequired ? "[필수]" : "[선택]"
        return "\(prefix) \(type.baseTitle)"
    }

    var hasDetailPage: Bool {
        type.detailURL != nil
    }
}
