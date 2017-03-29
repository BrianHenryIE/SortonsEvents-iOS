//
//  main.swift
//  SortonsEvents
//
//  https://github.com/mokacoding/TestAppDelegateExample
//

import UIKit

private func delegateClassName() -> String? {
    return NSClassFromString("XCTestCase") == nil ? NSStringFromClass(AppDelegate.self) : nil
}

UIApplicationMain(CommandLine.argc,
                  UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(to: UnsafeMutablePointer<Int8>.self,
                                                                       capacity: Int(CommandLine.argc)),
                  nil,
                  delegateClassName())
