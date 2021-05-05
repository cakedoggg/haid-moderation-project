//  Isabella Haid
//  Moderation into CS
//  Spring 2021
//

import Foundation
import ArgumentParser

enum moveType: String {
    case plays = "p"
    case collects = "c"
    case draws = "d"
    case help = "h"
    case quit = "q"
    case unknown
  
    init(value: String) {
        switch value {
            case "p": self = .plays
            case "d": self = .draws
            case "c": self = .collects
            case "h": self = .help
            case "q": self = .quit
            default: self = .unknown
        }
    }
}


public class Idiot{
    
    let consoleIO = ConsoleIO()
    
    enum idiotError:Error{
        case failedInitializationError(msg: String)
        case drawError(msg: String)
    }
    //create dealer and player hands
    private var dealerHand: Hand
    var playerHand: Hand

    var gameBoard: String
    var gameDeck: Deck
    
    var mainPile = Stack<Card>()
    
    //keeps interactive mode running
    var gameOver: Bool
    var whoWins: Int //0 is the dealer, 1 is the player, 2 keeps the interactive mode running
    
    //manages Dealer's moves
    var moveManager: Int
    //manage Player's moves
    var chill: Bool
    
    init() throws {
        gameOver = false
        moveManager = 0
        whoWins = 2
        chill = false
        
        gameDeck = try Deck()
        gameDeck.shuffle()
        
        gameBoard = "               Let's play Idiot!                  Who are you calling an idiot?\n"
        
        gameBoard += """
                ________________                                      ______________
               /                \\                                    / /            \\-___
              / /         \\ \\    \\                                  |     -    -         \\
              |                   |                                 | /         -   \\  _  |
             /                   /                                  \\    /  /   //    __   \\
            |      ___\\ \\| | / /                                     \\/ // // / ///  /      \\
            |      /        \\                                        |             //\\ __   |
            |      |           \\                                      \\              ///     \\
           /       |      _    |                                       \\               //  \\ |
           |       |       \\   |                                        \\   /--          //  |
           |       |       _\\ /|                                         / (o-            / \\|
           |      __\\     <_o)\\o-                                       /            __   /\\ |
           |     |             \\                                       /               )  /  |
            \\    ||             \\                                     /   __          |/ / \\ |
             |   |__          _  \\                                   (____ *)         -  |   |
             |   |           (*___)                                      /               |   |
             |   |       _     |                                         (____            |  |
             |   |    //_______/                                           ####\\           | |
             |  /       | UUUUU__                                          ____/ )         |_/
             \\|         \\_nnnnnn_\\-\\                                       (___             /
               |       ____________/                                         \\____         |
               |      /                                                        \\           |
               |_____/                                                          \\___________\\


        """
        
        //fills both hands with 9 cards each to start
        dealerHand = Hand(deck: gameDeck)
        playerHand = Hand(deck: gameDeck)
        //start off main pile with card drawn from the deck
        mainPile.push(try! gameDeck.dealCard())
    }
    
    //Static mode is for testing the player's hand, not playing with the dealer
    func staticMode() {
        let argCount = CommandLine.argc
        let argument = CommandLine.arguments[1]
        //cut off the - from the command line arg
        let start = argument.index(argument.startIndex, offsetBy: 1)
        let (move, value) = getMove(String(argument[start...]))
        
        //debug
        consoleIO.writeMessage("Argument Count: \(argCount) Move: \(move) Value: \(value)")
        
        switch move{
            case .draws:
                if (gameDeck.empty()){
                    consoleIO.writeMessage("Cannot draw from the deck because it is empty.", to: .error)
                    consoleIO.printUsage()
                }
                else{
                    consoleIO.writeMessage("Drawing card from deck...")
                    _ = drawCard(who: 1)
                    //playerHand.displayHand()
                }
            case .plays:
                if argCount != 3{
                    consoleIO.writeMessage("Cannot play card.")
                    consoleIO.printUsage()
                }
                else{
                    let cv = CommandLine.arguments[2]
                    let val = Int(cv as String) ?? 0
                    mainPile.push(playerHand.legalMove(val: val)!)
                }
                consoleIO.writeMessage("Playing the damn card...")
            case .collects:
                if(mainPile.isEmpty){
                    consoleIO.writeMessage("Cannot collect from the pile because it is empty.", to: .error)
                    consoleIO.printUsage()
                }
                else {
                    consoleIO.writeMessage("Collecting cards from pile...")
                    collect(who: 1)
                    //TESTING
//                    mainPile.push(try! gameDeck.dealCard())
//                    consoleIO.writeMessage("added card 1 to pile")
//                    print(mainPile.peek())
//                    mainPile.push(try! gameDeck.dealCard())
//                    consoleIO.writeMessage("added card 2 to pile")
//                    print(mainPile.peek())
//                    collect(who: 1)
//                    playerHand.displayHand()
//                    print("\n")
                }
            case .help:
                consoleIO.printUsage()
            case .unknown, .quit:
                consoleIO.writeMessage("Unknown move: \(value)")
                consoleIO.printUsage()
        }
        
    }
    
