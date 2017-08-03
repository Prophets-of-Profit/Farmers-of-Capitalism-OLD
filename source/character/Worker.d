module character.Worker;

import character.Character;
import item.Item;

/**
 * A basic class for a worker
 * Extends the character class, but would also extend the item class if multiple inheritance was allowed
 * Indirectly extends item through its instancedata below
 */
class Worker: Character{

    Item selfAsItem;        ///The implementation of the worker in an item form
    alias selfAsItem this;  ///Makes it so the worker can be accessed and used as an item

    /**
     * A constructor for a player that just calls the Character constructor
     * Params:
     *      coords = the coordinates of the worker
     */
    this(int[] coords){
        super(coords);
    }

}
