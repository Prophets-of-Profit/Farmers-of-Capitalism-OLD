module logic.Player;

import logic.item.Inventory;
import logic.world.Coordinate;
import logic.world.World;

/**
 * A list of what attributes a player can have along with their costs 
 */
enum Attribute {
    CAN_SEE_GENETICS = 500 //TODO: actually set this to something real; test example is that the can see genetics attribute costs 500
}

/**
 * A class for each player to control
 * Contains basic data for each player
 */
class Player {

    long money; ///How much money the player has
    Attribute[] attributes; ///What attributes the player has
    private Coordinate _location; ///The location of the player in the world
    int maxTravellableDistance; ///The maximum number of tiles the player can move in one turn
    private double _numMovesLeft; ///The number of tiles the player can move this turn

    /**
     * Gets where the player is
     */
    @property Coordinate location() {
        return this._location;
    }

    /**
     * Gets the number of moves remaining this turn
     */
    @property double numMovesLeft() {
        return this._numMovesLeft;
    }

    /**
     * Constructs a new player object
     * Sets the player's location to the given coordinate
     */
    this(Coordinate location) {
        this._location = location;
    }

    /**
     * Moves the player one tile in the specified direction.
     */
    void move(Direction direction) {
        this._location = new Coordinate(this.location.q + coordChangeByDirection[direction][0], this.location.r + coordChangeByDirection[direction][1]);
        this._numMovesLeft -= 0; //TODO: get this number and replace 0
    }

    /**
     * Returns whether or not moving one tile in the given direction can be made
     */
    bool canMoveBeMade(Direction direction, World world) {
        return world.tiles[world.getAdjacencies(this.location)[direction]].movementCost <= this.numMovesLeft;
    }

}
