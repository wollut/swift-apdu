//
//  Created by Anton Spivak
//

import Buffbit
import Foundation

// MARK: - Response.ResponseError

public extension Response {
    enum ResponseError {
        case notEnoughData(Buffer)
    }
}

// MARK: - Response.ResponseError + LocalizedError

extension Response.ResponseError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .notEnoughData(buffer):
            return "[ResponseError]: Not enough data to parse APDU response - \(buffer.hex)."
        }
    }
}
