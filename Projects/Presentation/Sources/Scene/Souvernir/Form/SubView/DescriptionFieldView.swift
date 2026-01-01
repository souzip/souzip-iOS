import DesignSystem
import RxRelay
import RxSwift
import SnapKit
import UIKit

final class DescriptionFieldView: UIView {
    let textChanged = PublishRelay<String>()

    // MARK: - Metric

    private enum Metric {
        static let textViewHeight: CGFloat = 200
        static let inset = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
    }

    // MARK: - UI

    private let titleLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGreyWhite
        label.setTypography(.body1SB)
        label.text = "기념품소개"
        return label
    }()

    let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.textContainerInset = Metric.inset
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.dsGreyWhite.cgColor
        tv.layer.cornerRadius = 10
        tv.textContainer.lineFragmentPadding = 0
        return tv
    }()

    private let placeholderLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.text = "나만의 기념품을 소개해주세요."
        label.textColor = .dsGrey500
        label.setTypography(.body3M)
        return label
    }()

    private let countLabel: TypographyLabel = {
        let label = TypographyLabel()
        label.textColor = .dsGrey300
        label.setTypography(.body4R)
        label.textAlignment = .right
        return label
    }()

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        configure()
        setAttributes()
        setBindings()
        updateUI(text: "")
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func configure() {
        setHierarchy()
        setConstraints()
    }

    private func setHierarchy() {
        [titleLabel, textView, countLabel].forEach { addSubview($0) }
        textView.addSubview(placeholderLabel)
    }

    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(24)
        }

        textView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(Metric.textViewHeight)
        }

        // textContainerInset(top:12, left:20)과 맞춤
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Metric.inset.top)
            make.leading.equalToSuperview().inset(Metric.inset.left)
        }

        countLabel.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(8)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func setAttributes() {
        textView.setTypography(.body3M, textColor: .dsGreyWhite)
    }

    private func setBindings() {
        textView.delegate = self
    }

    func updateUI(text: String) {
        placeholderLabel.isHidden = !text.isEmpty
        countLabel.text = "\(text.count)/2,000"
    }

    func updatePlaceholder(isHidden: Bool) {
        placeholderLabel.isHidden = isHidden
    }

    func updateCount(text: String) {
        countLabel.text = "\(text.count)/2,000"
    }
}

extension DescriptionFieldView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text ?? ""
        updateCount(text: text)
        textChanged.accept(text)
    }

    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        let currentText = textView.text ?? ""
        guard let textRange = Range(range, in: currentText) else {
            return false
        }

        let updatedText = currentText.replacingCharacters(in: textRange, with: text)

        if updatedText.count <= 2000 {
            return true
        }

        let remaining = 2000 - currentText.count
        guard remaining > 0 else {
            return false
        }

        let allowedText = String(text.prefix(remaining))
        let finalText = currentText.replacingCharacters(in: textRange, with: allowedText)

        textView.text = finalText

        if let newPosition = textView.position(
            from: textView.beginningOfDocument,
            offset: finalText.count
        ) {
            textView.selectedTextRange =
                textView.textRange(from: newPosition, to: newPosition)
        }

        updateCount(text: finalText)
        textChanged.accept(finalText)

        return false
    }
}
