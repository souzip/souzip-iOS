import SnapKit
import UIKit

final class UserLocationView: UIView {
    private let squareView: UIView = {
        let view = UIView()
        view.backgroundColor = .dsMain
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Configuration

private extension UserLocationView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        backgroundColor = .dsMain.withAlphaComponent(0.1)
    }

    func setHierarchy() {
        addSubview(squareView)
    }

    func setConstraints() {
        squareView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(12)
        }
    }
}
