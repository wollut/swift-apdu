//
//  Created by Anton Spivak
//

import Buffbit
import Foundation

// MARK: - Response

public struct Response {
    // MARK: Lifecycle

    /// - parameter value: Data buffer
    public init(_ value: Data) throws {
        try self.init(Buffer(value))
    }

    /// - parameter buffer: `Buffer`
    public init(_ buffer: Buffer) throws {
        guard buffer.count >= 2
        else {
            throw ResponseError.notEnoughData(buffer)
        }

        var data = Buffer()
        if buffer.count > 2 {
            data = Array(buffer[0 ..< (buffer.count - 2)])
        }

        let sws = Array(buffer[(buffer.count - 2) ..< (buffer.count)])
        self.init(
            data: data,
            statusWord1: sws[0],
            statusWord2: sws[1]
        )
    }

    public init(data: Buffer, statusWord1: BufferElement, statusWord2: BufferElement) {
        self.data = data
        self.statusWord1 = statusWord1
        self.statusWord2 = statusWord2
    }

    // MARK: Public

    /// Body
    public let data: Buffer

    /// SW1 parameter
    public let statusWord1: BufferElement

    /// SW2 parameter
    public let statusWord2: BufferElement

    // MARK: Private

    private var buffer: Buffer {
        data + [statusWord1, statusWord2]
    }
}

// MARK: RawRepresentable

extension Response: RawRepresentable {
    public init?(rawValue: Buffer) {
        try? self.init(rawValue)
    }

    public var rawValue: Buffer {
        buffer
    }
}

// MARK: CustomStringConvertible

extension Response: CustomStringConvertible {
    public var description: String {
        return """
        >>> SW1: \([statusWord1].hex)
        >>> SW2: \([statusWord2].hex)
        >>> DATA: \(data.hex)
        """
    }
}
