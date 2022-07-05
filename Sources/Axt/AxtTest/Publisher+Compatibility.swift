import Combine

#if TESTABLE

@available(iOS, deprecated: 15.0, message: "For iOS 14 compatibility")
extension Publisher {
    var values: AsyncThrowingStream<Output, Error> {
        AsyncThrowingStream { continuation in
            let cancellable = sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        continuation.finish()
                    case let .failure(error):
                        continuation.finish(throwing: error)
                    }
                }, receiveValue: { value in
                    continuation.yield(value)
                }
            )
            continuation.onTermination = { @Sendable _ in
                cancellable.cancel()
            }
        }
    }
}

@available(iOS, deprecated: 15.0, message: "For iOS 14 compatibility")
public extension Publisher where Failure == Never {
    var values: AsyncStream<Output> {
        AsyncStream { continuation in
            let cancellable = sink(
                receiveCompletion: { _ in
                    continuation.finish()
                }, receiveValue: { value in
                    continuation.yield(value)
                }
            )
            continuation.onTermination = { @Sendable _ in
                cancellable.cancel()
            }
        }
    }
}

#endif
