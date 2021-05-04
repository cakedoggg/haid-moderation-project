//  Isabella Haid
//  Moderation into CS
//  Spring 2021
//

import Foundation

struct Hand{

    //portions of the hand
    var hand = Set<Card>()
    var faceDown = Set<Card>()
    var faceUp = Set<Card>()
    //tracks whether or not the user can play the faceUp cards
    var faceUpAccessible = false
    
    init(deck: Deck) {
        for _ in 0...2{
            try! hand.insert(deck.dealCard())
            try! faceDown.insert(deck.dealCard())
            try! faceUp.insert(deck.dealCard())
        }
    }
    
//MARK:- SET/GET
    mutating func add(c: Card){
        hand.insert(c)
    }
    
    mutating func removE(c: Card, portion: String){
        if portion == "MH" {
            hand.remove(c)
        }
        else if portion == "FU" {
            faceUp.remove(c)
        }
        else {
            faceDown.remove(c)
        }
    }
    
    func findCard(value: Int, set: Set<Card>) -> Card? {
        for c in set{
            if c.sameVal(a: c.thevalue, input: value){
                return c
            }
        }
        return nil
    }
    
    //checks if each portion of the hand has been emptied --> if true, the game is won!
    func gutted() -> Bool{
        return ((hand.isEmpty) && (faceUp.isEmpty) && (faceDown.isEmpty))
    }
    
    
    //face up cards can only be played if the main hand is empty
    mutating func faceUpPlayable() -> Bool{
        return hand.isEmpty
    }
    
    //face down cards can only be played if both the main hand and faceUp hand are both emptied
    func faceDownPlayable() -> Bool{
        if((hand.isEmpty) && (faceUp.isEmpty)){
            return true
        }
        else { return false }
    }
    
    //grabs card from appropriate portion and sends back -- returns nil if move is not legal
    mutating func legalMove(val: Int) -> Card? {
        let c: Card
        //hand is playable, face up and face down are both unplayable
        if((faceDownPlayable() == false) && (faceUpPlayable() == false)){
            c = findCard(value: val, set: hand)!
            hand.remove(c)
            return c
        }
        //hand is empty, face up is playable, face down is not playable
        else if ((faceDownPlayable() == false) && faceUpPlayable()){
            if(hand.isEmpty){
                c = findCard(value: val, set: faceUp)!
                faceUp.remove(c)
                return c
            }
            else{
                c = findCard(value: val, set: hand)!
                hand.remove(c)
                return c
            }
        }
        else if(faceDownPlayable() && faceUpPlayable()){
            c = findCard(value: val, set: faceDown)!
            faceDown.remove(c)
            return c
        }
        return nil
    }
    
    //returns new set of any 6, 7, 8, 9, 10, J, K, Q, A cards in appropriate hand AND
        //msg designating which portion the card comes from
    //uses .filter from Set as closure to return filtered subset
    mutating func getHiCards(h: Hand, top: Card) -> (hiSet: Set<Card>?, msg: String){
        let hiSet: Set<Card>
        let topVal = top.thevalue.rawValue
        //hand is playable, face up and face down are both unplayable
        if((faceDownPlayable() == false) && (faceUpPlayable() == false)){
            //fun little closure to get a subset of all 6, 7, 8, 9, 10, J, K, Q, A cards in the main hand
            hiSet = h.hand.filter { $0.thevalue.rawValue > topVal }
            return (hiSet, "MH")
        }
        //hand is empty, face up is playable, face down is not playable
        else if ((faceDownPlayable() == false) && faceUpPlayable()){
            if(hand.isEmpty){
                //fun little closure to get a subset of all 2, 3, 4, 5 cards in faceUp
                hiSet = h.faceUp.filter { $0.thevalue.rawValue > topVal }
                return (hiSet, "FU")
            }
            else { //grab from hand if it is not empty
                hiSet = h.hand.filter { $0.thevalue.rawValue > topVal }
                return (hiSet, "MH")
            }
        }
        //face down is playable
        else if(faceDownPlayable() && faceUpPlayable()){
            hiSet = h.faceDown.filter { $0.thevalue.rawValue > topVal }
            return (hiSet, "FD")
        }
        return (nil, "nil")
    }
    
