module logic.actor.Actor;

import std.algorithm;
import std.array;
import graphics.Constants;
import logic.Player;
import logic.world.Coordinate;

/**
 * A unit on the map
 * TODO: movement distances
 */
class Actor {

    private Coordinate _location; ///The location of the player in the world
    int maxTravellableDistance = 15; ///The maximum number of movement points the player can have in one turn
    int numMovesLeft = 10; ///The number of movement points the player has this turn
    private Image _avatar = Image.UnitCapitalManGreen; ///The image of the actor to display on the tile
    Player controller; ///The player that can move this unit

    /**
     * Gets the actor's image avatar
     */
    @property Image avatar() {
        return this._avatar;
    }

    /**
     * Gets where the actor is
     */
    @property Coordinate location() {
        return this._location;
    }

    /**
     * Gets the movement cost for this unit to go to any coordinate
     */
    @property uint[Coordinate] distances() {
        return this.controller.game.world.getDistances(this.location, this.numMovesLeft);
    }

    /**
     * Gets the tiles the actor can reach this turn
     */
    @property Coordinate[] reachableTiles() {
        uint[Coordinate] distances = this.distances;
        return distances.keys.filter!(a => distances[a] <= this.numMovesLeft).array;
    }

    /**
     * Constructs a new actor, placing it at the target location
     */
    this(Coordinate location, Player controller) {
        this._location = location;
        this.controller = controller;
    }

    /**
     * Gets the shortest path from this unit to a given tile
     */
    Coordinate[] getShortestPath(Coordinate end) {
        uint[Coordinate] distances = this.distances;
        if(end !in distances) return null;
        return this.controller.game.world.getShortestPath(this.location, end);
    }

    /**
     * Attempts to move the actor to a coordinate
     * If successful, returns true
     */
    bool move(Coordinate end) {
        uint[Coordinate] distances = this.distances;
        if(end !in distances) return false;
        if(distances[end] > this.numMovesLeft) return false;
        this._location = end;
        this.numMovesLeft -= distances[end];
        return true;
    }

}