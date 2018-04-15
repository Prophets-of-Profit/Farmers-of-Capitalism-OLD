module logic.Player;

import logic.actor.Actor;
import logic.Game;
import logic.world.Coordinate;

/**
 * A game's player; handles everything a player can do
 */
class Player {

    long money; ///How much cash the player has
    private Actor[] _controlledUnits; ///Which units are under the player's control
    private Game _game; ///The game the player is in

    /**
     * Returns the player's list of controlled units. The figurehead unit should always be the first element
     */
    @property Actor[] controlledUnits() {
        return this._controlledUnits;
    }

    /**
     * Returns the game the player is playing
     */
    @property Game game() {
        return this._game;
    }

    /**
     * Creates a player starting at a given location
     * Gives that player a figurehead unit
     */
    this(Coordinate start, Game game) {
        this._game = game;
        this._controlledUnits ~= new Actor(start, this);
    }

}