    //returns new set of any 2,3,4,5 cards in appropriate hand AND msg designating which portion the card comes from
    //uses .filter from Set as a fun little closure that returns a filtered subset
    mutating func getMinCards(h: Hand) -> (minSet: Set<Card>?, msg: String){
        let minSet: Set<Card>
        //hand is playable, face up and face down are both unplayable
        if((faceDownPlayable() == false) && (faceUpPlayable() == false)){
            //fun little closure to get a subset of all 2, 3, 4, 5 cards in the main hand
            minSet = h.hand.filter { $0.thevalue.rawValue <= 5 }
            return (minSet, "MH")
        }
        //hand is empty, face up is playable, face down is not playable
        else if ((faceDownPlayable() == false) && faceUpPlayable()){
            if(hand.isEmpty){
                //fun little closure to get a subset of all 2, 3, 4, 5 cards in faceUp
                minSet = h.faceUp.filter { $0.thevalue.rawValue <= 5 }
                return (minSet, "FU")
            }
            else { //grab from hand if it is not empty
                minSet = h.hand.filter { $0.thevalue.rawValue <= 5 }
                return (minSet, "MH")
            }
        }
        //face down is playable
        else if(faceDownPlayable() && faceUpPlayable()){
            minSet = h.faceDown.filter { $0.thevalue.rawValue <= 5 }
            return (minSet, "FD")
        }
        return (nil, "nil")
    }
    
    //returns lowest card in Hand AND msg designating which portion the card comes from
    mutating func getMinCardHand(h: Hand) -> (low: Card?, msg:String) {
        let low: Card
        //hand is playable, face up and face down are both unplayable
        if((faceDownPlayable() == false) && (faceUpPlayable() == false)){
            low = hand.min(by: { (a, b) in a.thevalue.rawValue < b.thevalue.rawValue})!
            return (low, "MH")
        }
        //hand is empty, face up is playable, face down is not playable
        else if ((faceDownPlayable() == false) && faceUpPlayable()){
            if(hand.isEmpty){
                low = faceUp.min(by: { (a, b) in a.thevalue.rawValue < b.thevalue.rawValue})!
                return (low, "FU")
            }
            else { //grab from hand if it is not empty
                low = hand.min(by: { (a, b) in a.thevalue.rawValue < b.thevalue.rawValue})!
                return (low, "MH")
            }
        }
        //face down is playable
        else if(faceDownPlayable() && faceUpPlayable()){
            low = faceDown.min(by: { (a, b) in a.thevalue.rawValue < b.thevalue.rawValue})!
            return (low, "FD")
        }
        return (nil, "nil")
    }
        
    //returns lowest card in given set
    mutating func getMinCardSet(set: Set<Card>) -> Card {
        var low: Card
        let fallback = try! Card.init(thesuit: .SPADES, thevalue: .TWO)
        
        if(set.count == 1){
            low = set.randomElement()! //easy workaround to get the only item in set
        }
        else{
            //use .min from Set to get the lowest Card value in set
            low = set.min { a, b in a.thevalue.rawValue < b.thevalue.rawValue } ?? fallback
        }
        return low
    }
    
    
//MARK:- DISPLAYS
    func displayHand(){
        for c in hand{
            print("[ \(c) ] ", terminator: "")
        }
    }
    
    func displayFaceUp(){
        for c in faceUp{
            print("[ \(c) ] ", terminator: "")
        }
    }

    func displayFaceDown(){
        for _ in faceDown{
            print(" 🂠 ", terminator: "")
        }
    }
    
    
}
