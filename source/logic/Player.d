module logic.Player;

import logic.item;
import logic.world;

/**
 * A class for each player to control
 * Contains basic data for each player
 */
class Player {

    Coordinate location; ///The location of the player in the world
    int maxTravellableDistance; ///The maximum number of tiles the player can move in one turn
    double numMovesLeft; ///The number of tiles the player can move this turn
    int maxHealth; ///The highest number of health points this player can have
    int currentHealth; ///The current number of health points this player has
    Inventory inventory; ///The player's items which they are carrying

    /**
     * Constructs a new player object
     * Sets the player's location to the given coordinate
     */
    this(Coordinate location) {
        this.location = location;
    }

}