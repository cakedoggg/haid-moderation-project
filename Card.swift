//  Isabella Haid
//  Moderation into CS
//  Spring 2021
//

import Foundation

struct Card: CustomStringConvertible, Hashable {

    enum Suit: String, CaseIterable, CustomStringConvertible {
        case SPADES = "♤", HEARTS = "♡", CLUBS = "♧", DIAMONDS = "♢"
        
        var description: String {
            return self.rawValue
        }
    }
    enum Value: Int, CaseIterable, CustomStringConvertible {
        case TWO = 2, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING, ACE
        
        var description: String{
            return String(self.rawValue)
        }
    }
    
    let thevalue: Value
    let thesuit: Suit
    
    init(thesuit: Suit, thevalue: Value) throws {
        self.thesuit = thesuit
        self.thevalue = thevalue
    }
    
    //tests if the value of the given card is equal to the given value
    func sameVal(a: Card.Value, input: Int) -> Bool{
        if(a.rawValue == input) {
            return true
        }
        return false
    }
    
    //tests if two cards have the same value
    func sameCardVal(a: Card, b: Card) -> Bool{
        return (a.thevalue == b.thevalue)
    }
    
    //compares cards, returns true if the test card is greater than or equal to card b
    func greaterCardVal(test: Card, b: Card) -> Bool {
        if(test.thevalue.rawValue >= b.thevalue.rawValue){
            return true
        }
        return false
    }
    
    //compares card values, returns true if the given value is greater than given test card's value
    func greaterVal(test: Card, input: Int) -> Bool{
        if(test.thevalue.rawValue <= input){ 
            return true
        }
        return false
    }
    
        
    var description: String{
        switch thevalue{
            case .JACK:
                return ("Jack of \(thesuit)")
            case .QUEEN:
                return ("Queen of \(thesuit)")
            case .KING:
                return ("King of \(thesuit)")
            case .ACE:
                return ("Ace of \(thesuit)")
            case .TWO, .THREE, .FOUR, .FIVE, .SIX, .SEVEN, .EIGHT, .NINE, .TEN:
                return ("\(thevalue) of \(thesuit)")
        }
    }
}
