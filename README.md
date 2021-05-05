# Moderation Project
### From Java to Swift

For my moderation project, I decided to take **Lab 2: A Deck Class** from my Fall 2019 _Data Structures_ class and recreate it in Swift. I decided on Swift because it is the most recent language I have learned. In Fall of 2020, I participated in the class _Design of Programming Languages_, which culminated a final project where my lab partner and I created a scheme interpreter in Swift. **Lab 2: A Deck Class** helped form the basis of my understanding object-oriented programming, with an extended lab assignment that had us use a Fisher-Yates algorithm to shuffle the deck and simulate a game of blackjack. I recreated the card and deck in Swift, but thought to change up the game, so here I have a simulation of the card game Idiot. My implementation of Idiot is unique, so here I would like to specify my game rules.

### Idiot
1. The purpose of this game is to lose all your cards by putting them on the Main Pile.
2. There must always be three cards in your Main Hand until the Deck is finished. You have a Special Hand which includes 3 Face Up and 3 Face Down cards. The Face Up portion can only be accessed when your main hand is empty, and the Face Down portion can only be accessed when both the main hand and Face Up portion are empty. The Face Down cards cannot be seen. 
3. The card you play must be equal to or higher than the card on the top of the Main Pile. If you have no card to play, you may collect the Main Pile, restarting it, OR draw from the Game Deck, and then it is the Dealer's turn. If you draw and the card is equal to or higher than the card on top of the Main Pile, the card is automatically played. However, if you draw and the card cannot be played, you must then collect the Main Pile and add it to your Main Hand.
4. There are special cards which need explaining.<br />
----> Card 2: universal restart card, it can be played on top of anything and does not affect the Main Pile<br />
----> Card 10: universal burn card, it can be played on top of anything and burns the Main Pile<br />
      -------> if you play 10, because the Main Pile is burned, you must then provide a second card to begin the new Main Pile<br />
----> Card 5: reverse card, meaning that the next card placed on the Main Pile must be equal to or lower than five<br />
5. The card values are ranked as follows: 2, 3, 4, 5, 6, 7, 8, 9, 10, J, Q, K, A
6. Here is the basic usage for this specific implementation:<br />
----> Type p to play, d to draw, c to collect, h for help, and q to quit<br />
----> After typing p, you must type the card value (2, 6, jack, ace) to play that card<br />
7. To play the game, run interactiveMode() by running main.swift without any arguments.

### Comparing Implementations 
#### Card and Deck
The clearest overlap between Java and Swift is that a Card object is initialized almost identically. Here, I will show some of the differences in Card. In Java, a Card consists of a suit and value, with the suits represented as an enum and the values as an array of Strings. The Card Class also has a large amount of global variables, such as minVal and maxVal, which are supposed to assist with throwing exceptions and creating the deck. Both pieces of Card also require their own toString() and get methods, as shown below:
```Java
//get 
    public Suit suit() { return suit; }  
    public int value() { return value; } 
//to string
    public String getSuitString()
    {
	return suit.toString();
    }

    public String getValueString()
    {
	final String[] names = 
	    {"ace","two","three","four","five","six","seven",
	     "eight","nine","ten","jack","queen","king"};
	return names[value - MINVAL];
    }

    public String toString() {
	return "(" + getValueString() + ", " + getSuitString() + ")";
    }
    
```
In Swift, the Card class is represented as two enumerations, each conforming to **CustomStringConvertible** protocol. In Swift, any type which conforms to **CustomStringConvertible** provides its own representation to be used when converting an instance to a string, meaning there is no need for toString() methods, and an instance variable **description** is used instead. Below is the Card class's use of this protocol:
```Swift
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

```
Moving on to Deck, you can see that the difference in error handling is also worth nothing. Let's look at dealCard(). In this implementation, dealCard() borrrows from Java's Stack class and throws an exception.
```Java
public Card dealCard(){
  if (deck.empty())
      throw new RuntimeException("Deck is empty.");
  discard.push(deck.pop());
  return discard.peek();
}
```
In Swift, however, I implemented Deck as an array of Cards, and not a stack. I later did create my own Stack class, but I only used this to create the Main Pile which played cards are pushed onto. Going back to my original point, error handling is Swift can be very simple, especially if you take advantage of the **guard** keyword, which traps invalid parameters from being passed to a method.
```Swift
func dealCard() throws -> Card  {
        guard numDealt < Deck.count-1 else{
            throw DeckError.NoSuchElementException(msg: "Cannot deal card because there are no more cards in the deck.")
        }
        numDealt += 1
        return self.Deck[numDealt]
    }
```

In Java, I implemented the Fisher-Yates algorithm to shuffle the deck. 
```Java
    public void shuffle() {
    Card temp; //used as a temp to store value in order to swap 2 cards
    int j; //used to store randomly generated number
    for(int i = deck.length-1; i >= 0; i--) //
    {
        j = rand.nextInt(i+1); //generates random number between 0 and 52
        temp = deck[i]; //temp = a
        deck[i] =  deck[j];//a = b
        deck[j] = temp;//b = temp
    	}
    }
```
The shuffle algorithms in each language are almost identical in form, but what caught my attention in the Swift version was how the reversed for loop and random number generator work. Java requires you to import java.util.Random in order to make use of the Random class. Swift, on the other hand, uses a native function to generate random numbers, but up until last year it used the imported C function arc4random(). Because for loops in Swift are silly, my workaround for iterating over the Deck from n-1 to 1 was to iterate over a reversed Deck by using the function reversed(). 
```Swift
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

```

### Hand and User Interaction
Here I will explain a few of the functions in the Hand and Idiot classes to make the implementation clear. A Hand is made up of 3 sets, hand, faceDown, and faceUp. When a hand is initialized, it fills each portion of the Hand with 3 cards. I chose to make them sets and not arrays because their order does not matter, and since they are being looked at/modified a lot I figured that a constant (O(1)) lookup time is worth it.
----> add() receives a card and inserts it into hand portion (straightforward because the portions faceDown and faceUp cannot be added to)
---->


### Goals going forward
It is safe to say that the dealer you play against is quite dumb. As of now, it does not take the risk of drawing a card and it does not play the 10 or 2 cards when it is most beneficial to the game. In the future, I would like to improve the dealer so that it takes more risks with the cards it plays. Another issue is that the games take a very long time. This means a quicker game is ideal, and can be done my implementing a system where the player and dealer can play double cards, so if they have cards of the same value they can play them together in a single turn. In terms of the shortcomings of the program itself, there are also still a couple of glaring problems. Most troublesome is that there is no error handling outside of consoleIO and deck. An improved implementation would require robust error handling in every class. Furthermore, there are two big bugs, the first one being that when collect() relies too heavily on the Game Deck having cards. When collect() is called and the player/dealer collects the cards from the Main Pile, the card which restarts the Main Pile is drawn from the deck. This means that once the deck is gutted, there is no system in place to restart the Main Pile. Secondly, in Hand's getMinCardSet(), the min(by:) instance method included in any Swift Set will occasionally returns a nil value. I have been unable to find the source of this, and have created the fallback variable to make sure the game keeps going, but does not take care of the problem. Finally, I still have to implement a way for the player to access the Face Down portion of their hand. While this can be  done by checking for the user to input "facedown", check that this portion still has cards, and play one of them randomly, I have been more occupied with handling the previous errors, but I recognize that this piece is integral.

