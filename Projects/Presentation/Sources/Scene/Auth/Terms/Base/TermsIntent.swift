import Domain
import Foundation

enum TermsAction {
    case tapback
    case tapAllAgree
    case tapTerm(TermsType)
    case tapTermDetail(TermsType)
    case tapAgreeButton
    case confirmMarketing(Bool)
}

struct TermsState {
    var age14: TermsItem = .init(type: .age14)
    var service: TermsItem = .init(type: .service)
    var privacy: TermsItem = .init(type: .privacy)
    var location: TermsItem = .init(type: .location)
    var marketing: TermsItem = .init(type: .marketing)

    var isAgreeButtonEnabled: Bool {
        items.isRequiredAllAgreed
    }

    var items: [TermsItem] {
        [age14, service, privacy, location, marketing]
    }
}

enum TermsEvent {
    case showMarketingConfirm(String)
    case showSFView(URL)
}
