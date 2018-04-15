module logic.world.GameWorld;

import logic.actor.Actor;
import logic.Game;
import logic.world.Coordinate;
import logic.world.World;

/**
 * A world used specifically in the game
 * Contains game logic like procedural gen, buildings, etc.
 */
class GameWorld : World {

    Game game; ///The game that is being played on this world

    /**
     * Returns all the actors on the map at the current time
     */
    @property Actor[] actors() {
        Actor[] units;
        foreach(player; this.game.players){
            foreach(unit; player.controlledUnits) {
                units ~= unit;
            }
        }
        return units;
    }

    /**
     * Associates every coordinate on which there are actors with a list of actors on it
     */
    @property Actor[][Coordinate] locatedActors() {
        Actor[][Coordinate] units;
        foreach(player; this.game.players) {
            foreach(unit; player.controlledUnits) {
                units[unit.location] = (unit.location in units)? (units[unit.location] ~ unit) : [unit];
            }
        }
        return units;
    }

    /**
     * The constructor for a world
     * TODO: worldgen
     */
    this(ulong size, Game game) {
        super(size);
        this.game = game;
    }

}