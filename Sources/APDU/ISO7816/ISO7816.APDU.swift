//
//  Created by Anton Spivak
//

import Buffbit

internal extension ISO7816 {
    typealias APDU = (
        cla: BufferElement,
        ins: BufferElement,
        p1: BufferElement,
        p2: BufferElement,
        lc: Buffer,
        body: Buffer,
        le: Buffer
    )
}
