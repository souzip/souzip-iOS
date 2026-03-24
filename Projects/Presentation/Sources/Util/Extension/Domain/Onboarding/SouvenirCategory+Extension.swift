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

    var grayImage: UIImage {
        switch self {
        case .snack: .dsIconCategorySnackGray
        case .healthBeauty: .dsIconCategoryHealthBeautyGray
        case .fashion: .dsIconCategoryFashionGray
        case .culture: .dsIconCategoryCultureGray
        case .toy: .dsIconCategoryToyGray
        case .classic: .dsIconCategoryClassicGray
        case .lifestyle: .dsIconCategoryLifestyleGray
        case .art: .dsIconCategoryArtGray
        case .travel: .dsIconCategoryTravelGray
        case .tech: .dsIconCategoryTechGray
        }
    }

    var mainImage: UIImage {
        switch self {
        case .snack: .dsIconCategorySnackMain
        case .healthBeauty: .dsIconCategoryHealthBeautyMain
        case .fashion: .dsIconCategoryFashionMain
        case .culture: .dsIconCategoryCultureMain
        case .toy: .dsIconCategoryToyMain
        case .classic: .dsIconCategoryClassicMain
        case .lifestyle: .dsIconCategoryLifestyleMain
        case .art: .dsIconCategoryArtMain
        case .travel: .dsIconCategoryTravelMain
        case .tech: .dsIconCategoryTechMain
        }
    }

    var tintedImage: UIImage {
        switch self {
        case .snack: .dsIconCategorySnackTinted
        case .healthBeauty: .dsIconCategoryHealthBeautyTinted
        case .fashion: .dsIconCategoryFashionTinted
        case .culture: .dsIconCategoryCultureTinted
        case .toy: .dsIconCategoryToyTinted
        case .classic: .dsIconCategoryClassicTinted
        case .lifestyle: .dsIconCategoryLifestyleTinted
        case .art: .dsIconCategoryArtTinted
        case .travel: .dsIconCategoryTravelTinted
        case .tech: .dsIconCategoryTechTinted
        }
    }
}
