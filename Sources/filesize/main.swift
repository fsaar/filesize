import Cocoa
import Foundation
import filesizeCore

func showHelp(with error: String? = nil) {
    if let error = error {
        print("\nERROR: \(error)\n")
    }
    print("""
filesize: Tool to list files that have more than <limit> number of lines
filesize <path> --limit <number> --<Options>
Options:
    --swift: consider only swift files
    --objc: consider only objc files
    --help: this help
""")
}


FileManager.default.changeCurrentDirectoryPath("/Users/fsaar/Dropbox/Programs/filesize")
let commandLineParser = CommandLineParser(arguments: CommandLine.arguments)
do {
    let (url,limit,option) = try commandLineParser.parseCommandLine()
    let fileEnumerator =  FileEnumerator(with: url)
    let parser = DirectoryParser(with: fileEnumerator)
    let results = parser.parse(limit: limit, filetype: option?.directoryParserOption ?? .all)
    for (url,lineCount) in results {
        print("# \(lineCount)\t: \(url.path)")
    }
}
catch let error as CommandLineParser.Result {
    showHelp(with: error.message)
    exit(0)
}



