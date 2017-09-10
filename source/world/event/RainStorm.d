module world.event.RainStorm;

import std.conv;

import app;
import world.event.Event;
import world.HexTile;
import world.World;

/**
 * Rainstorms are events that //TODO
 */
class RainStorm : Event {

    Coordinate currentEffected;

    /**
     * Rainstorms have 1/20 chance of happening.
     */
    override int getInverseChanceToHappen(){
        return (50 / game.mainWorld.getTileAt(currentEffected).climate[TileStat.WATER]).to!int;
    }

    /**
     * Increase plant growth rate on the tile.
     * Have a chance to move the rainstorm to tile that wind blows to.
     * Reduce duration timer. If duration is zero, deactivate the rainstorm.
     */
    override void turnAction(){
        //TODO: implement
    }

    /**
     * Return the tile which the rainstorm is currently on.
     */
    override Coordinate[] coordsAffected(){
        return [currentEffected];
    }

}
