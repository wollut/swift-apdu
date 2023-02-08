# APDU

Work with ISO7816 APDU commands for JavaCard within Swift

## Installation
```swift
.package(
    url: "https://github.com/whalescorp/swift-apdu.git",
    .upToNextMajor(from: "0.1.0")
)
```

## Usage with CryptoTokenKit
```swift
import APDU
import CryptoTokenKit

let headerHEXString = ""
let bodyHEXString = ""

let card: TKSmartCard

do {
    let header = Buffer(headerHEXString)
    let request = try Request(
        instructionClass: header[0],
        instructionCode: header[1],
        p1Parameter: header[2],
        p2Parameter: header[3],
        data: Buffer(bodyHEXString)
    )

    try await card.beginSession()

    let value = try await card.transmit(Data(request.rawValue))
    let response = try Response(Buffer(value))
    
    console.log(response)

    if let statusDescription = response.statusDescription {
        switch statusDescription.kind {
        case .default:
            log(kind: .default, ">>>", response.hex, "-", statusDescription)
        case .info, .warning:
            log(kind: .info, ">>>", response.hex, "-", statusDescription)
        case .error:
            log(kind: .error, ">>>", response.hex, "-", statusDescription)
        }
    } else {
        log(kind: .error, ">>>", response.hex, "-", "No status description.")
    }
} catch {
    card.endSession()
    console.log(error.localizedDescription)
}
```

## Usage with CoreNFC
```swift
// TODO:
```

## Authors
- anton@stragner.com
