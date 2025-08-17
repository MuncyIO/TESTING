# ReceiptApp

Minimal macOS receipt tracker built with SwiftUI and Core Data. This is the first iteration focusing on importing and storing receipt images locally.

## Features
- List of saved receipts (initially empty).
- **Add Receipt** button opens camera or file picker to import an image.
- Images saved to `Application Support/<bundle id>/Receipts/` and referenced by path in Core Data.
- Basic OCR via Vision to pre-fill vendor, date and total.
- Detail view with full image, editable fields and delete option.

## Colors
- Background: `#0B0B0D`
- Surface: `#121214`
- Accent Primary: `#FF5A00`
- Accent Secondary: `#FF8A33`
- Text Primary: `#FFFFFF`
- Text Muted: `#BDBDBD`

## Local Data Model
`Receipt` entity fields:
- `id: UUID`
- `vendor: String?`
- `total: Decimal?`
- `date: Date?`
- `tags: [String]?`
- `imagePath: String`
- `createdAt: Date`

## Setup & Run
1. Open the project in Xcode 15+ on macOS Big Sur or later.
2. Build and run the **ReceiptApp** target.
3. Use the toolbar **Add Receipt** button to capture or choose an image.

## Testing
`ReceiptAppTests` includes a minimal Core Data save/load test.
Run with `xcodebuild test` in Xcode or via the Test navigator.

## TODO
- Cloud sync via Supabase or S3.
- Better OCR parsing and correction UI.
