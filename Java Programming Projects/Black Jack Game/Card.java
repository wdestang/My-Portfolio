/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package blackjackgame;

/**
 *
 * @author desta
 */
public class Card {
    private Rank rank;  // Using enum for rank
    private Suit suit;  // Using enum for suit

    public Card(Rank rank, Suit suit) {
        this.rank = rank;
        this.suit = suit;
    }

    // Getter for rank
    public Rank getRank() {
        return rank;
    }

    // Getter for value (from rank)
    public int getValue() {
        return rank.getValue();
    }

    // Override toString to display rank and suit
    @Override
    public String toString() {
        return rank + " of " + suit;
    }

    // Enum for Rank with associated values
    public enum Rank {
        TWO(2), THREE(3), FOUR(4), FIVE(5), SIX(6), SEVEN(7), EIGHT(8), NINE(9),
        TEN(10), JACK(10), QUEEN(10), KING(10), ACE(11);

        private final int value;

        Rank(int value) {
            this.value = value;
        }

        public int getValue() {
            return value;
        }
    }

    // Enum for Suit
    public enum Suit {
        HEARTS, DIAMONDS, CLUBS, SPADES;
    }
}

