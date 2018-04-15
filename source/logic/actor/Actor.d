module logic.actor.Actor;

import logic.world.Coordinate;

/**
 * A unit on the map
 */
class Actor {

    private Coordinate _location; ///The location of the player in the world
    int maxTravellableDistance; ///The maximum number of tiles the player can move in one turn
    int numMovesLeft; ///The number of tiles the player can move this turn

    /**
     * Gets where the actor is
     */
    @property Coordinate location() {
        return this._location;
    }

    /**
     * Constructs a new actor, placing it at the target location
     */
    this(Coordinate location) {
        this._location = location;
    }

}