import Domain
import Foundation

enum TermsAction {
    case viewWillAppear
    case tapback
    case tapAllAgree
    case tapTerm(TermsType)
    case tapTermDetail(TermsType)
    case tapAgreeButton
    case confirmMarketing(Bool)
}

struct TermsState {
    var age14: TermsItem = .init(type: .age14, isRequired: true)
    var service: TermsItem = .init(type: .service, isRequired: true)
    var privacy: TermsItem = .init(type: .privacy, isRequired: true)
    var location: TermsItem = .init(type: .location, isRequired: true)
    var marketing: TermsItem = .init(type: .marketing, isRequired: false)

    var isAgreeButtonEnabled: Bool = false

    var items: [TermsItem] {
        [age14, service, privacy, location, marketing]
    }
}

enum TermsEvent {
    case showMarketingConfirm(String)
}
