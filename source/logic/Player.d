module logic.Player;

import logic.actor.Actor;
import logic.world.Coordinate;

/**
 * A game's player; handles everything a player can do
 */
class Player {

    long money; ///How much cash the player has
    private Actor[] _controlledUnits; ///Which units are under the player's control

    /**
     * Returns the player's list of controlled units. The figurehead unit should always be te first element
     */
    @property Actor[] controlledUnits() {
        return this._controlledUnits;
    }

    /**
     * Creates a player starting at a given location
     * Gives that player a figurehead unit
     */
    this(Coordinate start) {
        this._controlledUnits ~= new Actor(start);
    }

}