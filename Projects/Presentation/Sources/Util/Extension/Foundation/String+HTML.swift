import UIKit

extension String {
    // HTML 태그 및 엔티티를 제거한 순수 텍스트 반환
    @MainActor
    var strippedHTML: String {
        guard let data = data(using: .utf8),
              let attributed = try? NSAttributedString(
                  data: data,
                  options: [
                      .documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue,
                  ],
                  documentAttributes: nil
              )
        else { return self }

        return attributed.string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
