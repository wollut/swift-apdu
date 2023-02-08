//
//  Created by Anton Spivak
//

// MARK: - ISO7816

// +------+---------+------------------------------------------------------------------------------+
// | name | bytes   |                             description                                      |
// +------+---------+------------------------------------------------------------------------------+
// | CLA  |    1    | Instruction class - indicates the type of command, e.g.,                     |
// |      |         | interindustry or proprietary                                                 |
// +------+---------+------------------------------------------------------------------------------+
// | INS  |    1    | Instruction code - indicates the specific command, e.g.,                     |
// |      |         | "select", "write data"                                                       |
// +------+---------+------------------------------------------------------------------------------+
// |  P1  |    1    | Instruction parameters for the command, e.g.,                                |
// |      |         | offset into file at which to write the data                                  |
// +------+---------+------------------------------------------------------------------------------+
// |  P2  |    1    | Instruction parameters for the command, e.g.,                                |
// |      |         | offset into file at which to write the data                                  |
// +------+---------+------------------------------------------------------------------------------+
// |  LC  |  0|1|3  | Encodes the number (Nc) of bytes of command data to follow                   |
// |      |         | - 0 bytes denotes Nc=0                                                       |
// |      |         | - 1 byte with a value from 1 to 255 denotes Nc with the same length          |
// |      |         | - 3 bytes, the first of which must be 0,                                     |
// |      |         |     denotes Nc in the range 1 to 65 535 (all three bytes may not be zero)    |
// +------+---------+------------------------------------------------------------------------------+
// | BODY |    N    | Bytes of data                                                                |
// +------+---------+------------------------------------------------------------------------------+
// |  LE  | 0|1|2|3 | Encodes the maximum number (Ne) of response bytes expected                   |
// |      |         | - 0 bytes denotes Ne=0                                                       |
// |      |         | - 1 byte in the range 1 to 255 denotes that value of Ne, or 0 denotes Ne=256 |
// |      |         | - 2 bytes (if extended Lc was present in the command)                        |
// |      |         |     in the range 1 to 65 535 denotes Ne of that value,                       |
// |      |         |     or two zero bytes denotes 65 536                                         |
// |      |         | - 3 bytes (if Lc was not present in the command),                            |
// |      |         |     the first of which must be 0, denote Ne in the same way as two-byte Le   |
// +------+---------+------------------------------------------------------------------------------+
// -------------------------------------------------------------------------------------------------
// | DATA |    N    | Response data                                                                |
// +------+---------+------------------------------------------------------------------------------+
// | SW1  |    1    | Command processing status                                                    |
// +------+---------+------------------------------------------------------------------------------+
// | SW2  |    1    | Command processing status                                                    |
// +------+---------+------------------------------------------------------------------------------+

internal enum ISO7816 {
    static let maximumLengthShort: Int = 256
    static let maximumLengthLong: Int = 65536
}
