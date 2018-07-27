//
//  Shell.swift
//  Installer
//
//  Created by Mikhail Lutskiy on 23.07.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation

@discardableResult
func shell(_ args: String...) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}

func shell(launchPath: String, arguments: [String]) -> String?
{
    let task = Process()
    task.launchPath = launchPath
    task.arguments = arguments
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: String.Encoding.utf8)
    
    return output
}

func doTask(_ password:String) {
    let taskOne = Process()
    taskOne.launchPath = "/bin/echo"
    taskOne.arguments = [password]
    print(taskOne.arguments)
    
    let taskTwo = Process()
    taskTwo.launchPath = "/usr/bin/sudo"
    taskTwo.arguments = ["-S", "/bin/mkdir", "/Applications/array.app"]
    //taskTwo.arguments = ["-S", "/usr/bin/touch", "/tmp/foo.bar.baz"]
    
    let pipeBetween:Pipe = Pipe()
    taskOne.standardOutput = pipeBetween
    taskTwo.standardInput = pipeBetween
    
    let pipeToMe = Pipe()
    taskTwo.standardOutput = pipeToMe
    taskTwo.standardError = pipeToMe
    
    taskOne.launch()
    taskTwo.launch()
    
    let data = pipeToMe.fileHandleForReading.readDataToEndOfFile()
    let output : String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
    print(output)
}
