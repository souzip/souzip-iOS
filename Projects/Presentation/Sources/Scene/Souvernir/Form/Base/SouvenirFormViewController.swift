import Domain
import PhotosUI
import RxSwift
import UIKit
import UniformTypeIdentifiers

final class SouvenirFormViewController: BaseViewController<
    SouvenirFormViewModel,
    SouvenirFormView
> {
    // MARK: - Life Cytle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHandling()
    }

    // MARK: - Bind

    override func bindState() {
        observeState()
            .map(\.navigationTitle)
            .distinct()
            .onNext { [weak self] in self?.contentView.renderTitle($0) }

        observeState()
            .map { ($0.mode, $0.localPhotos, $0.existingFiles) }
            .onNext { [weak self] mode, localPhotos, existingFiles in
                self?.contentView.renderPhotos(
                    mode: mode,
                    localPhotos: localPhotos,
                    existingFiles: existingFiles
                )
            }

        observeState()
            .map(\.name)
            .distinct()
            .onNext { [weak self] in self?.contentView.renderName($0) }

        observeState()
            .map { ($0.address, $0.locationDetail) }
            .onNext { [weak self] in self?.contentView.renderAddress($0, $1) }

        observe(\.currencySymbol)
            .distinct()
            .onNext(contentView.renderPrice)

        observeState()
            .map(\.category)
            .distinct()
            .onNext { [weak self] in self?.contentView.renderCategory($0) }

        observeState()
            .map { ($0.submitButtonTitle, $0.isSubmitEnabled) }
            .onNext { [weak self] title, isEnabled in
                self?.contentView.renderSubmitButton(title: title, isEnabled: isEnabled)
            }
    }

    // MARK: - Event

    override func handleEvent(_ event: Event) {
        switch event {
        case .showImagePicker:
            presentImagePicker()

        case let .showError(message):
            showDSAlert(message: message)
        }
    }

    // MARK: - Keyboard

    private func setupKeyboardHandling() {
        let center = NotificationCenter.default

        center.rx.notification(UIResponder.keyboardWillChangeFrameNotification)
            .bind { [weak self] in self?.handleKeyboardFrame(notification: $0) }
            .disposed(by: disposeBag)
    }

    private func handleKeyboardFrame(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }

        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
        let curveRaw = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue ?? 7
        let curve = UIView.AnimationOptions(rawValue: UInt(curveRaw << 16))

        let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect) ?? .zero

        // 키보드가 화면을 얼마나 가리는지 계산 (겹치는 높이)
        let keyboardInView = view.convert(keyboardEndFrame, from: nil)
        let overlap = max(0, view.bounds.maxY - keyboardInView.minY - view.safeAreaInsets.bottom)

        contentView.updateKeyboardHeight(overlap, duration: duration, curve: curve)
    }

    // MARK: - Picker

    private func presentImagePicker() {
        // edit 모드에서는 이미지 수정 안 함
        guard case .create = viewModel.state.value.mode else { return }

        let currentCount = viewModel.state.value.localPhotos.count
        let remainingSlots = max(0, 5 - currentCount)
        guard remainingSlots > 0 else { return }

        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.selectionLimit = remainingSlots
        configuration.preferredAssetRepresentationMode = .compatible

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
}

// MARK: - PHPickerViewControllerDelegate

extension SouvenirFormViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard !results.isEmpty else { return }

        Task { [weak self] in
            guard let self else { return }

            do {
                let photos = try await savePickedResultsToLocalPhotos(results)
                guard !photos.isEmpty else { return }
                viewModel.action.accept(.addLocalPhotos(photos))
            } catch {
                viewModel.event.accept(.showError("사진을 불러오는데 실패했어요. 다시 시도해주세요."))
            }
        }
    }

    private func savePickedResultsToLocalPhotos(_ results: [PHPickerResult]) async throws -> [LocalPhoto] {
        var output: [LocalPhoto] = []
        output.reserveCapacity(results.count)

        for result in results {
            guard result.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) else { continue }
            if let url = try await copyImageFileToCache(using: result.itemProvider) {
                output.append(LocalPhoto(id: UUID(), url: url))
            }
        }

        return output
    }

    private func copyImageFileToCache(using provider: NSItemProvider) async throws -> URL? {
        // 1) fileRepresentation 우선 시도
        do {
            let tempURL: URL? = try await withCheckedThrowingContinuation { continuation in
                provider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
                    if let error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: url)
                    }
                }
            }

            if let tempURL {
                return try copyTempURLToCache(tempURL)
            }
        } catch {
            // file로 못 받는 케이스가 많아서 여기서 바로 throw하지 말고 fallback
        }

        // 2) dataRepresentation fallback
        let data: Data? = try await withCheckedThrowingContinuation { continuation in
            provider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: data)
                }
            }
        }

        guard let data else { return nil }

        let destURL = try makeDestinationURL(fileExtension: "jpg")
        try data.write(to: destURL, options: [.atomic])
        return destURL
    }

    private func copyTempURLToCache(_ tempURL: URL) throws -> URL {
        let ext = tempURL.pathExtension.isEmpty ? "jpg" : tempURL.pathExtension
        let destURL = try makeDestinationURL(fileExtension: ext)

        if FileManager.default.fileExists(atPath: destURL.path) {
            try FileManager.default.removeItem(at: destURL)
        }
        try FileManager.default.copyItem(at: tempURL, to: destURL)
        return destURL
    }

    private func makeDestinationURL(fileExtension ext: String) throws -> URL {
        guard let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            throw PhotoCacheError.cachesDirectoryNotFound
        }
        let dir = caches.appendingPathComponent("SouvenirUploads", isDirectory: true)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("\(UUID().uuidString).\(ext)")
    }
}

enum PhotoCacheError: Error {
    case cachesDirectoryNotFound
}
