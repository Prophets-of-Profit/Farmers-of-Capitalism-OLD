module logic.actor.Actor;

import graphics.Constants;
import logic.world.Coordinate;

/**
 * A unit on the map
 * TODO: movement distances
 */
class Actor {

    private Coordinate _location; ///The location of the player in the world
    int maxTravellableDistance; ///The maximum number of tiles the player can move in one turn
    int numMovesLeft; ///The number of tiles the player can move this turn
    private Image _avatar = Image.UnitCapitalManGreen; ///The image of the actor to display on the tile

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
     * Constructs a new actor, placing it at the target location
     */
    this(Coordinate location) {
        this._location = location;
    }

}