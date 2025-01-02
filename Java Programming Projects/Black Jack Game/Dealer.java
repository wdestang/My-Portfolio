/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package blackjackgame;

/**
 *
 * @author desta
 */
public class Dealer extends Player {
    public Dealer() {
        super("Dealer");
    }

    //Dealer revealing hidden card
    public void flipHiddenCard() {
        System.out.println("Dealer reveals the hidden card.");
    }
}

