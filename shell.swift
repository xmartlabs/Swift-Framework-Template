#!/usr/bin/env xcrun swift

import Foundation

let templateFrameworkName = "XLProductName"
let templateBundleDomain = "XLOrganizationIdentifier"
let templateAuthor = "XLAuthorName"
let templateAuthorEmail = "XLAuthorEmail"
let templateUserName = "XLUserName"
let templateOrganizationName = "XLOrganizationName"

var frameworkName = "MyFramework"
var bundleDomain = "com.xmartlabs"
var author = "Xmartlabs SRL"
var authorEmail = "swift@xmartlabs.com"
var userName = "xmartlabs"
var organizationName = "Xmartlabs SRL"

let fileManager = FileManager.default

let runScriptPathURL = NSURL(fileURLWithPath: fileManager.currentDirectoryPath, isDirectory: true)
let currentScriptPathURL = NSURL(fileURLWithPath: NSURL(fileURLWithPath: CommandLine.arguments[0], relativeTo: runScriptPathURL as URL).deletingLastPathComponent!.path, isDirectory: true)
let iOSFrameworkTemplateForlderURL = NSURL(fileURLWithPath: "Framework-iOS", relativeTo: currentScriptPathURL as URL)
var newFrameworkFolderPath = ""
let ignoredFiles = [".DS_Store", "UserInterfaceState.xcuserstate"]

extension NSURL {
    var fileName: String {
        var fileName: AnyObject?
        try! getResourceValue(&fileName, forKey: URLResourceKey.nameKey)
        return fileName as! String
    }

    var isDirectory: Bool {
        var isDirectory: AnyObject?
        try! getResourceValue(&isDirectory, forKey: URLResourceKey.isDirectoryKey)
        return isDirectory as! Bool
    }

    func renameIfNeeded() {
        if let _ = fileName.range(of: "XLProductName") {
            let renamedFileName = fileName.replacingOccurrences(of: "XLProductName", with: frameworkName)
            try! FileManager.default.moveItem(at: self as URL, to: NSURL(fileURLWithPath: renamedFileName, relativeTo: deletingLastPathComponent) as URL)
        }
    }

    func updateContent() {
        guard let path = path, let content = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) else {
            print("ERROR READING: \(self)")
            return
        }
        var newContent = content.replacingOccurrences(of: templateFrameworkName, with: frameworkName)
        newContent = newContent.replacingOccurrences(of: templateBundleDomain, with: bundleDomain)
        newContent = newContent.replacingOccurrences(of: templateAuthor, with: author)
        newContent = newContent.replacingOccurrences(of: templateUserName, with: userName)
        newContent = newContent.replacingOccurrences(of: templateAuthorEmail, with: authorEmail)
        newContent = newContent.replacingOccurrences(of: templateOrganizationName, with: organizationName)
        try! newContent.write(to: self as URL, atomically: true, encoding: String.Encoding.utf8)
    }
}

func printInfo<T>(message: T)  {
    print("\n-------------------Info:-------------------------")
    print("\(message)")
    print("--------------------------------------------------\n")
}

func printErrorAndExit<T>(message: T) {
    print("\n-------------------Error:-------------------------")
    print("\(message)")
    print("--------------------------------------------------\n")
    exit(1)
}

func checkThatFrameworkForlderCanBeCreated(frameworkURL: NSURL){
    var isDirectory: ObjCBool = true
    if fileManager.fileExists(atPath: frameworkURL.path!, isDirectory: &isDirectory){
        printErrorAndExit(message: "\(frameworkName) \(isDirectory.boolValue ? "folder already" : "file") exists in \(String(describing:runScriptPathURL.path)) directory, please delete it and try again")
    }
}

func shell(args: String...) -> (output: String, exitCode: Int32) {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.currentDirectoryPath = newFrameworkFolderPath
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    task.waitUntilExit()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: String.Encoding.utf8) ?? ""
    return (output, task.terminationStatus)
}

func prompt(message: String, defaultValue: String) -> String {
    print("\n> \(message) (or press Enter to use \(defaultValue))")
    let line = readLine()
    return line == nil || line == "" ? defaultValue : line!
}

print("\nLet's go over some question to create your framework base project!")

frameworkName = prompt(message: "Framework name", defaultValue: frameworkName)

// Check if folder already exists
let newFrameworkFolderURL = NSURL(fileURLWithPath: frameworkName, relativeTo: runScriptPathURL as URL)
newFrameworkFolderPath = newFrameworkFolderURL.path!
checkThatFrameworkForlderCanBeCreated(frameworkURL: newFrameworkFolderURL)

bundleDomain = prompt(message: "Bundle domain", defaultValue: bundleDomain)
author       = prompt(message: "Author", defaultValue: author)
authorEmail  = prompt(message: "Author Email", defaultValue: authorEmail)
userName     = prompt(message: "Github username", defaultValue: userName)
organizationName = prompt(message: "Organization Name", defaultValue: organizationName)

// Copy template folder to a new folder inside run script url called frameworkName
do {
    try fileManager.copyItem(at: iOSFrameworkTemplateForlderURL as URL, to: newFrameworkFolderURL as URL)
} catch let error as NSError {
    printErrorAndExit(message: error.localizedDescription)
}

// rename files and update content
let enumerator = fileManager.enumerator(at: newFrameworkFolderURL as URL, includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey], options: [], errorHandler: nil)!
var frameworkDirectories = [NSURL]()
print("\nCreating \(frameworkName) ...")
while let fileURL = enumerator.nextObject() as? NSURL {
    guard !ignoredFiles.contains(fileURL.fileName) else { continue }
    if fileURL.isDirectory {
        frameworkDirectories.append(fileURL)
    }
    else {
        fileURL.updateContent()
        fileURL.renameIfNeeded()
    }
}
for fileURL in frameworkDirectories.reversed() {
    fileURL.renameIfNeeded()
}

print(shell(args: "carthage", "update", "--platform", "iOS").output)
print(shell(args: "git", "init").output)
print(shell(args: "git", "add", ".").output)
print(shell(args: "git", "commit", "-m", "'Initial commit'").output)
print(shell(args: "git", "remote", "add", "origin", "git@github.com:\(userName)/\(frameworkName).git").output)
print(shell(args: "open", "\(frameworkName).xcworkspace").output)
