//  Isabella Haid
//  Moderation into CS
//  Spring 2021
//

class Deck: CustomStringConvertible {
    enum DeckError: Error {
        case NoSuchElementException(msg: String)
        //case InitializeFailed(Error: String)
    }
    
    var description: String{
        var count = 0
        var msg = ("Deck: ")

        for c in Deck{
            msg += (c.description)
            count += 1
        }
        return msg
    }
    
    private(set) var Deck: [Card] = []
    var numDealt: Int
    
    init() throws {
        self.numDealt = 0
        
        for suit in Card.Suit.allCases{
            for value in Card.Value.allCases{
                try self.Deck.append(Card(thesuit: suit, thevalue: value))
            }
        }
    }
    

    func reset(){
        numDealt = 0
        shuffle()
    }
    
    //returns true if it is empty, false if it is not empty
    func empty() -> Bool{
        return Deck.isEmpty
    }
    
    func inDeck(card: Card) -> Bool{
        var count = 0;
        let stop = 52 - numDealt;
        
        for c in Deck.reversed(){
            if((equalTo(A: card, B: c)) && count <= stop){
                return true
            }
            count += 1
        }
        return false
    }
    
    func equalTo (A: Card, B: Card) -> Bool{
        if (A.thesuit == B.thesuit) && (A.thevalue == B.thevalue){
            return true
        }
        return false
    }
    
    func dealCard() throws -> Card  {
        guard numDealt < Deck.count-1 else{
            throw DeckError.NoSuchElementException(msg: "Cannot deal card because there are no more cards in the deck.")
        }
        numDealt += 1
        return self.Deck[numDealt]
    }
    
    func shuffle(){
        var temp: Card
        var i = 0
        var rand: Int
        
        for _ in Deck.reversed(){
            rand = Int.random(in: 0...51)
            temp = Deck[i]
            Deck[i] = Deck[rand]
            Deck[rand] = temp
            i += 1
        }
    }
}