    //play against the dealer!
    func interactiveMode() {
        consoleIO.writeMessage(gameBoard)
        displayBoard()
        consoleIO.printHelp()
        
        while (!gameOver && (whoWins == 2)) {
            //get move from user
            consoleIO.writeMessage("Make your move:")
            let (move, value) = getMove(consoleIO.getInput())
             
            switch move{
                case .draws:
                    if (gameDeck.empty()){
                        consoleIO.writeMessage("Cannot draw from the deck because it is empty.", to: .error)
                        consoleIO.printHelp()
                    }
                    else{
                        consoleIO.writeMessage("Drawing card from deck...\n")
                        //draw card, add it to player hand, and compare it to top card
                        let drawn = drawCard(who: 1)
                        let gtr = compareTop(c: drawn)
                        if(gtr == 0){ //drawn card is greater so the user plays it
                            mainPile.push(drawn)
                            playerHand.removE(c: drawn, portion: "MH") //removes drawn card from palyer hand
                        }
                        else if(gtr == 1){ //top card is greater so the user collects the pile
                            consoleIO.writeMessage("Collecting cards from pile...")
                            collect(who: 1)
                        }
                        
                        //DEALER MOVES IN RESPONSE
                        checkMoveManager()
                        dealerMove()
                        //DISPLAY CHANGES
                        displayBoard()
                    }
                case .plays:
                    consoleIO.writeMessage("Pick card to play:")
                    let p = consoleIO.getInput()
                    let top = try! mainPile.peek()
                    var val: Int //played card's value
                    
                    //MARK:- Set value for comparison according to player input
                    val = setVal(input: p) //also handles when Ace is played
                    
                    //MARK:- Player Hand Changes Depending on Played Value
                    //if the played card is 2 then ignore top of pile, it is the reset card
                    if(val == 2){
                        mainPile.push(playerHand.legalMove(val: val)!)
                        consoleIO.writeMessage("Playing the damn card...\n")

                        //DEALER MOVES IN RESPONSE
                        checkMoveManager()
                        dealerMove()
                    }
                    //if the played card is 10 then ignore top of pile, it is the burn card
                    else if (val == 10){
                        //rest of the pile is burned and a new card is needed to restart pile
                        mainPile.burn()
                        //finds card in hand and removes it
                        _ = playerHand.legalMove(val: 10)
                        
                        //ask for player to provide new card since old card was burned
                        consoleIO.writeMessage("Pick card to start new pile: ")
                        let p2 = consoleIO.getInput()
                        let val2 = setVal(input: p2)
                        mainPile.push(playerHand.legalMove(val: val2)!)

                        //Dealer responds
                        checkMoveManager() //set moveManager to 0
                        dealerMove()
                    }
                    //if the top of the pile is 5 then the played card must be less than or equal to 5
                    else if((val <= 5) && (top.sameVal(a: top.thevalue, input: 5))){
                        mainPile.push(playerHand.legalMove(val: val)!)
                        consoleIO.writeMessage("Playing the damn card...\n")

                        //DEALER MOVES IN RESPONSE
                        checkMoveManager()
                        dealerMove()
                     }
                    //if the top of the pile is 3, 4, 6, 8, 9, J, Q, K then
                    //make sure that the input's value is greater than or equal to the top of the pile
                    //however, if the top of pile is 2 OR the pile is empty then any card can be played
                    else if(((top.greaterVal(test: top, input: val)) || (top.sameVal(a: top.thevalue, input: 2)) || (mainPile.isEmpty)) && chill == false){
                        //legal move finds card in hand, removes it, then sends it here to be pushed onto the pile
                        mainPile.push(playerHand.legalMove(val: val)!)
                        consoleIO.writeMessage("Playing the damn card...\n")
                        
                        //DEALER MOVES IN RESPONSE
                        checkMoveManager()
                        dealerMove()
                    }
                    else if((chill == false) && !(top.greaterVal(test: top, input: val))){
                        consoleIO.writeMessage("Selected card cannot be played \n", to: .error) }
                                        
                    //DISPLAY CHANGES
                    displayBoard()
                case .collects:
                    if(mainPile.isEmpty){
                        consoleIO.writeMessage("Cannot collect from the pile because it is empty.", to: .error)
                        consoleIO.printHelp()
                    }
                    else {
                        consoleIO.writeMessage("Collecting cards from pile...\n")
                        collect(who: 1)
                        
                        //DEALER MOVES IN RESPONSE
                        checkMoveManager()
                        dealerMove()
                        //DISPLAY CHANGES
                        displayBoard()
                    }
                case .help:
                    consoleIO.printHelp()
                case .quit:
                    gameOver = true
                default:
                    consoleIO.writeMessage("Unknown move: \(value)")
                    consoleIO.printHelp()
            }
            
            //once deck runs out, start checking for empty faceDown
            if(gameDeck.empty()){
                if playerHand.gutted(){
                    whoWins = 1
                    consoleIO.writeMessage("You win!")
                    gameOver = true
                }
                else if dealerHand.gutted(){
                    whoWins = 0
                    consoleIO.writeMessage("Dealer wins!")
                    gameOver = true
                }
            }
            
            //restart chill for next loop
            chill = false

          } //end of while loop
        } //interactive ends

    
//MARK:- MOVES
    //TODO
    //dealer plays card or collects
    func dealerMove(){
        var minSet: Set<Card> //subset of low cards in dealer's hand
        var hiSet: Set<Card> //subset of high cards in dealer's hand
        var msg: String //which portion of the hand to remove the card from
        var low: Card //lowest card in dealer's hand
        let top = try! mainPile.peek()
        
        switch moveManager{
            //top of pile is 5, so look for cards 3, 4, 5 -> play the lowest one available OR collect
            case -1:
                //get subset of any 2, 3, 4, 5 cards in the dealer's hand
                minSet = dealerHand.getMinCards(h: dealerHand).minSet!
                //get portion of  hand that subset comes from
                msg = dealerHand.getMinCards(h: dealerHand).msg
                
                //if minSet is empty and the msg is nil, then dealer collects because it cannot play a card <= 5
                if((minSet.isEmpty) && (msg == "nil")){
                    if(mainPile.isEmpty){
                        consoleIO.writeMessage("Cannot collect from the pile because it is empty.", to: .error)
                        consoleIO.printUsage()
                    }
                    else{
                        consoleIO.writeMessage("Dealer is collecting cards...")
                        collect(who: 0)
                    }
                }
                //otherwise play lowest card in minset
                else {
                    //get lowest card in minSet
                    low = dealerHand.getMinCardSet(set: minSet)
                    
                    consoleIO.writeMessage("Dealer is playing card...")
                    mainPile.push(low)
                    dealerHand.removE(c: low, portion: msg)
                }
            //top of the pile is 2 or 10, so look to play lowest card in dealer's hand
            case 0:
                consoleIO.writeMessage("Dealer is playing card...")
                //getMinCardHand gets lowest card from appropriate hand
                low = dealerHand.getMinCardHand(h: dealerHand).low!
                msg = dealerHand.getMinCardHand(h: dealerHand).msg
                mainPile.push(low)
                dealerHand.removE(c: low, portion: msg)
            //top of the pile is 3, 4, 6, 7, 8, 9, 10, J, Q, K, so look for cards higher than the top of pile
            case 1:
                //send dealerhand and top of pile, get subset of cards that are higher than top of pile
                hiSet = dealerHand.getHiCards(h: dealerHand, top: top).hiSet!
                //get portion of  hand that subset comes from
                msg = dealerHand.getHiCards(h: dealerHand, top: top).msg
                
                //if hiSet is empty and the msg is nil, then dealer collects because it cannot play a card > top of pile
                if((hiSet.isEmpty) || (msg == "nil")){
                    consoleIO.writeMessage("Dealer is collecting cards...")
                    collect(who: 0)
                }
                //otherwise play lowest card in hiSet
                else{
                    //get lowest card in hiSet
                    low = dealerHand.getMinCardSet(set: hiSet)
                    consoleIO.writeMessage("Dealer is playing card...")
                    
                    if(low.thevalue.rawValue == 10){
                        //rest of the pile is burned and a new card is needed to restart pile
                        mainPile.burn()
                        //finds card in hand and removes it
                        dealerHand.removE(c: low, portion: msg)
                        
                        //new card is needed to start pile, so the dealer just plays the next lowest card in hand
                        low = dealerHand.getMinCardHand(h: dealerHand).low!
                        msg = dealerHand.getMinCardHand(h: dealerHand).msg
                    }
                    //push low card to pile and remove it from appropriate hand
                    mainPile.push(low)
                    dealerHand.removE(c: low, portion: msg)
                }
            //dealer collects pile
            case 2:
                consoleIO.writeMessage("Dealer is collecting cards...")
                collect(who: 0)
            default: 
                consoleIO.writeMessage("Please check move manager.", to: .error)
        }
        
        //after dealer moves make sure both player and dealer have at least 3 cards in their hand, as long as the deck lasts
        if !(gameDeck.empty()){
            refill(who: 0)
            refill(who: 1)
        }
    }
    
