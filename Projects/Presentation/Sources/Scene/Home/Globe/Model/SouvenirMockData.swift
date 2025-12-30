// Presentation/Discovery/MockData/SouvenirMockData.swift

import Domain
import Foundation

enum SouvenirMockData {
    static func createMockSouvenirs() -> [SouvenirListItem] {
        // 종로역 중심 좌표: 37.5720, 126.9858
        [
            // snack
            SouvenirListItem(
                id: 1,
                name: "광장시장 빈대떡 믹스",
                category: .snack,
                purpose: .gift,
                localPrice: 12000,
                krwPrice: 12000,
                currencySymbol: "₩",
                thumbnail: "https://example.com/bindaetteok.jpg",
                distanceMeter: 150,
                coordinate: Coordinate(latitude: 37.5705, longitude: 126.9999),
                address: "서울특별시 종로구 창경궁로"
            ),
            SouvenirListItem(
                id: 2,
                name: "전통 한과 선물세트",
                category: .snack,
                purpose: .gift,
                localPrice: 28000,
                krwPrice: 28000,
                currencySymbol: "₩",
                thumbnail: "https://example.com/hangwa.jpg",
                distanceMeter: 300,
                coordinate: Coordinate(latitude: 37.5730, longitude: 126.9835),
                address: "서울특별시 종로구 인사동길"
            ),
            SouvenirListItem(
                id: 3,
                name: "약과 단품 박스",
                category: .snack,
                purpose: .personal,
                localPrice: 15000,
                krwPrice: 15000,
                currencySymbol: "₩",
                thumbnail: "https://example.com/yakgwa.jpg",
                distanceMeter: 420,
                coordinate: Coordinate(latitude: 37.5695, longitude: 126.9870),
                address: "서울특별시 종로구 종로3가"
            ),

            // healthBeauty
            SouvenirListItem(
                id: 4,
                name: "한방 비누 세트",
                category: .healthBeauty,
                purpose: .gift,
                localPrice: 22000,
                krwPrice: 22000,
                currencySymbol: "₩",
                thumbnail: "https://example.com/soap.jpg",
                distanceMeter: 250,
                coordinate: Coordinate(latitude: 37.5715, longitude: 126.9820),
                address: "서울특별시 종로구 인사동"
            ),
            SouvenirListItem(
                id: 5,
                name: "천연 향수 롤온",
                category: .healthBeauty,
                purpose: .personal,
                localPrice: 18000,
                krwPrice: 18000,
                currencySymbol: "₩",
                thumbnail: "https://example.com/perfume.jpg",
                distanceMeter: 380,
                coordinate: Coordinate(latitude: 37.5742, longitude: 126.9845),
                address: "서울특별시 종로구 관훈동"
            ),

            // fashion
            SouvenirListItem(
                id: 6,
                name: "한글 자수 스카프",
                category: .fashion,
                purpose: .gift,
                localPrice: 35000,
                krwPrice: 35000,
                currencySymbol: "₩",
                thumbnail: "https://example.com/scarf.jpg",
                distanceMeter: 200,
                coordinate: Coordinate(latitude: 37.5708, longitude: 126.9840),
                address: "서울특별시 종로구 인사동10길"
            ),
            SouvenirListItem(
                id: 7,
                name: "전통 노리개 키링",
                category: .fashion,
                purpose: .personal,
                localPrice: 12000,
                krwPrice: 12000,
                currencySymbol: "₩",
                thumbnail: "https://example.com/norigae.jpg",
                distanceMeter: 320,
                coordinate: Coordinate(latitude: 37.5735, longitude: 126.9810),
                address: "서울특별시 종로구 인사동길"
            ),
            SouvenirListItem(
                id: 8,
                name: "한복 디자인 양말",
                category: .fashion,
                purpose: .gift,
                localPrice: 8000,
                krwPrice: 8000,
                currencySymbol: "₩",
                thumbnail: "https://example.com/socks.jpg",
                distanceMeter: 450,
                coordinate: Coordinate(latitude: 37.5690, longitude: 126.9885),
                address: "서울특별시 종로구 낙원동"
            ),

            // culture
            SouvenirListItem(
                id: 9,
                name: "전통 부채 (접이식)",
                category: .culture,
                purpose: .gift,
                localPrice: 25000,
                krwPrice: 25000,
                currencySymbol: "₩",
                thumbnail: "https://example.com/fan.jpg",
                distanceMeter: 180,
                coordinate: Coordinate(latitude: 37.5725, longitude: 126.9830),
                address: "서울특별시 종로구 인사동5길"
            ),
            SouvenirListItem(
                id: 10,
                name: "한지 공예 노트",
                category: .culture,
                purpose: .personal,
                localPrice: 15000,
                krwPrice: 15000,
                currencySymbol: "₩",
                thumbnail: "https://example.com/hanji.jpg",
                distanceMeter: 280,
                coordinate: Coordinate(latitude: 37.5718, longitude: 126.9875),
                address: "서울특별시 종로구 관철동"
            ),

            // toy
            SouvenirListItem(
                id: 11,
                name: "전통 팽이 세트",
                category: .toy,
                purpose: .gift,
                localPrice: 18000,
                krwPrice: 18000,
                currencySymbol: "₩",
                thumbnail: "https://example.com/top.jpg",
                distanceMeter: 350,
                coordinate: Coordinate(latitude: 37.5698, longitude: 126.9820),
                address: "서울특별시 종로구 수송동"
            ),
            SouvenirListItem(
                id: 12,
                name: "나무 퍼즐 한옥 만들기",
                category: .toy,
                purpose: .personal,
                localPrice: 22000,
                krwPrice: 22000,
                currencySymbol: "₩",
                thumbnail: "https://example.com/puzzle.jpg",
                distanceMeter: 410,
                coordinate: Coordinate(latitude: 37.5745, longitude: 126.9890),
                address: "서울특별시 종로구 안국동"
            ),

            // classic
            SouvenirListItem(
                id: 13,
                name: "백자 미니어처",
                category: .classic,
                purpose: .gift,
                localPrice: 45000,
                krwPrice: 45000,
                currencySymbol: "₩",
                thumbnail: "https://example.com/porcelain.jpg",
                distanceMeter: 220,
                coordinate: Coordinate(latitude: 37.5710, longitude: 126.9850),
                address: "서울특별시 종로구 인사동11길"
            ),
            SouvenirListItem(
                id: 14,
                name: "나전칠기 소품함",
                category: .classic,
                purpose: .personal,
                localPrice: 68000,
                krwPrice: 68000,
                currencySymbol: "₩",
                thumbnail: "https://example.com/lacquerware.jpg",
                distanceMeter: 290,
                coordinate: Coordinate(latitude: 37.5733, longitude: 126.9825),
                address: "서울특별시 종로구 견지동"
            ),

            // lifestyle
            SouvenirListItem(
                id: 15,
                name: "도자기 찻잔 세트",
                category: .lifestyle,
                purpose: .gift,
                localPrice: 42000,
                krwPrice: 42000,
                currencySymbol: "₩",
                thumbnail: "https://example.com/teacup.jpg",
                distanceMeter: 330,
                coordinate: Coordinate(latitude: 37.5702, longitude: 126.9895),
                address: "서울특별시 종로구 익선동"
            ),
            SouvenirListItem(
                id: 16,
                name: "천연 대나무 수저",
                category: .lifestyle,
                purpose: .personal,
                localPrice: 16000,
                krwPrice: 16000,
                currencySymbol: "₩",
                thumbnail: "https://example.com/cutlery.jpg",
                distanceMeter: 270,
                coordinate: Coordinate(latitude: 37.5728, longitude: 126.9865),
                address: "서울특별시 종로구 공평동"
            ),

            // art
            SouvenirListItem(
                id: 17,
                name: "수묵화 엽서 세트",
                category: .art,
                purpose: .gift,
                localPrice: 12000,
                krwPrice: 12000,
                currencySymbol: "₩",
                thumbnail: "https://example.com/postcard.jpg",
                distanceMeter: 240,
                coordinate: Coordinate(latitude: 37.5712, longitude: 126.9815),
                address: "서울특별시 종로구 인사동8길"
            ),
            SouvenirListItem(
                id: 18,
                name: "민화 액자 (소형)",
                category: .art,
                purpose: .personal,
                localPrice: 38000,
                krwPrice: 38000,
                currencySymbol: "₩",
                thumbnail: "https://example.com/minhwa.jpg",
                distanceMeter: 360,
                coordinate: Coordinate(latitude: 37.5740, longitude: 126.9880),
                address: "서울특별시 종로구 계동"
            ),

            // travel
            SouvenirListItem(
                id: 19,
                name: "서울 랜드마크 자석",
                category: .travel,
                purpose: .gift,
                localPrice: 5000,
                krwPrice: 5000,
                currencySymbol: "₩",
                thumbnail: "https://example.com/magnet.jpg",
                distanceMeter: 190,
                coordinate: Coordinate(latitude: 37.5722, longitude: 126.9842),
                address: "서울특별시 종로구 인사동길"
            ),
            SouvenirListItem(
                id: 20,
                name: "한옥마을 스노우볼",
                category: .travel,
                purpose: .personal,
                localPrice: 18000,
                krwPrice: 18000,
                currencySymbol: "₩",
                thumbnail: "https://example.com/snowglobe.jpg",
                distanceMeter: 310,
                coordinate: Coordinate(latitude: 37.5695, longitude: 126.9835),
                address: "서울특별시 종로구 종로2가"
            ),
        ]
    }

    // 카테고리별로 필터링된 목데이터
    static func souvenirs(for category: SouvenirCategory) -> [SouvenirListItem] {
        createMockSouvenirs().filter { $0.category == category }
    }

    // 특정 개수만큼만 가져오기
    static func souvenirs(count: Int) -> [SouvenirListItem] {
        let all = createMockSouvenirs()
        return Array(all.prefix(count))
    }

    // 랜덤 기념품
    static func randomSouvenirs(count: Int) -> [SouvenirListItem] {
        let all = createMockSouvenirs()
        return Array(all.shuffled().prefix(count))
    }
}
