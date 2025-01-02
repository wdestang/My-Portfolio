/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package blackjackgame;

/**
 *
 * @author desta
 */
import java.util.ArrayList;
import java.util.List;

public class Hand {
    private final List<Card> cardsInHand;

    public Hand() {
        cardsInHand = new ArrayList<>();
    }

    public void addCard(Card card) {
        cardsInHand.add(card);
    }
    
    public int size() {
        return cardsInHand.size();  // Returns the number of cards in the hand
    }

    public int calculateTotal() {
        int total = 0;
        int aceCount = 0;

        for (Card card : cardsInHand) {
            total += card.getValue();
            if (card.getRank() == Card.Rank.ACE) aceCount++;
        }

        while (total > 21 && aceCount > 0) {
            total -= 10;
            aceCount--;
        }

        return total;
    }

    public boolean isBust() {
        return calculateTotal() > 21;
    }
    
    public List<Card> getCardsInHand() {
        return cardsInHand; // Returns the list of cards in hand
    }
    
    @Override
    public String toString() {
        return cardsInHand.toString();
    }
}

