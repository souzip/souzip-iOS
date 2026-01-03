import DesignSystem
import SnapKit
import UIKit

final class RankCardCell: UICollectionViewCell {

    // MARK: - UI Components

    private let firstCardView = RankCardView()
    private let secondCardView = RankCardView()
    private let thirdCardView = RankCardView()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setup

    private func setupUI() {
        contentView.addSubview(firstCardView)
        contentView.addSubview(secondCardView)
        contentView.addSubview(thirdCardView)

        setupConstraints()
    }

    private func setupConstraints() {
        // 2위 카드 (왼쪽)
        secondCardView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(43)
            make.height.equalTo(secondCardView.snp.width)
        }

        // 1위 카드 (중앙)
        firstCardView.snp.makeConstraints { make in
            make.leading.equalTo(secondCardView.snp.trailing).offset(9.5)
            make.top.equalToSuperview()
            make.width.height.equalTo(secondCardView)
        }

        // 3위 카드 (오른쪽)
        thirdCardView.snp.makeConstraints { make in
            make.leading.equalTo(firstCardView.snp.trailing).offset(9.5)
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(67)
            make.width.height.equalTo(secondCardView)
            make.bottom.equalToSuperview()
        }
    }

    // MARK: - Render

    func render(_ items: [StatCountryChipItem]) {
        guard items.count == 3 else { return }

        let firstItem = items[0] // 1위
        let secondItem = items[1] // 2위
        let thirdItem = items[2] // 3위

        firstCardView.render(
            style: .first,
            rank: firstItem.rank,
            imageURLString: firstItem.flagImage,
            title: firstItem.country,
            count: firstItem.count
        )

        secondCardView.render(
            style: .normal,
            rank: secondItem.rank,
            imageURLString: secondItem.flagImage,
            title: secondItem.country,
            count: secondItem.count
        )

        thirdCardView.render(
            style: .normal,
            rank: thirdItem.rank,
            imageURLString: thirdItem.flagImage,
            title: thirdItem.country,
            count: thirdItem.count
        )
    }
}
