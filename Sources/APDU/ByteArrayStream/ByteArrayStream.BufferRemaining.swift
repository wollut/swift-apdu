//
//  Created by Anton Spivak
//

import Buffbit

// MARK: - ByteArrayStream.BufferRemaining

internal extension ByteArrayStream {
    struct BufferRemaining {
        // MARK: Lifecycle

        init(caret: Int, original: Buffer) {
            self.caret = caret
            self.original = original
        }

        // MARK: Private

        private let caret: Int
        private let original: Buffer
    }
}

extension ByteArrayStream.BufferRemaining {
    // MARK: Internal

    var buffer: Buffer {
        let count = count
        if count > 0 {
            return Array(original[caret ..< original.count - 1])
        } else {
            return []
        }
    }

    var count: Int {
        original.count - caret
    }
}
