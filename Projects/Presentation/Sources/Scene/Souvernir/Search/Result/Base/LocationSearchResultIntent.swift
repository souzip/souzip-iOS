import CoreLocation

// MARK: - State

struct LocationSearchResultState {
    var items: [SearchResultItem]
    var selectedIndex: Int?
    var searchText: String

    var selectedItem: SearchResultItem? {
        guard let selectedIndex else { return nil }
        guard items.indices.contains(selectedIndex) else { return nil }
        return items[selectedIndex]
    }

    init(items: [SearchResultItem], searchText: String) {
        self.items = items
        self.searchText = searchText
        // 검색에서 탭한 항목이 앞으로 온 배열이므로 첫 번째가 선택 상태
        selectedIndex = items.isEmpty ? nil : 0
    }
}

// MARK: - Action

enum LocationSearchResultAction {
    /// 리스트 셀 탭 — 상태만 갱신, 컬렉션 스크롤 없음
    case selectItemFromList(Int)
    /// 맵 핀 탭 — 상태 갱신 + 해당 행이 보이도록 스크롤 (View에서 처리)
    case selectItemFromMap(Int)
    case tapConfirm
    case back
    /// 맵 상단 검색바 탭 — 검색 화면으로 무애니 pop 후 검색어 전달
    case tapSearchBar
    /// 검색바 X — 무애니 pop 후 검색 초기화
    case tapClearSearchBar
}
