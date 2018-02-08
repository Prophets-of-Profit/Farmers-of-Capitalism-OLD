module logic.Player;

import logic.item;
import logic.world;

/**
 * A class for each player to control
 * Contains basic data for each player
 * TODO: player inventories as arrays of items
 */
class Player {

    private Coordinate _location; ///The location of the player in the world
    private int _maxTravellableDistance; ///The maximum number of tiles the player can move in one turn
    private double _numMovesLeft; ///The number of tiles the player can move this turn
    private int _maxHealth; ///The highest number of health points this player can have
    private int _currentHealth; ///The current number of health points this player has

    /** 
     * Gets the player's location
     */
    @property Coordinate location() {
        return this._location;
    }

    /**
     * Set the player's location
     */
    @property void location(Coordinate newLocation) {
        this._location = newLocation;
    }

    /**
     * Gets the max tiles the player can move
     */
    @property int maxTravellableDistance() {
        return this._maxTravellableDistance;
    }

    /**
     * Sets the max tiles the player can move
     */
    @property void maxTravellableDistance(int newDistance) {
        this._maxTravellableDistance = newDistance;
    }

    /**
     * Gets the number of moves remaining this turn
     */
    @property double numMovesLeft() {
        return this._numMovesLeft;
    }

    /**
     * Gets the current health of the player
     */ 
    @property int currentHealth() {
        return this._currentHealth;
    }

    /**
     * Sets the current health of the player
     */
    @property void currentHealth(int newCurrentHealth) {
        this._currentHealth = newCurrentHealth;
    }

    /**
     * Constructs a new player object
     * Sets the player's location to the given coordinate
     */
    this(Coordinate location) {
        this.location = location;
    }

    /**
     * Moves the player one tile in the specified direction.
     */
    void move(Direction direction) {
        this.location = new Coordinate(this.location.q + coordChangeByDirection[direction][0], this.location.r + coordChangeByDirection[direction][1]);
    }

    /**
     * Returns whether or not moving one tile in the given direction can be made
     */
    bool canMoveBeMade(Direction direction, World world) {
        return world.tiles[world.getAdjacencies(this.location)[direction]].movementCost <= this.numMovesLeft;
    }

}