    //checks the top of the pile and changes moveManager for assisting the dealer's move
    func checkMoveManager(){
        let top: Card
        //if the pile is empty, then a default 2 of Spades card is set as the top
        if(mainPile.isEmpty){
            top = try! Card.init(thesuit: .SPADES, thevalue: .TWO)
        }
        else{ top = try! mainPile.peek() }
        
        switch top.thevalue {
            case .ACE:
                moveManager = 2 //dealer collects the pile
            case .FIVE:
                moveManager = -1 //look for card in dealer's hand that is less than or equal to 5
            case .TEN, .TWO:
                moveManager = 0 //look for lowest card in dealer's hand
            case .THREE, .FOUR, .SIX, .SEVEN, .EIGHT, .NINE, .JACK, .QUEEN, .KING:
                moveManager = 1 //look for card higher than top value
        }
        
    }

    func getMove(_ move: String) -> (move: moveType, value: String) {
        return (moveType(value: move), move)
    }
        
    func drawCard(who: Int) -> Card {
        precondition(!(gameDeck.empty()))
        let c = try! gameDeck.dealCard()
        if(who == 1){ //player
            playerHand.add(c: c)
        }
        else if (who == 0){ //dealer
            dealerHand.add(c: c)
        }
        return c
    }
        
    func collect(who: Int){
        //move cards from the main pile into the right hand
        for _ in mainPile.pile{
            if (who == 1){ //player
                playerHand.add(c: mainPile.pop()!)
            }
            else if (who == 0) { //dealer
                dealerHand.add(c: mainPile.pop()!)
            }
        }
        //remove all cards from the pile in case the pop doesnt....pop
        mainPile.burn()
        //add card from deck to start new pile
        mainPile.push(try! gameDeck.dealCard())
    }

//MARK:- HELPERS
    //compares top of the pile to another card
    //returns 0 if the drawn card is greater, 1 if the top card is greater
    func compareTop(c: Card) -> Int{
        let top: Card
        top = try! mainPile.peek()
        if(c.greaterCardVal(test: c, b: top)){
            return 0 //if the drawn card is greater than or equal to the top of the pile then the user plays the card
        }
        return 1 //if the top of the pile is greater than the drawn card then the user collects
    }
    
