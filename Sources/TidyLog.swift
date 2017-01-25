//
// Copyright (c) 2017 by ng <nagendhiran.r@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import TidyJSON

public struct Level : OptionSet {
  public let rawValue : Int

  public init(rawValue: Int) {
      self.rawValue = rawValue
  }

  public static let verbose    = Level(rawValue: 1 << 0)
  public static let info       = Level(rawValue: 1 << 1)
  public static let debug      = Level(rawValue: 1 << 2)
  public static let error      = Level(rawValue: 1 << 3)
  public static let fatal      = Level(rawValue: 1 << 4)

  public static let VERBOSE: Level = [.verbose, .info, .debug, .error, .fatal]
  public static let INFO   : Level = [.info, .debug, .error, .fatal]
  public static let DEBUG  : Level = [.debug, .error, .fatal]
  public static let ERROR  : Level = [.error, .fatal]
  public static let FATAL  : Level = [.fatal]
  public static let NONE   : Level = [] // default
}

private enum Colors: String {
    case Black  = "\u{001B}[0;30m" //None
    case Cyan   = "\u{001B}[0;36m" //Fatal
    case Red    = "\u{001B}[0;31m" //Error
    case Green  = "\u{001B}[0;32m" //Debug
    case Yellow = "\u{001B}[0;33m" //Info
    case White  = "\u{001B}[0;37m" //verbose
}

public class TidyLog {

  private var level : Level = .NONE
  private var rootfile : String = ""
  fileprivate var tagName  : String = "TidyLog"
  fileprivate let _rootfiles : [String] = ["main.swift", "AppDelegate.swift"]

  public static let _self : TidyLog = TidyLog()

  private init() {}

  public static func instance() -> TidyLog {
      return _self
  }

  public func markAsRootFile(_ file: String = #file) {
      if validateRootfile(file) {
        self.rootfile = triggeredFrom(fileName: file)
      }
  }

  public func setLevel(_ _level: Level, file: String = #file) {
      if validateRootfile(file) {
        self.level = _level
      }
  }

  public func setTag(_ _name: String, file: String = #file) {
      if validateRootfile(file) {
        self.tagName = _name
      }
  }

  public static func v(_ message: String..., file: String = #file, function: String = #function, line : Int = #line, terminator: String = "\n") {
      if !_self.level.contains(.verbose) {
            return
      }
      var _formatMessage = Array<String>()
      if message.count > 0 {
          for _message in message {
              _formatMessage.append(_message)
          }
      }
      let _msg = _self.buildMessage(Colors.White.rawValue, timestamp:_self.timestamp(), fileName:_self.triggeredFrom(fileName: file), lineNumber:line, functionName:function, message:_formatMessage.joined(separator: " "), mode:"V")
      _self.log(message: _msg, mode: .verbose)
  }

  public static func i(_ message: String..., file: String = #file, function: String = #function, line : Int = #line, terminator: String = "\n") {
      if !_self.level.contains(.info) {
            return
      }
      var _formatMessage = Array<String>()
      if message.count > 0 {
          for _message in message {
              _formatMessage.append(_message)
          }
      }
      let _msg = _self.buildMessage(Colors.Yellow.rawValue, timestamp:_self.timestamp(), fileName:_self.triggeredFrom(fileName: file), lineNumber:line, functionName:function, message:_formatMessage.joined(separator: " "), mode:"I")
      _self.log(message: _msg, mode: .info)
  }

  public static func d(_ message: String..., file: String = #file, function: String = #function, line : Int = #line, terminator: String = "\n") {
      if !_self.level.contains(.debug) {
            return
      }
      var _formatMessage = Array<String>()
      if message.count > 0 {
          for _message in message {
              _formatMessage.append(_message)
          }
      }
      let _msg = _self.buildMessage(Colors.Green.rawValue, timestamp:_self.timestamp(), fileName:_self.triggeredFrom(fileName: file), lineNumber:line, functionName:function, message:_formatMessage.joined(separator: " "), mode:"D")
      _self.log(message: _msg, mode: .debug)
  }

