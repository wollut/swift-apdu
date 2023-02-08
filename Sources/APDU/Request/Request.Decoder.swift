//
//  Created by Anton Spivak
//

import Buffbit

// MARK: - Request.Decoder

public extension Request {
    struct Decoder {
        // MARK: Lifecycle

        internal init(_ buffer: Buffer) {
            self.buffer = buffer
        }

        // MARK: Internal

        internal let buffer: Buffer
    }
}

internal extension Request.Decoder {
    func decode() throws -> Request {
        var stream = ByteArrayStream(buffer)

        func _le(_ bytes: Buffer) throws -> Int? {
            switch bytes.count {
            case 0:
                return nil
            case 1 where bytes[0] == 0x0:
                return ISO7816.maximumLengthShort
            case 1:
                return Int(bytes[0])
            case 2 where bytes[0] == 0x0 && bytes[1] == 0x0:
                return ISO7816.maximumLengthLong
            case 2:
                return Int(Int16(buffer: [bytes[0], bytes[1]]))
            case 3 where bytes[0] == 0x0 && bytes[1] == 0x0 && bytes[2] == 0x0:
                return ISO7816.maximumLengthLong
            case 3 where bytes[0] == 0x0:
                return Int(Int16(buffer: [bytes[1], bytes[2]]))
            default:
                throw DecodingError.invalidExpectedResponseLength(buffer)
            }
        }

        let header = try? stream.read(4)
        guard let header
        else {
            throw DecodingError.invalidHeader(buffer)
        }

        let data: Buffer?
        let expectedResponseLength: Int?

        let remainig = stream.remaining.buffer
        switch remainig.count {
        case 0, 1,
             3 where remainig[0] == 0x0:
            data = nil
            expectedResponseLength = try _le(remainig)
        default:
            var stream = ByteArrayStream(remainig)
            let dataLength: Int

            do {
                if remainig[0] == 0x0 {
                    try stream.skip()
                    dataLength = try Int(Int16(buffer: stream.read(2)))
                } else {
                    dataLength = try Int(stream.read())
                }

                data = try stream.read(dataLength)
            } catch {
                throw DecodingError.invalidBody(remainig)
            }

            expectedResponseLength = try _le(stream.remaining.buffer)
        }

        return Request(
            instructionClass: header[0],
            instructionCode: header[1],
            p1Parameter: header[2],
            p2Parameter: header[3],
            data: data,
            expectedResponseLength: expectedResponseLength
        )
    }
}
