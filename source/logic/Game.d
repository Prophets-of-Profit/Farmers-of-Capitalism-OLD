module logic.Game;

import logic.world.Coordinate;
import logic.world.GameWorld;
import logic.Player;

/**
 * A game object
 * Stores objective game information
 * TODO: serializability
 */
class Game {

    private Player[] _players; ///The game's players
    private GameWorld _world; ///The world on which the game is played
    private ulong _turns; ///The number of turns the world has advanced so far
    uint player; ///Which player's turn it is, as an index of _players

    /**
     * Returns a list of players
     */
    @property Player[] players() {
        return this._players;
    }

    /**
     * Returns the world
     */
    @property GameWorld world() {
        return this._world;
    }

    /**
     * Returns how many turns have passed
     */
    @property ulong turns() {
        return this._turns;
    }

    /**
     * Constructs a new game
     * Creates a new world of specified size 
     * Creates a specified number of players
     */
    this(ulong worldSize, int numPlayers) {
        this._world = new GameWorld(worldSize, this);
        foreach(i; 0..numPlayers) {
            this._players ~= new Player(new Coordinate(0, 0), this); 
        }
    }

    /**
     * Advances the game one player-turn
     */
    void advanceTurn() {
        this.player = (this.player + 1) % (this._players.length - 1);
        if(this.player == 0) {
            this._turns += 1;
        }
    }

}