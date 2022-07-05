import Combine
import Foundation

#if TESTABLE

public struct TimeOut: Error {}

public extension Publisher where Failure == Never {
    /// Use only for testing
    /// Blocks the execution and returns the first value published by the
    /// publisher. If there's no value received during the `timeout` period,
    /// throws the `TimeOut` error.
    func firstValue(timeout: TimeInterval = 1) async throws -> Output {
        let value = await self.timeout(.seconds(timeout), scheduler: DispatchQueue.main)
            .values
            .first { _ in true }
        guard let value = value else { throw TimeOut() }
        return value
    }
}

#endif
