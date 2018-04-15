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

    this(ulong worldSize, int numPlayers) {
        this._world = new GameWorld(worldSize);
        foreach(i; 0..numPlayers) {
            this._players ~= new Player(new Coordinate(0, 0)); 
        }
    }

}