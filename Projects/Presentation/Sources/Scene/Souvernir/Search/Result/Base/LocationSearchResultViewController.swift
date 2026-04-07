import UIKit

final class LocationSearchResultViewController: BaseViewController<
    LocationSearchResultViewModel,
    LocationSearchResultView
> {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.renderPins(viewModel.state.value.items)
        // observeState의 updateSelection은 setSearchPins보다 먼저 호출되어 핀 선택이 스킵될 수 있음 → 핀 생성 후 VM 기준으로 다시 동기화
        contentView.updateSelection(selectedIndex: viewModel.state.value.selectedIndex)
    }

    // MARK: - Bind State

    override func bindState() {
        observeState()
            .map { ($0.items, $0.searchText, $0.selectedIndex) }
            .onNext { [weak self] items, searchText, selectedIndex in
                self?.contentView.render(items: items, searchText: searchText, selectedIndex: selectedIndex)
                self?.contentView.updateSelection(selectedIndex: selectedIndex)
            }

        observe(\.selectedIndex)
            .distinct()
            .unwrapped()
            .onNext { [weak self] index in
                guard let self,
                      viewModel.state.value.items.indices.contains(index) else { return }
                contentView.moveCamera(to: viewModel.state.value.items[index].coordinate)
            }
    }

    // MARK: - Route

    // Route 처리는 M3 코디네이터에서 담당
}
