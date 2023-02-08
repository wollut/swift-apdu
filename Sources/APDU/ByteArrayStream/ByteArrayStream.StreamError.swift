//
//  Created by Anton Spivak
//

import Foundation

// MARK: - ByteArrayStream.StreamError

internal extension ByteArrayStream {
    enum StreamError {
        case notEnoughBytes
    }
}

// MARK: - ByteArrayStream.StreamError + LocalizedError

extension ByteArrayStream.StreamError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notEnoughBytes:
            return "[StreamError]: Not enough bytes."
        }
    }
}
