#if canImport(AppKit) && canImport(Vision)
import Foundation
import Vision
import AppKit

/// Result of OCR parsing.
struct OCRResult {
    var vendor: String?
    var total: Decimal?
    var date: Date?
}

/// Performs basic OCR on receipt images using Vision.
final class OCRService {
    func extract(from image: NSImage, completion: @escaping (OCRResult) -> Void) {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            completion(OCRResult())
            return
        }
        let request = VNRecognizeTextRequest { request, _ in
            var result = OCRResult()
            if let observations = request.results as? [VNRecognizedTextObservation] {
                let lines = observations.compactMap { $0.topCandidates(1).first?.string }
                result.vendor = self.detectVendor(in: lines)
                result.total = self.detectTotal(in: lines)
                result.date = self.detectDate(in: lines)
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }
        request.recognitionLevel = .accurate
        let handler = VNImageRequestHandler(cgImage: cgImage)
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }

    private func detectVendor(in lines: [String]) -> String? {
        return lines.first
    }

    private func detectTotal(in lines: [String]) -> Decimal? {
        let pattern = "(total|amount)\\D*(\\d+[.,]\\d{2})"
        let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        for line in lines {
            if let match = regex?.firstMatch(in: line, options: [], range: NSRange(location: 0, length: line.count)),
               let range = Range(match.range(at: 2), in: line) {
                let number = line[range].replacingOccurrences(of: ",", with: ".")
                return Decimal(string: number)
            }
        }
        return nil
    }

    private func detectDate(in lines: [String]) -> Date? {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
        for line in lines {
            if let match = detector?.firstMatch(in: line, options: [], range: NSRange(location: 0, length: line.count)),
               let date = match.date {
                return date
            }
        }
        return nil
    }
}
#endif
