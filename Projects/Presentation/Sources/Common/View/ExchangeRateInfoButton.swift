import DesignSystem
import SnapKit
import UIKit

/// 환율 안내 ⓘ 버튼 + 툴팁을 묶은 self-contained 컴포넌트.
/// 추가하기만 하면 탭/닫기 동작이 내부에서 처리됨.
final class ExchangeRateInfoButton: UIControl {
    // MARK: - UI

    private let iconButton: UIButton = {
        let button = UIButton()
        button.setImage(.dsIconInformationCircle, for: .normal)
        button.tintColor = .dsGrey500
        button.isUserInteractionEnabled = false
        return button
    }()

    private let tooltipView: UIView = {
        let view = UIView()
        view.backgroundColor = .dsGrey700
        view.layer.cornerRadius = 10
        view.isHidden = true
        return view
    }()

    private let tooltipLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "게시물이 등록된 시점의\n환율이 반영된 금액이에요"
        label.textColor = .dsGreyWhite
        label.numberOfLines = 2
        label.setTypography(.body4M)
        return label
    }()

    private let tooltipCloseButton: UIButton = {
        let button = UIButton()
        button.setImage(.dsIconCancel, for: .normal)
        button.tintColor = .dsGrey300
        return button
    }()

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Override

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        // UIStackView는 레이아웃 컨테이너이므로 건너뛰고 실제 드로잉 뷰에 추가
        // (UIStackView에 추가하면 형제 뷰의 z-order에 가려질 수 있음)
        var targetSuperview: UIView? = superview
        while targetSuperview is UIStackView {
            targetSuperview = targetSuperview?.superview
        }
        if let targetSuperview {
            targetSuperview.addSubview(tooltipView)
            // remakeConstraints: 뷰가 재추가될 때 중복 제약 방지
            tooltipView.snp.remakeConstraints { make in
                make.bottom.equalTo(self.snp.bottom).offset(43)
                make.leading.equalTo(self.snp.trailing).offset(5)
            }
        } else {
            tooltipView.removeFromSuperview()
        }
    }

    // MARK: - Public

    /// 셀 재사용 등 외부에서 툴팁을 강제로 숨길 때 사용
    func hideTooltip() {
        tooltipView.isHidden = true
    }
}

// MARK: - UI Configuration

private extension ExchangeRateInfoButton {
    func configure() {
        setHierarchy()
        setConstraints()
        setActions()
    }

    func setHierarchy() {
        addSubview(iconButton)

        // tooltipView는 didMoveToSuperview()에서 superview에 직접 추가
        [
            tooltipLabel,
            tooltipCloseButton,
        ].forEach(tooltipView.addSubview)
    }

    func setConstraints() {
        iconButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // tooltipView 제약은 didMoveToSuperview()에서 superview 기준으로 설정

        tooltipLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(15)
        }

        tooltipCloseButton.snp.makeConstraints { make in
            make.leading.equalTo(tooltipLabel.snp.trailing)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(32)
        }
    }

    func setActions() {
        addTarget(self, action: #selector(handleIconTap), for: .touchUpInside)
        tooltipCloseButton.addTarget(self, action: #selector(handleCloseTap), for: .touchUpInside)
    }

    @objc func handleIconTap() {
        tooltipView.isHidden = false
    }

    @objc func handleCloseTap() {
        tooltipView.isHidden = true
    }
}
