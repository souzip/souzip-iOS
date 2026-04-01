import DesignSystem
import UIKit

/// 하이라이트 스타일.
struct HighlightStyle {
    let color: UIColor

    static let main = HighlightStyle(color: .dsMain)
}

/// 텍스트 내 검색어 하이라이트 유틸.
enum TextHighlight {
    // MARK: - Preset

    static func primary(text: String, searchText: String) -> NSAttributedString {
        styled(
            text: text,
            searchText: searchText,
            typography: Typography.body1SB,
            baseColor: .dsGreyWhite,
            highlight: .main
        )
    }

    static func secondary(text: String, searchText: String) -> NSAttributedString {
        styled(
            text: text,
            searchText: searchText,
            typography: Typography.body3M,
            baseColor: .dsGrey500,
            highlight: .main
        )
    }

    // MARK: - Custom

    static func styled(
        text: String,
        searchText: String,
        typography: Typography,
        baseColor: UIColor,
        highlight: HighlightStyle
    ) -> NSAttributedString {
        let attributed = NSMutableAttributedString(
            string: text,
            attributes: baseAttributes(
                typography: typography,
                baseColor: baseColor,
                lineBreakMode: .byTruncatingTail
            )
        )

        let tokens = tokenize(searchText)
        let ranges = mergeRanges(allMatchRanges(in: text, tokens: tokens))
        for range in ranges {
            attributed.addAttribute(.foregroundColor, value: highlight.color, range: range)
        }

        return attributed
    }

    // MARK: - Private — Attributes

    private static func baseAttributes(
        typography: Typography,
        baseColor: UIColor,
        lineBreakMode: NSLineBreakMode
    ) -> [NSAttributedString.Key: Any] {
        var attributes = typography.toAttributes().merging([.foregroundColor: baseColor]) { $1 }

        let paragraphStyle: NSMutableParagraphStyle
        if let existing = attributes[.paragraphStyle] as? NSParagraphStyle {
            paragraphStyle = existing.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        } else {
            paragraphStyle = NSMutableParagraphStyle()
        }
        paragraphStyle.lineBreakMode = lineBreakMode
        attributes[.paragraphStyle] = paragraphStyle

        return attributes
    }

    // MARK: - Private — Matching

    private static func tokenize(_ searchText: String) -> [String] {
        searchText
            .components(separatedBy: .whitespaces)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    private static func allMatchRanges(
        in text: String,
        tokens: [String]
    ) -> [NSRange] {
        let nsText = text as NSString
        let fullRange = NSRange(location: 0, length: nsText.length)

        var ranges: [NSRange] = []
        for token in tokens {
            let escaped = NSRegularExpression.escapedPattern(for: token)
            guard let regex = try? NSRegularExpression(
                pattern: escaped,
                options: .caseInsensitive
            ) else { continue }

            regex.enumerateMatches(in: text, options: [], range: fullRange) { result, _, _ in
                if let result { ranges.append(result.range) }
            }
        }
        return ranges
    }

    private static func mergeRanges(_ ranges: [NSRange]) -> [NSRange] {
        guard ranges.count > 1 else { return ranges }

        let sorted = ranges.sorted { $0.location < $1.location }
        var merged = [sorted[0]]

        for current in sorted.dropFirst() {
            guard let last = merged.last else { continue }
            if current.location <= last.location + last.length {
                let end = max(last.location + last.length, current.location + current.length)
                merged[merged.count - 1] = NSRange(location: last.location, length: end - last.location)
            } else {
                merged.append(current)
            }
        }

        return merged
    }
}
