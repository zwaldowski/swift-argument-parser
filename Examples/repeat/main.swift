//===----------------------------------------------------------*- swift -*-===//
//
// This source file is part of the Swift Argument Parser open source project
//
// Copyright (c) 2020 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

import ArgumentParser

struct Repeat: ParsableCommand {
    @Option(help: "The number of times to repeat 'phrase'.")
    var count: Int?

    @Flag(help: "Include a counter with each repetition.")
    var includeCounter = false

    @Argument(help: "The phrase to repeat.")
    var phrase: String

    mutating func run() throws {
        let repeatCount = count ?? .max

        for i in 1...repeatCount {
            if includeCounter {
                print("\(i): \(phrase)")
            } else {
                print(phrase)
            }
        }
    }
}

struct CommandWrapper<Command: ParsableCommand>: ParsableCommand {
  var command: Command = Command()

  static var configuration: CommandConfiguration {
    Command.configuration
  }
  
  static var _commandName: String {
    Command._commandName
  }
  
  mutating func validate() throws {
    try command.validate()
  }
  
  mutating func run() throws {
    try command.run()
  }
}

extension CommandWrapper: CustomReflectable {
  var customMirror: Mirror {
    Mirror(reflecting: command)
  }
}


CommandWrapper<CommandWrapper<Repeat>>.main()
