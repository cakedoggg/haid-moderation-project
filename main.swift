//  Isabella Haid
//  Moderation into CS
//  Spring 2021
//

import Foundation

//MARK:- Custom Type Tests
//print("Deck Initialization Test------------")
//var d1 = try Deck()
//for c in d1.Deck
//{
//    print(c.description)
//}

//print("Shuffle Test------------------")
//d1.shuffle()
//for c in d1.Deck
//{
//    print(c.description)
//}
//
//print("Stack Test-----------------")
//var stack = Stack()
//print(stack.peek())
//stack.push(try d1.dealCard())
//stack.push(try d1.dealCard())
//stack.push(try d1.dealCard())
//print("STACK:")
//print(stack)
//print("STACK PEEK:")
//print(stack.peek())
//print("STACK POPS:")
//print(stack.pop()!)
//print(stack.pop()!)
//print("STACK:")
//print(stack)

//MARK:- PLAY
print("Initial Deal Test-------------")
var testrun = try Idiot()

if CommandLine.argc < 2 {
    //print("Interactive Mode Test--------------")
    testrun.interactiveMode()
} else {
    print("Static Mode Test--------------")
    testrun.staticMode()
    //print("Play Card Test-------------")
    //print(testrun.mainPile.peek())
}

//print("Collection Test---------------")
//print(testrun.mainPile.peek())
//print("")
