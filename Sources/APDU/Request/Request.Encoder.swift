//
//  Created by Anton Spivak
//

import Buffbit

// MARK: - Request.Encoder

public extension Request {
    struct Encoder {
        // MARK: Lifecycle

        internal init(_ request: Request) {
            self.request = request
        }

        // MARK: Internal

        internal let request: Request
    }
}

internal extension Request.Encoder {
    func encode() throws -> ISO7816.APDU {
        let encodedDataLength: Buffer
        let encodedBody: Buffer
        let encodedExpectedLength: Buffer

        if let body = request.data, !body.isEmpty {
            switch body.count {
            case 0:
                encodedDataLength = []
            case 1 ..< ISO7816.maximumLengthShort:
                encodedDataLength = [BufferElement(body.count)]
            case ISO7816.maximumLengthShort:
                encodedDataLength = [0x0]
            case ISO7816.maximumLengthShort + 1 ..< ISO7816.maximumLengthLong:
                encodedDataLength = [0x0] + UInt16(body.count).buffer()
            case ISO7816.maximumLengthLong:
                encodedDataLength = [0x0, 0x0, 0x0]
            default:
                throw EncodingError.dataTooLarge
            }

            encodedBody = body
        } else {
            encodedDataLength = []
            encodedBody = []
        }

        if let expectedResponseLength = request.expectedResponseLength {
            switch expectedResponseLength {
            case .min ..< 0:
                throw EncodingError.invalidExpectedResponseLength(expectedResponseLength)
            case 0:
                encodedExpectedLength = []
            case 1 ..< ISO7816.maximumLengthShort:
                encodedExpectedLength = [BufferElement(expectedResponseLength)]
            case ISO7816.maximumLengthShort:
                encodedExpectedLength = [0x0]
            case ISO7816.maximumLengthShort + 1 ..< ISO7816.maximumLengthLong:
                let le = UInt16(expectedResponseLength).buffer()
                encodedExpectedLength = encodedDataLength.count > 1 ? le : [0x0] + le
            case ISO7816.maximumLengthLong:
                encodedExpectedLength = encodedDataLength.count > 1 ? [0x0, 0x0] : [0x0, 0x0, 0x0]
            default:
                throw EncodingError.expectedResponseLengthOutOfBounds
            }
        } else {
            encodedExpectedLength = []
        }

        return (
            request.instructionClass,
            request.instructionCode,
            request.p1Parameter,
            request.p2Parameter,
            encodedDataLength,
            encodedBody,
            encodedExpectedLength
        )
    }
}
