//
//  Created by Anton Spivak
//

import Buffbit
import Foundation

// MARK: - Request.Decoder.DecodingError

public extension Request.Decoder {
    enum DecodingError {
        case invalidHeader(Buffer)
        case invalidBody(Buffer)
        case invalidExpectedResponseLength(Buffer)
    }
}

// MARK: - Request.Decoder.DecodingError + LocalizedError

extension Request.Decoder.DecodingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .invalidHeader(buffer):
            return "[DecodingError]: Can't parse (CLA, INS, P1, P2) inside APDU:- \(buffer.hex)."
        case let .invalidBody(buffer):
            return "[DecodingError]: Can't parse (LC, body) inside APDU: - \(buffer.hex)"
        case let .invalidExpectedResponseLength(buffer):
            return "[DecodingError]: Can't parse (LE) inside APDU - \(buffer.hex)."
        }
    }
}
