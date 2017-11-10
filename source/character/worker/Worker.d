module character.worker.Worker;

import character.Character;
import character.Race;
import item.Item;
import world.World;

/**
 * A basic class for a worker
 * Extends the character class, but would also extend the item class if multiple inheritance was allowed
 * Indirectly extends item through its instancedata below
 */
class Worker : Character {

    /**
     * A constructor for a player that just calls the Character constructor
     * Params:
     *      coords = the coordinates of the worker
     */
    this(Coordinate coords, Race race){
        super(coords, race);
    }

}
