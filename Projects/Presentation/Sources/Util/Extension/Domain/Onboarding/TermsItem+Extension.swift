import Domain
import UIKit

extension TermsItem {
    var checkboxImage: UIImage? {
        isAgreed ? .dsIconCheckSelected : .dsIconCheck
    }

    var displayTitle: String {
        let prefix = type.isRequired ? "[필수]" : "[선택]"
        return "\(prefix) \(type.title)"
    }

    var hasDetailPage: Bool {
        type.urlString != nil
    }
}