    func refill(who: Int){
        if(who == 1){ //refill player hand
            while(playerHand.hand.count < 3){
                playerHand.add(c: try! gameDeck.dealCard())
            }
        }
        else if(who == 0) { //refill dealer hand
            while(dealerHand.hand.count < 3){
                dealerHand.add(c: try! gameDeck.dealCard())
            }
        }
    }
    
    func setVal(input: String) -> Int{
        let val: Int
        
        switch input{
            case "jack":
                val = Card.Value.JACK.rawValue
            case "king":
                val = Card.Value.KING.rawValue
            case "queen":
                val = Card.Value.QUEEN.rawValue
            case "ace":
                val = Card.Value.ACE.rawValue
                consoleIO.writeMessage("Ace!")
                //push ace onto pile
                mainPile.push(playerHand.legalMove(val: val)!)
                
                //make sure that the player does not move again later in loop
                chill = true
                //moveManager = 2 -> dealer collects -> pile is cleared -> card drawn from deck now on top of pile
                checkMoveManager()
                dealerMove()
                
            default: //cards 2, 3, 4, 5 6, 7, 8, 9, 10
                val = Int(input as String) ?? 0
                //print(val)
        }
        
        return val
    }
    
//MARK:- DISPLAYS
    
    func displayBoard(){
        displayDealer()
        displayPile()
        displayPlayer()
    }
    
    func displayPile(){
        //only show top card of pile
        print("----CARD PILE: ", terminator: "")
        print(try! mainPile.peek())
    }
    
    func displayDealer(){
        print("|-------DEALER---------------------| \n \t Main Hand:")
        //only the faceup deck is displayed by dealer
        for _ in dealerHand.hand{
            print(" 🂠 ", terminator: "")
        }
        print("\n")
        print("""
            Special Hands:
        Face Down:
        """, terminator: "")
        dealerHand.displayFaceDown()
        print("\n")
        print("Face Up: ", terminator: "")
        dealerHand.displayFaceUp()
        print("\n")
        print("----------------------------------")
    }
    
    func displayPlayer(){
        print("---------------------------------- \n \t Main Hand:")
        playerHand.displayHand()
        print("\n")
        print("""
            Special Hands:
        Face Down:
        """, terminator: "")
        playerHand.displayFaceDown()
        print("\n")
        print("Face Up: ", terminator: "")
        playerHand.displayFaceUp()
        print("\n")
        print("|-------PLAYER---------------------|")
        //print("\n")
    }

}
