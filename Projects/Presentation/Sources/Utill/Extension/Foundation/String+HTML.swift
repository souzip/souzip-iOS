import UIKit

extension String {
    // HTML 태그 및 엔티티를 제거한 순수 텍스트 반환
    // NSAttributedString HTML 파싱을 사용하므로 메인 스레드에서 호출 필요
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
