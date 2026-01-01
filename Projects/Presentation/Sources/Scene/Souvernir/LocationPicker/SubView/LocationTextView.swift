import DesignSystem
import RxRelay
import RxSwift
import SnapKit
import UIKit

final class LocationTextView: UIView {
    // MARK: - Properties

    let textChanged = PublishRelay<String>()
    private let disposeBag = DisposeBag()

    // MARK: - Metric

    private enum Metric {
        static let maxLines: Int = 5
        static let lineHeight: CGFloat = 18
        static let minHeight: CGFloat = lineHeight + (verticalPadding * 2)
        static let maxHeight: CGFloat = .init(maxLines) * lineHeight + verticalPadding * 2
        static let horizontalPadding: CGFloat = 12
        static let verticalPadding: CGFloat = 12
        static let inset = UIEdgeInsets(
            top: verticalPadding,
            left: horizontalPadding,
            bottom: verticalPadding,
            right: horizontalPadding
        )
    }

    // MARK: - UI

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .dsGrey700
        view.layer.cornerRadius = 5
        return view
    }()

    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textContainerInset = Metric.inset
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        return textView
    }()

    private let placeholderLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "상세 위치를 추가로 설명해주세요"
        label.textColor = .dsGrey80
        label.setTypography(.body4R)
        return label
    }()

    private var containerHeightConstraint: Constraint?

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
    }

    private func setHierarchy() {
        addSubview(containerView)
        containerView.addSubview(textView)
        textView.addSubview(placeholderLabel)
    }

    private func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            self.containerHeightConstraint = make.height.equalTo(Metric.minHeight).constraint
        }

        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        placeholderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Metric.inset.top)
            make.leading.equalToSuperview().inset(Metric.inset.left)
            make.height.equalTo(18)
        }
    }

    private func setAttributes() {
        textView.setTypography(.body3M, textColor: .dsGreyWhite)
    }

    private func setBindings() {
        textView.delegate = self
    }

    private func updatePlaceholder() {
        let text = textView.text ?? ""
        placeholderLabel.isHidden = !text.isEmpty
    }

    private func updateHeight() {
        let size = textView.sizeThatFits(CGSize(
            width: textView.frame.width,
            height: .greatestFiniteMagnitude
        ))

        let contentHeight = size.height
        let newHeight = min(
            max(contentHeight, Metric.minHeight),
            Metric.maxHeight
        )

        containerHeightConstraint?.update(offset: newHeight)

        textView.isScrollEnabled = contentHeight > Metric.maxHeight
    }
}

// MARK: - UITextViewDelegate

extension LocationTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text ?? ""
        updatePlaceholder()
        updateHeight()
        textChanged.accept(text)
    }
}
