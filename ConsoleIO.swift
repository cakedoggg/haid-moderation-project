//  Isabella Haid
//  Moderation into CS
//  Spring 2021
//

import Foundation

enum outputType {
    case standard
    case error
}

class ConsoleIO {
    //static mode is used for testing, interactive mode is used for playing
    
    func writeMessage(_ message: String, to: outputType = .standard) {
      switch to {
          case .standard:
            print("\(message)")
          case .error:
            fputs("Error: \(message)\n", stderr) //points to standard error stream
          }
    }
    
    //for static mode
    func printUsage() {
        //first arg is the path to the executable
        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
                
        writeMessage("Usage:")
        writeMessage("PLAY: \(executableName) -p number")
        writeMessage("or")
        writeMessage("DRAW: \(executableName) -d")
        writeMessage("or")
        writeMessage("COLLECT: \(executableName) -c")
        writeMessage("or")
        writeMessage("\(executableName) -h to show usage information \n")
        writeMessage("INTERACTIVE MODE: \(executableName) without an option\n")
    }
    
    func printHelp(){
        writeMessage("Type d to draw, p to play, c to collect, h for usage, and q to quit")
    }
    
    func getInput() -> String {
        let keyboard = FileHandle.standardInput
        let inputData = keyboard.availableData
        let strData = String(data: inputData, encoding: String.Encoding.utf8)!
        return strData.trimmingCharacters(in: CharacterSet.newlines)
    }


}
