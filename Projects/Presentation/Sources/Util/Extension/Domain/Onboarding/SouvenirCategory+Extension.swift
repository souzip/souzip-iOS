import Domain
import UIKit

extension SouvenirCategory {
    var title: String {
        switch self {
        case .snack: "먹거리·간식"
        case .healthBeauty: "뷰티·헬스"
        case .fashion: "패션·악세서리"
        case .culture: "문화·전통"
        case .toy: "장난감·키즈"
        case .classic: "기념품 기본템"
        case .lifestyle: "홈·라이프스타일"
        case .art: "문구·아트"
        case .travel: "여행·실용템"
        case .tech: "테크·전자제품"
        }
    }

    var image: UIImage {
        switch self {
        case .snack: .dsIconCategorySnack
        case .healthBeauty: .dsIconCategoryHealthBeauty
        case .fashion: .dsIconCategoryFashion
        case .culture: .dsIconCategoryCulture
        case .toy: .dsIconCategoryToy
        case .classic: .dsIconCategoryClassic
        case .lifestyle: .dsIconCategoryLifestyle
        case .art: .dsIconCategoryArt
        case .travel: .dsIconCategoryTravel
        case .tech: .dsIconCategoryTech
        }
    }

    var selectedImage: UIImage {
        switch self {
        case .snack: .dsIconCategorySnackSelected
        case .healthBeauty: .dsIconCategoryHealthBeautySelected
        case .fashion: .dsIconCategoryFashionSelected
        case .culture: .dsIconCategoryCultureSelected
        case .toy: .dsIconCategoryToySelected
        case .classic: .dsIconCategoryClassicSelected
        case .lifestyle: .dsIconCategoryLifestyleSelected
        case .art: .dsIconCategoryArtSelected
        case .travel: .dsIconCategoryTravelSelected
        case .tech: .dsIconCategoryTechSelected
        }
    }
}
