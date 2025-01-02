/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package blackjackgame;

/**
 *
 * @author desta
 */
import java.util.Scanner;

public class Game {
    private final Deck deck;
    private final Player player;
    private final Dealer dealer;

    public Game(String playerName) {
        deck = new Deck();
        player = new Player(playerName);
        dealer = new Dealer();
    }

    public void startGame() {
        System.out.println("Starting Blackjack Game...");

        // Initial Deal
        player.hit(deck.drawCard());
        dealer.hit(deck.drawCard()); // Dealer's face-up card
        player.hit(deck.drawCard());
        dealer.hit(deck.drawCard()); // Dealer's face-down card
      
        System.out.println("Player's hand: " + player.getHand());
        System.out.println("Dealer's hand: [hidden], " + dealer.getHand().getCardsInHand().get(1));
        
        // Check if Player has Blackjack
        if (player.getHand().size() == 2 && player.getHandTotal() == 21) {
            System.out.println("Player has a Blackjack! Player wins!");
            return; // Player wins, game ends
        }

        Scanner scanner = new Scanner(System.in);
        boolean playerTurn = true;

        while (playerTurn) {
            System.out.println("Do you want to 'hit' or 'stand'? ");
            String action = scanner.nextLine().toLowerCase();
            if (action.equals("hit")) {
                player.hit(deck.drawCard());
                System.out.println("Player's hand: " + player);
                if (player.checkBust()) {
                    System.out.println("Player busts! Dealer wins.");
                    return;
                }
            } else if (action.equals("stand")) {
                player.stand();
                playerTurn = false;
            } else {
                System.out.println("Invalid action. Please choose 'hit' or 'stand'.");
            }
        }

        dealer.flipHiddenCard();
        System.out.println("Dealer's hand: " + dealer);
        
        if (dealer.getHand().size() == 2 && dealer.getHandTotal() == 21) {
            System.out.println("Dealer has a Blackjack! Dealer wins!");
            return; // Dealer wins, game ends
        }

        while (dealer.getHandTotal() < 17) {
            dealer.hit(deck.drawCard());
            System.out.println("Dealer's hand: " + dealer);
            if (dealer.checkBust()) {
                System.out.println("Dealer busts! Player wins.");
                return;
            }
        }

        // Determine the winner after both player and dealer have completed their turns
        determineWinner();
    }

    public void determineWinner() {
    int playerTotal = player.getHandTotal();
    int dealerTotal = dealer.getHandTotal();

    // Check for busts before comparing totals
    if (player.checkBust()) {
        System.out.println("Player busts! Dealer wins.");
    } 
    else if (dealer.checkBust()) {
        System.out.println("Dealer busts! Player wins.");
    } 
    else {
        System.out.println("Player's total: " + playerTotal);
        System.out.println("Dealer's total: " + dealerTotal);

        if (playerTotal > dealerTotal) {
            System.out.println("Player wins!");
        } 
        else if (playerTotal < dealerTotal) {
            System.out.println("Dealer wins!");
        } 
        else {
            System.out.println("It's a tie!");
        }
    }
}

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.println("Enter your name: ");
        String playerName = scanner.nextLine();
        Game game = new Game(playerName);
        game.startGame();
    }
}

