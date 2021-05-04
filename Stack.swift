//  Isabella Haid
//  Moderation into CS
//  Spring 2021
//

import Foundation

struct Stack<Card> {
    
    enum StackError: Error{
        case emptyStack(msg: String)
    }
    
    private(set) var pile: [Card] = []
        
    var isEmpty: Bool {
      return pile.isEmpty
    }

    var count: Int {
      return pile.count
    }
    
    mutating func push(_ element: Card) {
            pile.append(element)
        }

    //optional return type so that it can return nil
    mutating func pop() -> Card? {
      return pile.popLast()
    }
    
    mutating func burn(){
        pile.removeAll()
    }
    
    func peek() throws -> Card {
        guard let top = pile.last else { throw StackError.emptyStack(msg: "Empty stack.") }
        return top
    }
}
