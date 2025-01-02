/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package blackjackgame;

/**
 *
 * @author desta
 */
class Player {
    private String name;
    private final Hand hand;

    public Player(String name) {
        this.name = name;
        this.hand = new Hand();
    }

    public void hit(Card card) {
        hand.addCard(card);
    }

    public void stand() {
        System.out.println(name + " stands.");
    }

    public boolean checkBust() {
        return hand.isBust();
    }

    public int getHandTotal() {
        return hand.calculateTotal();
    }

    public String getName() {
        return name;
    }

    public Hand getHand() {
        return hand;  // Returns the Hand object
    }

    @Override
    public String toString() {
        return hand.toString();
    }
}


