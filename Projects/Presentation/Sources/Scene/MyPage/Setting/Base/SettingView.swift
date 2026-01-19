import DesignSystem
import SnapKit
import UIKit

final class SettingView: BaseView<SettingAction>, UITableViewDataSource, UITableViewDelegate {

    private enum Metric {
        static let rowHeight: CGFloat = 48
        static let sectionTopSpacing: CGFloat = 12
        static let sectionBottomSpacing: CGFloat = 12
    }

    private let naviBar = DSNavigationBar(
        title: "설정",
        style: .back
    )

    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.separatorColor = .clear
        tv.showsVerticalScrollIndicator = false
        tv.contentInset = .init(top: 12, left: 0, bottom: 24, right: 0)
        return tv
    }()

    private let sections: [SettingSection] = SettingSection.allCases

    override func setAttributes() {
        backgroundColor = .dsBackground

        addSubview(naviBar)
        addSubview(tableView)

        naviBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        tableView.dataSource = self
        tableView.delegate = self

        bind(naviBar.onLeftTap).to(.back)

        tableView.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as? SettingCell
        else { return UITableViewCell() }

        let rows = sections[indexPath.section].rows
        let row = rows[indexPath.row]

        let position: SettingCell.Position = {
            if rows.count == 1 { return .single }
            if indexPath.row == 0 { return .top }
            if indexPath.row == rows.count - 1 { return .bottom }
            return .middle
        }()

        switch row {
        case .spacer:
            cell.configureSpacer(position: position)

        case let .title(text):
            cell.configureTitle(text, position: position)

        case let .item(item):
            let isLast = indexPath.row == rows.count - 1
            cell.configureItem(item, position: position, isLast: isLast)
        }

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = sections[indexPath.section].rows[indexPath.row]
        switch row {
        case let .spacer(height):
            return height
        case .title, .item:
            return Metric.rowHeight
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { 12 }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let row = sections[indexPath.section].rows[indexPath.row]

        guard case let .item(item) = row else { return }
        action.accept(.tapItem(item.type))
    }
}
