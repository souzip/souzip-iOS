import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class AddressFieldView: UIView {
    // MARK: - Types

    private enum Copy {
        static let preciseLocationHint = "위치가 정확하지 않으신가요?"
    }

    // MARK: - Output

    let tapRelay = PublishRelay<Void>()
    /// 상세 주소 라벨 또는 힌트 라벨 탭 → 지도에서 위치 다시 잡기
    let preciseLocationTapRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()

    // MARK: - UI

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGreyWhite
        label.setTypography(.body1SB)
        return label
    }()

    private let textField = DSTextField()

    private let tapOverlayButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        return button
    }()

    /// 상세 주소(입력됨) 또는 힌트(미입력·좌표 있음) — 동일 영역·탭 시 피커로 이동
    private let detailOrHintLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.numberOfLines = 0
        label.isHidden = true
        label.isUserInteractionEnabled = true
        return label
    }()

    private let contentStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.spacing = 8
        return sv
    }()

    init() {
        super.init(frame: .zero)
        configureFixedTexts()
        configure()
        renderDetailOrHintLine(detailText: "", showPreciseLocationEntry: false)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureFixedTexts() {
        titleLabel.text = "위치"
        textField.setPlaceholder("위치를 선택해주세요.")
    }

    // MARK: - Public

    func render(text: String) {
        textField.setText(text)
    }

    /// - 상세 주소가 있으면 그 텍스트(보조 설명 스타일).
    /// - 없고 `showPreciseLocationEntry`이면 힌트(강조 스타일).
    /// - 둘 다 아니면 숨김. 라벨 탭은 항상 `preciseLocationTapRelay`(노출 시에만 의미 있음).
    func renderDetailOrHintLine(detailText: String, showPreciseLocationEntry: Bool) {
        let trimmed = detailText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            detailOrHintLabel.text = trimmed
            detailOrHintLabel.textColor = .dsGrey300
            detailOrHintLabel.setTypography(.body4R)
            detailOrHintLabel.isHidden = false
        } else if showPreciseLocationEntry {
            detailOrHintLabel.text = Copy.preciseLocationHint
            detailOrHintLabel.textColor = .dsMain
            detailOrHintLabel.setTypography(.body3M)
            detailOrHintLabel.isHidden = false
        } else {
            detailOrHintLabel.isHidden = true
        }
    }

    // MARK: - Private

    private func configure() {
        setHierarchy()
        setConstraints()
        setNonEditable()
        setBindings()
    }

    private func setHierarchy() {
        addSubview(titleLabel)
        addSubview(contentStackView)

        contentStackView.addArrangedSubview(textField)
        contentStackView.addArrangedSubview(detailOrHintLabel)

        addSubview(tapOverlayButton) // 텍스트필드 영역만 덮기
    }

    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(27)
        }

        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }

        tapOverlayButton.snp.makeConstraints { make in
            make.edges.equalTo(textField)
        }
    }

    private func setNonEditable() {
        textField.isUserInteractionEnabled = false
    }

    private func setBindings() {
        tapOverlayButton.rx.tap
            .bind(to: tapRelay)
            .disposed(by: disposeBag)

        let detailTap = UITapGestureRecognizer()
        detailOrHintLabel.addGestureRecognizer(detailTap)
        detailTap.rx.event
            .subscribe(onNext: { [weak self] _ in
                guard let self, !self.detailOrHintLabel.isHidden else { return }
                preciseLocationTapRelay.accept(())
            })
            .disposed(by: disposeBag)
    }
}
