//
//  Created by Anton Spivak
//

// MARK: - ByteArrayStream

import Buffbit

internal struct ByteArrayStream {
    // MARK: Lifecycle

    init(_ buffer: Buffer) {
        self.buffer = buffer
    }

    // MARK: Internal

    var remaining: BufferRemaining {
        BufferRemaining(
            caret: caret,
            original: buffer
        )
    }

    mutating func read() throws -> BufferElement {
        let next = try read(1)
        return next[0]
    }

    mutating func read(_ next: Int) throws -> Buffer {
        let remainingBuffer = remaining.buffer
        guard remainingBuffer.count >= next
        else {
            throw StreamError.notEnoughBytes
        }

        caret += next

        return Array(remainingBuffer[0 ..< next])
    }

    mutating func skip() throws {
        try skip(0)
    }

    mutating func skip(_ next: Int) throws {
        let remainingCount = remaining.count
        guard remainingCount >= next
        else {
            throw StreamError.notEnoughBytes
        }

        caret += next
    }

    mutating func reset() {
        caret = 0
    }

    // MARK: Private

    private var buffer: Buffer

    private var caret: Int = 0
}
