import Foundation

func camelcase(_ text: String) -> String { 
	return ["/", "_", "-"]
		.reduce(text) { text, ofText in
			return text.replacingOccurrences(of: ofText, with: " ")
		}
        .components(separatedBy: " ")
        .enumerated()
        .map { index, text in
            if index == 0 {
                return text.lowercased()
            } else {
                let firstIndex = text.index(text.startIndex, offsetBy: 1)
                return text.substring(to: firstIndex).capitalized +
                    text.substring(from: firstIndex)
            }
        }
        .joined(separator: "")
}

func main() {
    guard CommandLine.arguments.count > 1 else {
        print("Input arguments, <OUTPUT_FILE_PATH>")
        return
    }

    /// Get default arguments
    let filePath = CommandLine.arguments[1]

    /// Make case list
    var caseList = [(String, String)]()
    caseList.append(("current", "Current"))
    caseList.append(("autoUpdatingCurrent", "autoUpdatingCurrent"))
    for timeZone in TimeZone.knownTimeZoneIdentifiers { 
       caseList.append((camelcase(timeZone), timeZone))
    }
    caseList.append(("utc", "UTC"))

    /// Make output text
    var fileText = "public enum ClockIdentifierName: String {\n"
    for item in caseList {
        fileText += "    case \(item.0) = \"\(item.1)\"\n"
    }
    fileText += "}"

    /// Save output file
    do {
        try fileText.write(toFile: filePath, atomically: false, encoding: .utf8)
    } catch let error {
        print(error)
        return
    }
    print("Success to generate cases, \(caseList.count) counts!")
}
main()
