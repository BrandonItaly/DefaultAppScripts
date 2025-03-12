#!/usr/bin/swift

import Foundation
import CoreServices

// Function to print usage
func printUsage() {
    print("""
    Usage: ./SetDefaultMailApp.swift [mail-app]
    
    Supported mail applications:
      mail     - Set Apple Mail as default mail application
      outlook  - Set Microsoft Outlook as default mail application
    """)
    exit(1)
}

// Check if an argument was provided
guard CommandLine.arguments.count > 1 else {
    printUsage()
    exit(1)
}

// Get and normalize the mail app argument
let mailApp = CommandLine.arguments[1].lowercased()

// Define mail app bundle IDs
let bundleID: String
let appName: String

switch mailApp {
case "mail":
    bundleID = "com.apple.mail"
    appName = "Mail"
case "outlook":
    bundleID = "com.microsoft.Outlook"
    appName = "Microsoft Outlook"
default:
    print("Error: Unsupported mail application '\(mailApp)'")
    printUsage()
    exit(1)
}

// Check if the mail app is installed
let fileManager = FileManager.default
let systemAppPath = "/System/Applications/\(appName).app"  // Add system applications path
let appPath = "/Applications/\(appName).app"
let userAppPath = NSHomeDirectory() + "/Applications/\(appName).app"

// Check all possible locations for the app
guard fileManager.fileExists(atPath: systemAppPath) || 
      fileManager.fileExists(atPath: appPath) || 
      fileManager.fileExists(atPath: userAppPath) else {
    print("Error: \(appName) does not appear to be installed on this system.")
    exit(1)
}

print("Setting \(appName) as the default mail application...")

// Set the default handler for mail URL schemes and actions
func setDefaultHandler(forURLScheme scheme: String, toBundleID bundleID: String) -> OSStatus {
    return LSSetDefaultHandlerForURLScheme(scheme as CFString, bundleID as CFString)
}

// Set for mailto scheme
let mailtoStatus = setDefaultHandler(forURLScheme: "mailto", toBundleID: bundleID)

// Try to automatically handle the prompt
if mailtoStatus == noErr {
    print("Successfully set \(appName) as the default mail application.")
} else {
    print("Failed to set \(appName) as the default mail application.")
}