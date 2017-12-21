import Cocoa
import Foundation


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
    let parser = DirectoryParser(with: url)
    parser.parse(limit: limit, filetype: option?.directoryParserOption ?? .all)
}
catch let error as CommandLineParser.Result {
    showHelp(with: error.localizedDescription)
    exit(0)
}



