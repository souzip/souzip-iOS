import CoreLocation
import UIKit

struct CountryBadge: Equatable {
    let coordinate: CLLocationCoordinate2D
    let countryName: String
    let imageURL: String
    let color: UIColor

    static func == (lhs: CountryBadge, rhs: CountryBadge) -> Bool {
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
            lhs.coordinate.longitude == rhs.coordinate.longitude &&
            lhs.countryName == rhs.countryName
    }
}

extension CountryBadge {
    static let mockData: [CountryBadge] = {
        let colors: [UIColor] = [
            .dsMain,
            .dsSecondaryYellow,
            .dsSecondaryGreen,
            .dsSecondaryPurple,
            .dsSecondaryBlue,
        ]

        let countries = [
            ("일본", "https://flagcdn.com/w320/jp.png", 36.0, 138.0),
            ("베트남", "https://flagcdn.com/w320/vn.png", 16.0, 106.0),
            ("중국", "https://flagcdn.com/w320/cn.png", 35.0, 105.0),
            ("태국", "https://flagcdn.com/w320/th.png", 15.0, 100.0),
            ("필리핀", "https://flagcdn.com/w320/ph.png", 13.0, 122.0),
            ("대만", "https://flagcdn.com/w320/tw.png", 23.5, 121.0),
            ("홍콩", "https://flagcdn.com/w320/hk.png", 22.3, 114.2),
            ("싱가포르", "https://flagcdn.com/w320/sg.png", 1.36666666, 103.8),
            ("말레이시아", "https://flagcdn.com/w320/my.png", 2.5, 112.5),
            ("인도네시아", "https://flagcdn.com/w320/id.png", -5.0, 120.0),
            ("미국", "https://flagcdn.com/w320/us.png", 38.0, -97.0),
            ("호주", "https://flagcdn.com/w320/au.png", -27.0, 133.0),
            ("캐나다", "https://flagcdn.com/w320/ca.png", 60.0, -95.0),
            ("독일", "https://flagcdn.com/w320/de.png", 51.0, 9.0),
            ("프랑스", "https://flagcdn.com/w320/fr.png", 46.0, 2.0),
            ("영국", "https://flagcdn.com/w320/gb.png", 54.0, -2.0),
            ("스페인", "https://flagcdn.com/w320/es.png", 40.0, -4.0),
            ("이탈리아", "https://flagcdn.com/w320/it.png", 42.83333333, 12.83333333),
            ("터키", "https://flagcdn.com/w320/tr.png", 39.0, 35.0),
            ("러시아", "https://flagcdn.com/w320/ru.png", 60.0, 100.0),
            ("네덜란드", "https://flagcdn.com/w320/nl.png", 52.5, 5.75),
            ("벨기에", "https://flagcdn.com/w320/be.png", 50.83333333, 4.0),
            ("스위스", "https://flagcdn.com/w320/ch.png", 47.0, 8.0),
            ("그리스", "https://flagcdn.com/w320/gr.png", 39.0, 22.0),
            ("오스트리아", "https://flagcdn.com/w320/at.png", 47.33333333, 13.33333333),
            ("체코", "https://flagcdn.com/w320/cz.png", 49.75, 15.5),
            ("헝가리", "https://flagcdn.com/w320/hu.png", 47.0, 20.0),
            ("폴란드", "https://flagcdn.com/w320/pl.png", 52.0, 20.0),
            ("멕시코", "https://flagcdn.com/w320/mx.png", 23.0, -102.0),
            ("브라질", "https://flagcdn.com/w320/br.png", -10.0, -55.0),
        ]

        return countries.map { country in
            let colorIndex = abs(country.0.hashValue) % colors.count
            return CountryBadge(
                coordinate: CLLocationCoordinate2D(latitude: country.2, longitude: country.3),
                countryName: country.0,
                imageURL: country.1,
                color: colors[colorIndex]
            )
        }
    }()
}
