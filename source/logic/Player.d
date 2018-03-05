module logic.Player;

import std.algorithm;
import logic.item.Inventory;
import logic.world.Coordinate;
import logic.world.World;

/**
 * An unlockable upgrade that can be bought
 * Upgrades are like items but are permanent to a player
 */
struct Upgrade {
    immutable string name; ///The name of the upgrade
    immutable string description; ///A description of what the upgrade does
    immutable long cost; ///How much the upgrade costs
    int amount; ///How many of these upgrades exist; a negative amount means infinite of these upgrades exist
}

/**
 * A list of what attributes a player can have along with their costs
 * 
 */
enum Attribute {
    CAN_SEE_GENETICS = Upgrade("Genetics Glasses", "Gives you the ability to see a plant's genetics.", 15_000, -1) //TODO: actually set this to something real; test example is that the can see genetics attribute costs 15,000
}

/**
 * A class for each player to control
 * Contains basic data for each player
 */
class Player {

    long money; ///How much money the player has
    private Attribute[] _attributes; ///What attributes the player has
    private Coordinate _location; ///The location of the player in the world
    int maxTravellableDistance; ///The maximum number of tiles the player can move in one turn
    private double _numMovesLeft; ///The number of tiles the player can move this turn

    /**
     * Gets all the player's attributes
     */
    @property Attribute[] attributes() {
        return this._attributes;
    }

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
     * Returns all the coordinates the player can move to
     */
    Coordinate[] validMoves() {
        return null; //TODO:
    }

    /**
     * Moves the player one tile in the specified direction.
     */
    void move(Coordinate coord) {
        //TODO:
    }

    /**
     * Attempts to buy an attribute; returns success
     */
    bool buyAttribute(Attribute attrib) {
        if (this.money < attrib.cost || this._attributes.canFind(attrib) || attrib.amount <= 0) {
            return false;
        }
        this.money -= attrib.cost;
        this._attributes ~= attrib;
        attrib.amount--;
        return true;
    }

}
