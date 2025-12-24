import UIKit

public struct DSTabBarItem {
    public let title: String
    public let image: UIImage
    public let selectedImage: UIImage

    public init(title: String, image: UIImage, selectedImage: UIImage) {
        self.title = title
        self.image = image
        self.selectedImage = selectedImage
    }
}
