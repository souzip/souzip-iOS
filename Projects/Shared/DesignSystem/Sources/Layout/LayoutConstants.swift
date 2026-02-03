import Foundation

public enum LayoutConstants {
    /// 공통 간격 값
    public enum Spacing {
        public static let xxSmall: CGFloat = 4
        public static let xSmall: CGFloat = 8
        public static let small: CGFloat = 12
        public static let standard: CGFloat = 16
        public static let medium: CGFloat = 20
        public static let large: CGFloat = 24
        public static let xLarge: CGFloat = 32
        public static let xxLarge: CGFloat = 48
    }

    /// 공통 둥근 모서리 값
    public enum CornerRadius {
        public static let small: CGFloat = 8
        public static let button: CGFloat = 10
        public static let medium: CGFloat = 12
        public static let card: CGFloat = 16
        public static let large: CGFloat = 20
    }

    /// 공통 여백 값
    public enum Inset {
        public static let horizontal: CGFloat = 20
        public static let vertical: CGFloat = 16
        public static let small: CGFloat = 8
        public static let medium: CGFloat = 16
        public static let large: CGFloat = 24
    }

    /// 공통 크기 값
    public enum Size {
        /// 아이콘 크기
        public enum Icon {
            public static let xSmall: CGFloat = 16
            public static let small: CGFloat = 20
            public static let medium: CGFloat = 24
            public static let large: CGFloat = 32
            public static let xLarge: CGFloat = 40
        }

        /// 버튼 높이
        public enum Button {
            public static let small: CGFloat = 40
            public static let medium: CGFloat = 48
            public static let large: CGFloat = 56
        }
    }

    /// 공통 테두리 두께
    public enum BorderWidth {
        public static let thin: CGFloat = 0.5
        public static let standard: CGFloat = 1
        public static let thick: CGFloat = 2
    }
}
