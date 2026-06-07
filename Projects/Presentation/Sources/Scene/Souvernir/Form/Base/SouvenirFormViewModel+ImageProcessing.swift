import UIKit

extension SouvenirFormViewModel {
    func convertPhotosToData(_ photos: [LocalPhoto]) throws -> [Data] {
        var results: [Data] = []
        results.reserveCapacity(photos.count)

        for photo in photos {
            try autoreleasepool {
                guard FileManager.default.fileExists(atPath: photo.url.path) else {
                    throw ImageProcessingError.invalidSource
                }

                guard let jpegData = resizeImageFromFile(at: photo.url, maxDimension: 3000, compressionQuality: 0.75) else {
                    throw ImageProcessingError.jpegConversionFailed
                }

                results.append(jpegData)
            }
        }

        return results
    }

    func resizeImageFromFile(
        at url: URL,
        maxDimension: CGFloat,
        compressionQuality: CGFloat
    ) -> Data? {
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            return nil
        }

        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any],
              let pixelWidth = properties[kCGImagePropertyPixelWidth] as? Int,
              let pixelHeight = properties[kCGImagePropertyPixelHeight] as? Int else {
            return nil
        }

        let needsResize = pixelWidth > Int(maxDimension) || pixelHeight > Int(maxDimension)

        let cgImage: CGImage?

        if needsResize {
            let options: [CFString: Any] = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: maxDimension,
                kCGImageSourceShouldCacheImmediately: true,
            ]
            cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary)
        } else {
            let options: [CFString: Any] = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: max(pixelWidth, pixelHeight),
                kCGImageSourceShouldCacheImmediately: true,
            ]
            cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary)
        }

        guard let finalCGImage = cgImage else {
            return nil
        }

        let uiImage = UIImage(cgImage: finalCGImage)
        return uiImage.jpegData(compressionQuality: compressionQuality)
    }
}

enum ImageProcessingError: LocalizedError {
    case invalidSource
    case thumbnailCreationFailed
    case jpegConversionFailed

    var errorDescription: String? {
        switch self {
        case .invalidSource:
            "사진을 불러오는 데 실패했어요."
        case .thumbnailCreationFailed:
            "사진을 처리하는 중 문제가 발생했어요."
        case .jpegConversionFailed:
            "사진을 저장 형식으로 변환하지 못했어요."
        }
    }
}
