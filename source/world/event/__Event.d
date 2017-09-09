module world.event.Event;

import world.World;

/**
 * Handles all (possibly RNG) events during the game.
 */
abstract class Event{

    public bool isInProgress;   ///Whether the event is happening right now

    /**
     * The action taken when the event starts.
     */
    void startAction(){
        this.isInProgress = true;
    }

    /**
     * The action taken when the event ends.
     */
    void endAction(){
        this.isInProgress = false;
    }

    void turnAction();               ///The action taken when the event is occuring.
    Coordinate[] coordsAffected();   ///Returns any coords corresponding to tiles affected by the event.
    bool canHappen();                ///Returns whether the event can happen.

}
