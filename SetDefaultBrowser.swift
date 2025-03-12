#!/usr/bin/swift

import Foundation
import CoreServices

// Function to print usage
func printUsage() {
    print("""
    Usage: ./SetDefaultBrowser.swift [browser]
    
    Supported browsers:
      safari  - Set Safari as default browser
      chrome  - Set Google Chrome as default browser
      firefox - Set Firefox as default browser
      edge    - Set Microsoft Edge as default browser
    """)
    exit(1)
}

// Check if an argument was provided
guard CommandLine.arguments.count > 1 else {
    printUsage()
    exit(1)
}

// Get and normalize the browser argument
let browser = CommandLine.arguments[1].lowercased()

// Define browser bundle IDs
let bundleID: String
let appName: String

switch browser {
case "safari":
    bundleID = "com.apple.Safari"
    appName = "Safari"
case "chrome":
    bundleID = "com.google.Chrome"
    appName = "Google Chrome"
case "firefox":
    bundleID = "org.mozilla.firefox"
    appName = "Firefox"
case "edge":
    bundleID = "com.microsoft.edgemac"
    appName = "Microsoft Edge"
default:
    print("Error: Unsupported browser '\(browser)'")
    printUsage()
    exit(1)
}

// Check if the browser is installed
let fileManager = FileManager.default
let appPath = "/Applications/\(appName).app"
let userAppPath = NSHomeDirectory() + "/Applications/\(appName).app"

guard fileManager.fileExists(atPath: appPath) || fileManager.fileExists(atPath: userAppPath) else {
    print("Error: \(appName) does not appear to be installed on this system.")
    exit(1)
}

print("Setting \(appName) as the default web browser...")

// Set the default handler for HTTP and HTTPS URL schemes
func setDefaultHandler(forURLScheme scheme: String, toBundleID bundleID: String) -> OSStatus {
    return LSSetDefaultHandlerForURLScheme(scheme as CFString, bundleID as CFString)
}

// Set for HTTP and HTTPS
let httpStatus = setDefaultHandler(forURLScheme: "http", toBundleID: bundleID)
let httpsStatus = setDefaultHandler(forURLScheme: "https", toBundleID: bundleID)

// A function to run AppleScript to handle the prompt
func runAppleScriptToHandlePrompt(forApp appName: String) -> Bool {
    let script = """
    try
        tell application "\(appName)"
            -- Just start the launch process
            launch
        end tell
        
        tell application "System Events"
            if UI elements enabled then
                -- Immediately start checking for the prompt
                repeat 40 times
                    if (exists process "CoreServicesUIAgent") then
                        tell process "CoreServicesUIAgent"
                            try
                                if (exists window 1) then
                                    set promptWindow to window 1
                                    set frontmost to true
                                    perform action "AXRaise" of promptWindow
                                    
                                    -- Find and click the "Use" button
                                    repeat with btn in (buttons of promptWindow)
                                        if name of btn contains "Use" then
                                            click btn
                                            return true
                                        end if
                                    end repeat
                                end if
                            end try
                        end tell
                    end if
                    delay 0.1
                end repeat
            else
                return false
            end if
        end tell
    on error errMsg
        return false
    end try
    return false
    """
    
    let scriptObject = NSAppleScript(source: script)
    var errorDict: NSDictionary?
    let output = scriptObject?.executeAndReturnError(&errorDict)
    
    if let error = errorDict {
        print("AppleScript error occurred. This likely means the script needs accessibility permissions.")
        print("Please ensure Terminal (or your current app) has accessibility permissions in:")
        print("System Settings → Privacy & Security → Accessibility")
        print("Technical error details: \(error)")
        return false
    }
    
    return output?.booleanValue ?? false
}

// Try to automatically handle the prompt
if httpStatus == noErr && httpsStatus == noErr {
    print("Successfully set \(appName) as the default browser.")
} else {
    print("Attempting to handle prompt automatically...")
    
    // First, open the browser to trigger the prompt
    let process = Process()
    process.launchPath = "/usr/bin/open"
    process.arguments = ["-a", appName]
    process.launch()
    
    // Try to handle the prompt with AppleScript
    if runAppleScriptToHandlePrompt(forApp: appName) {
        print("Successfully handled prompt and set \(appName) as default browser.")
    } else {
        print("Could not automatically handle the prompt.")
        print("You may need to manually confirm setting \(appName) as the default browser.")
    }
}