  public static func e(_ message: String..., file: String = #file, function: String = #function, line : Int = #line, terminator: String = "\n") {
      if !_self.level.contains(.error) {
            return
      }
      var _formatMessage = Array<String>()
      if message.count > 0 {
          for _message in message {
              _formatMessage.append(_message)
          }
      }
      let _msg = _self.buildMessage(Colors.Red.rawValue, timestamp:_self.timestamp(), fileName:_self.triggeredFrom(fileName: file), lineNumber:line, functionName:function, message:_formatMessage.joined(separator: " "), mode:"E")
      _self.log(message: _msg, mode: .error)
  }

  public static func f(_ message: String..., file: String = #file, function: String = #function, line : Int = #line, terminator: String = "\n") {
      if !_self.level.contains(.fatal) {
            return
      }
      var _formatMessage = Array<String>()
      if message.count > 0 {
          for _message in message {
              _formatMessage.append(_message)
          }
      }
      let _msg = _self.buildMessage(Colors.Cyan.rawValue, timestamp:_self.timestamp(), fileName:_self.triggeredFrom(fileName: file), lineNumber:line, functionName:function, message:_formatMessage.joined(separator: " "), mode:"F")
      _self.log(message: _msg, mode: .fatal)
  }

  //Use for simple json handling
  public static func json(_ message: String, file: String = #file, function: String = #function, line : Int = #line, terminator: String = "\n") {
    //TODO
    if !_self.level.contains(.debug) {
          return
    }
    if message.characters.count > 0 {
        let json = try! JSON.parse(string: message)
        let messages = json.prettify()
        for _message in messages {
          let _msg = _self.buildMessage(Colors.Green.rawValue, timestamp:_self.timestamp(), fileName:_self.triggeredFrom(fileName: file), lineNumber:line, functionName:function, message:_message, mode:"JSON")
          _self.log(message: _msg, mode: .debug)
        }
    }
  }

  public static func xml() {
    //TODO
  }

}

//Mark:- fileprivate alone
extension TidyLog {
  fileprivate func validateRootfile(_ file: String = #file, function: String = #function, line : Int = #line, terminator: String = "\n") -> Bool {
      let _fromFile = triggeredFrom(fileName: file)
      if _rootfiles.contains(_fromFile) == false {
          let _msg = buildMessage(Colors.Red.rawValue, timestamp:timestamp(), fileName:_fromFile, lineNumber:line, functionName:function, message:"Please set log level only from main.swift or AppDelegate.swift", mode:"E")
          log(message: _msg, mode: .error)
          return false
      }
      if _fromFile.characters.count == 0 {
        let _msg = buildMessage(Colors.Red.rawValue, timestamp:timestamp(), fileName:_fromFile, lineNumber:line, functionName:function, message:"Unable to set log level. Please set root file", mode:"E")
        log(message: _msg, mode: .error)
        return false
      }
      return true
  }

  fileprivate func log(message: Any, mode: Level = .NONE, terminator: String = "\n") {
      Swift.print(message, separator: " ", terminator: terminator)
  }

  fileprivate func log(message: Array<String>, mode: Level = .NONE, terminator: String = "\n") {
      Swift.print(message.joined(separator: " "), separator: "", terminator: terminator)
  }

  fileprivate func timestamp() -> String {
      let date = Date()
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
      return formatter.string(from: date)
  }

  fileprivate func triggeredFrom(fileName : String = #file) -> String {
      if let filename = fileName.components(separatedBy: "/").last {
        return filename
      }
      return fileName
  }

  fileprivate func buildMessage(_ color: String, timestamp: String, fileName: String, lineNumber: Int, functionName: String, message: String..., mode: String) -> Array<String> {
      // https://bugs.swift.org/browse/SR-957
      //return String(format:"%@%@ %@ [%@:%i/%@] %@", color, timestamp, "TidyLog", fileName, lineNumber, functionName, message)
      //return "\(color)\(timestamp) TidyLog [\(fileName):\(lineNumber)/\(functionName)] I> \(message)"
      var formatArray = Array<String>()
      formatArray.append(color+timestamp)
      formatArray.append(tagName)
      formatArray.append("[\(fileName):\(lineNumber)/\(functionName)]")
      formatArray.append("\(mode)>")
      for _message in message {
        formatArray.append(_message)
      }
      return formatArray
  }
}
