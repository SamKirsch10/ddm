//
//  DDMApp.swift
//  DDM
//
//  Created by Sam Kirsch on 11/8/21.
//

import SwiftUI
import Foundation

@main
struct DDMApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        Settings {
        }
    }
}

@discardableResult
func shell(_ command: String) throws -> String {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.executableURL = URL(fileURLWithPath: "/bin/bash") //<--updated
    
    do {
        try task.run() //<--updated
    }
    catch{ throw error }
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    return output
}

class AppDelegate: NSObject,NSApplicationDelegate {
    
    var statusItem: NSStatusItem?
    var resourcePath: String = ""
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        if let tempPath = Bundle.main.url(forResource: "ddcctl", withExtension: "") {
            resourcePath = tempPath.path
//            print("Found \(resourcePath)")
        }
        
        let menu = NSMenu()
        menu.addItem(
            withTitle: "HDMI",
            action: #selector(AppDelegate.monitorInputHDMI),
            keyEquivalent: ""
        )
        menu.addItem(
            withTitle: "DP",
            action: #selector(AppDelegate.monitorInputDP),
            keyEquivalent: ""
        )
        menu.addItem(
            withTitle: "USB-C",
            action: #selector(AppDelegate.monitorInputUSBC),
            keyEquivalent: ""
        )
        let pipDropdown = NSMenuItem(title: "PIP", action: nil, keyEquivalent: "")
        let pipMenu = NSMenu()
        pipMenu.addItem(
            withTitle: "HDMI",
            action: #selector(AppDelegate.monitorPIPHDMI),
            keyEquivalent: "")
        pipMenu.addItem(
            withTitle: "DP",
            action: #selector(AppDelegate.monitorPIPDP),
            keyEquivalent: "")
        pipMenu.addItem(
            withTitle: "USB-C",
            action: #selector(AppDelegate.monitorPIPUSBC),
            keyEquivalent: "")
        pipMenu.addItem(
            withTitle: "Off",
            action: #selector(AppDelegate.monitorPIPOff),
            keyEquivalent: "")
        menu.setSubmenu(pipMenu, for: pipDropdown)
        menu.addItem(pipDropdown)
        menu.addItem(
            withTitle: "Quit",
            action: #selector(AppDelegate.quit),
            keyEquivalent: ""
        )
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.menu = menu
        statusItem?.button?.image = #imageLiteral(resourceName: "monitor_icon")
    }
    
    @objc func quit(){
        NSApplication.shared.terminate(self)
    }
    
    @objc func monitorInputHDMI() {
        do {
            let out = try shell(resourcePath + " -d 1 -i 17")
            print(out)
        }
        catch {
            print("error? \(error)")
        }
    }
    
    @objc func monitorInputDP() {
        do {
            let out = try shell(resourcePath + " -d 1 -i 15")
            print(out)
        }
        catch {
            print("error? \(error)")
        }
    }
    
    @objc func monitorInputUSBC() {
        do {
            let out = try shell(resourcePath + " -d 1 -i 27")
            print(out)
        }
        catch {
            print("error? \(error)")
        }
    }
    
    @objc func monitorPIPHDMI() {
        do {
            let out = try shell(resourcePath + " -d 1 -pbp 36")
            print(out)
            let out2 = try shell(resourcePath + " -d 1 -pbp-screen 17")
            print(out2)
        }
        catch {
            print("error? \(error)")
        }
    }
    
    @objc func monitorPIPDP() {
        do {
            let out = try shell(resourcePath + " -d 1 -pbp 36")
            print(out)
            let out2 = try shell(resourcePath + " -d 1 -pbp-screen 15")
            print(out2)
        }
        catch {
            print("error? \(error)")
        }
    }
    
    @objc func monitorPIPUSBC() {
        do {
            let out = try shell(resourcePath + " -d 1 -pbp 36")
            print(out)
            let out2 = try shell(resourcePath + " -d 1 -pbp-screen 27")
            print(out2)
        }
        catch {
            print("error? \(error)")
        }
    }
    
    @objc func monitorPIPOff() {
        do {
            let out = try shell(resourcePath + " -d 1 -pbp 0")
            print(out)
        }
        catch {
            print("error? \(error)")
        }
    }

    
}
