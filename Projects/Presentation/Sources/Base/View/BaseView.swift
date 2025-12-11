import RxCocoa
import RxRelay
import RxSwift
import UIKit

class BaseView<Action>: UIView, ActionBindable {
    let action = PublishRelay<Action>()
    let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
    }

    func setAttributes() {
        // Override in subclass
    }

    func setHierarchy() {
        // Override in subclass
    }

    func setConstraints() {
        // Override in subclass
    }

    func setBindings() {
        // Override in subclass
    }
}
