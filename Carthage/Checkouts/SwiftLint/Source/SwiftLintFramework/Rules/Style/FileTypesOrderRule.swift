import Foundation
import SourceKittenFramework

public struct FileTypesOrderRule: ConfigurationProviderRule, OptInRule {
    private typealias FileTypeOffset = (fileType: FileType, offset: Int)

    public var configuration = FileTypesOrderConfiguration()

    public init() {}

    public static let description = RuleDescription(
        identifier: "file_types_order",
        name: "File Types Order",
        description: "Specifies how the types within a file should be ordered.",
        kind: .style,
        nonTriggeringExamples: FileTypesOrderRuleExamples.nonTriggeringExamples,
        triggeringExamples: FileTypesOrderRuleExamples.triggeringExamples
    )

    // swiftlint:disable:next function_body_length
    public func validate(file: File) -> [StyleViolation] {
        guard let mainTypeSubstructure = mainTypeSubstructure(in: file),
            let mainTypeSubstuctureOffset = mainTypeSubstructure.offset else { return [] }

        let extensionsSubstructures = self.extensionsSubstructures(
            in: file,
            mainTypeSubstructure: mainTypeSubstructure
        )

        let supportingTypesSubstructures = self.supportingTypesSubstructures(
            in: file,
            mainTypeSubstructure: mainTypeSubstructure
        )

        let mainTypeOffset: [FileTypeOffset] = [(.mainType, mainTypeSubstuctureOffset)]
        let extensionOffsets: [FileTypeOffset] = extensionsSubstructures.compactMap { substructure in
            guard let offset = substructure.offset else { return nil }
            return (.extension, offset)
        }

        let supportingTypeOffsets: [FileTypeOffset] = supportingTypesSubstructures.compactMap { substructure in
            guard let offset = substructure.offset else { return nil }
            return (.supportingType, offset)
        }

        let orderedFileTypeOffsets = (mainTypeOffset + extensionOffsets + supportingTypeOffsets).sorted { lhs, rhs in
            return lhs.offset < rhs.offset
        }

        var violations =  [StyleViolation]()

        var lastMatchingIndex = -1
        for expectedTypes in configuration.order {
            var potentialViolatingIndexes = [Int]()

            let startIndex = lastMatchingIndex + 1
            (startIndex..<orderedFileTypeOffsets.count).forEach { index in
                let fileType = orderedFileTypeOffsets[index].fileType
                if expectedTypes.contains(fileType) {
                    lastMatchingIndex = index
                } else {
                    potentialViolatingIndexes.append(index)
                }
            }

            let violatingIndexes = potentialViolatingIndexes.filter { $0 < lastMatchingIndex }
            violatingIndexes.forEach { index in
                let fileTypeOffset = orderedFileTypeOffsets[index]

                let fileType = fileTypeOffset.fileType.rawValue
                let expected = expectedTypes.map { $0.rawValue }.joined(separator: ",")
                let article = ["a", "e", "i", "o", "u"].contains(fileType.substring(from: 0, length: 1)) ? "An" : "A"

                let styleViolation = StyleViolation(
                    ruleDescription: type(of: self).description,
                    severity: configuration.severityConfiguration.severity,
                    location: Location(file: file, byteOffset: fileTypeOffset.offset),
                    reason: "\(article) '\(fileType)' should not be placed amongst the file type(s) '\(expected)'."
                )
                violations.append(styleViolation)
            }
        }

        return violations
    }

    private func extensionsSubstructures(
        in file: File,
        mainTypeSubstructure: [String: SourceKitRepresentable]
    ) -> [[String: SourceKitRepresentable]] {
        return file.structure.dictionary.substructure.filter { substructure in
            guard let kind = substructure.kind else { return false }
            return substructure.bridge() != mainTypeSubstructure.bridge() &&
                kind.contains(SwiftDeclarationKind.extension.rawValue)
        }
    }

    private func supportingTypesSubstructures(
        in file: File,
        mainTypeSubstructure: [String: SourceKitRepresentable]
    ) -> [[String: SourceKitRepresentable]] {
        var supportingTypeKinds = SwiftDeclarationKind.typeKinds
        supportingTypeKinds.insert(SwiftDeclarationKind.protocol)

        return file.structure.dictionary.substructure.filter { substructure in
            guard let kind = substructure.kind else { return false }
            guard let declarationKind = SwiftDeclarationKind(rawValue: kind) else { return false }

            return substructure.bridge() != mainTypeSubstructure.bridge() &&
                supportingTypeKinds.contains(declarationKind)
        }
    }

    private func mainTypeSubstructure(in file: File) -> [String: SourceKitRepresentable]? {
        let dict = file.structure.dictionary

        guard let filePath = file.path else {
            return self.mainTypeSubstructure(in: dict)
        }

        let fileName = URL(fileURLWithPath: filePath).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
        guard let mainTypeSubstructure = dict.substructure.first(where: { $0.name == fileName }) else {
            return self.mainTypeSubstructure(in: file.structure.dictionary)
        }

        // specify type with name matching the files name as main type
        return mainTypeSubstructure
    }

    private func mainTypeSubstructure(in dict: [String: SourceKitRepresentable]) -> [String: SourceKitRepresentable]? {
        let priorityKinds: [SwiftDeclarationKind] = [.class, .enum, .struct]
        let priorityKindRawValues = priorityKinds.map { $0.rawValue }

        let priorityKindSubstructures = dict.substructure.filter { substructure in
            guard let kind = substructure.kind else { return false }
            return priorityKindRawValues.contains(kind)
        }

        let substructuresSortedByBodyLength = priorityKindSubstructures.sorted { lhs, rhs in
            return (lhs.bodyLength ?? 0) > (rhs.bodyLength ?? 0)
        }

        // specify class, enum or struct with longest body as main type
        return substructuresSortedByBodyLength.first
    }
}
