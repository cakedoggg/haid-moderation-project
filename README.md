# Moderation Project
### From Java to Swift

For my moderation project, I decided to take **Lab 2: A Deck Class** from my Fall 2019 _Data Structures_ class and recreate it in Swift. I decided on Swift because it is the most recent language I have learned. In Fall of 2020, I participated in the class _Design of Programming Languages_, which culminated a final project where my lab partner and I created a scheme interpreter in Swift. **Lab 2: A Deck Class** helped form the basis of my understanding object-oriented programming, with an extended lab assignment that had us use a Fisher-Yates algorithm to shuffle the deck and simulate a game of blackjack. I recreated the card, deck, and hand in Swift, but thought to change up the game, so here I have a simulation of the card game Idiot. My implementation of Idiot is unique, so here I would like to specify my game rules.

### Idiot
1. The purpose of this game is to lose all your cards by putting them on the Main Pile.
2. There must always be three cards in your Main Hand until the Deck is finished. You have a Special Hand which includes 3 Face Up and 3 Face Down cards. The Face Up portion can only be accessed when your main hand is empty, and the Face Down portion can only be accessed when both the main hand and Face Up portion are empty. The Face Down cards cannot be seen. 
3. The card you play must be equal to or higher than the card on the top of the Main Pile. If you have no card to play, you may collect the Main Pile, restarting it, OR draw from the Game Deck, and then it is the Dealer's turn. If you draw and the card is equal to or higher than the card on top of the Main Pile, the card is automatically played. However, if you draw and the card cannot be played, you must then collect the Main Pile and add it to your Main Hand.
4. There are special cards which need explaining.<br />
----> Card 2: universal restart card, it can be played on top of anything and does not affect the Main Pile<br />
----> Card 10: universal burn card, it can be played on top of anything and burns the Main Pile<br />
      -------> if you play 10, because the Main Pile is burned, you must then provide a second card to begin the new Main Pile<br />
----> Card 5: reverse card, meaning that the next card placed on the Main Pile must be equal to or lower than five<br />
5. Here is the basic usage for this specific implementation:<br />
----> Type p to play, d to draw, c to collect, h for help, and q to quit<br />
----> After typing p, you must type the card value (2, 6, jack, ace) to play that card<br />

### Design Choices and Comparing Implementations 
#### Card and Deck

#### Hand and Idiot

### Goals going forward
It is safe to say that the dealer you play against is quite dumb. As of now, it does not take the risk of drawing a card and it does not play the 10 or 2 cards when it is most beneficial to the game. In the future, I would like to improve the dealer so that it takes more risks with the cards it plays. Another issue is that the games take a very long time. This means a quicker game is ideal, and can be done my implementing a system where the player and dealer can play double cards, so if they have cards of the same value they can play them together in a single turn. In terms of the shortcomings of the program itself, there are also still a couple of glaring problems. Most troublesome is that there is no error handling outside of consoleIO, card, and deck. An improved implementation would require robust error handling in every class. Furthermore, there are two big bugs, the first one being that when collect() relies too heavily on the Game Deck having cards. When collect() is called and the player/dealer collects the cards from the Main Pile, the card which restarts the Main Pile is drawn from the deck. This means that once the deck is gutted, there is no system in place to restart the Main Pile. Secondly, in Hand's getMinCardSet(), the min(by:) instance method included in any Swift Set will occasionally returns a nil value. I have been unable to find the source of this, and have created the fallback variable to make sure the game keeps going, but does not take care of the problem. Finally, I still have to implement a way for the player to access the Face Down portion of their hand. While this can be  done by checking for the user to input "facedown", check that this portion still has cards, and play one of them randomly, I have been more occupied with handling the previous errors, but I recognize that this piece is integral.

