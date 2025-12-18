actor RefreshSynchronizer {
    private var ongoingTask: Task<Void, Error>?

    func execute(_ operation: @Sendable @escaping () async throws -> Void) async throws {
        if let existingTask = ongoingTask {
            return try await existingTask.value
        }

        let newTask = Task {
            try await operation()
        }

        ongoingTask = newTask

        defer {
            ongoingTask = nil
        }

        try await newTask.value
    }
}
