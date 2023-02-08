//
//  Created by Anton Spivak
//

import Buffbit

// MARK: - Request

public struct Request {
    // MARK: Lifecycle

    /// - parameter buffer: `Buffer`
    public init(_ buffer: Buffer) throws {
        self = try Decoder(buffer).decode()
    }

    /// - parameter instructionClass: Class (CLA) byte.
    /// - parameter instructionCode: Instruction (INS) byte.
    /// - parameter p1Parameter: P1 parameter.
    /// - parameter p2Parameter: P2 parameter.
    /// - parameter header: Header of the APDU request command
    /// - parameter data: Request body
    /// - parameter expectedResponseLength: Le (Expected response length);  `nil` means no response
    /// data field is expected.
    public init(
        instructionClass: BufferElement,
        instructionCode: BufferElement,
        p1Parameter: BufferElement,
        p2Parameter: BufferElement,
        data: Buffer? = nil,
        expectedResponseLength: Int? = nil
    ) {
        self.instructionClass = instructionClass
        self.instructionCode = instructionCode
        self.p1Parameter = p1Parameter
        self.p2Parameter = p2Parameter

        self.data = data
        self.expectedResponseLength = expectedResponseLength
    }

    // MARK: Public

    /// Class (CLA) byte.
    public let instructionClass: BufferElement

    /// Instruction (INS) byte.
    public let instructionCode: BufferElement

    /// P1 parameter.
    public let p1Parameter: BufferElement

    /// P2 parameter.
    public let p2Parameter: BufferElement

    /// Data field; nil if data field is absent
    public let data: Buffer?

    /// Le (Expected response length);  `nil` means no response data field is expected.
    public let expectedResponseLength: Int?

    // MARK: Private

    private var buffer: Buffer {
        do {
            let apdu = try Encoder(self).encode()
            return [apdu.cla, apdu.ins, apdu.p1, apdu.p2] + apdu.lc + apdu.body + apdu.le
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }
}

// MARK: RawRepresentable

extension Request: RawRepresentable {
    public init?(rawValue: Buffer) {
        try? self.init(rawValue)
    }

    public var rawValue: Buffer {
        buffer
    }
}

// MARK: CustomStringConvertible

extension Request: CustomStringConvertible {
    public var description: String {
        do {
            let apdu = try Encoder(self).encode()
            return """
            <<< CLA: \([apdu.cla].hex)
            <<< INS: \([apdu.ins].hex)
            <<< P1: \([apdu.p1].hex)
            <<< P2: \([apdu.p2].hex)
            <<< LC: \(apdu.lc.hex)
            <<< BODY: \(apdu.body.hex)
            <<< LE: \(apdu.le.hex)
            """
        } catch {
            return "<<< Can't encode APDU command."
        }
    }
}
