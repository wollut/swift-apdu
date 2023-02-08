//
//  Created by Anton Spivak
//

import Foundation

// MARK: - Request.Encoder.EncodingError

public extension Request.Encoder {
    enum EncodingError {
        case dataTooLarge
        case invalidExpectedResponseLength(Int)
        case expectedResponseLengthOutOfBounds
    }
}

// MARK: - Request.Encoder.EncodingError + LocalizedError

extension Request.Encoder.EncodingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .dataTooLarge:
            return "[EncodingError]: Body larger than 65535."
        case let .invalidExpectedResponseLength(value):
            return "[EncodingError]: Expected response length value is invalid - \(value)."
        case .expectedResponseLengthOutOfBounds:
            return "[EncodingError]: Expected length of response is out of bounds (0, 65536)."
        }
    }
}
