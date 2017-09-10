module world.event.Event;

import world.World;

/**
 * An enum with event names and the number that exist in the world at any time.
 * These will automatically be imported to AllEvents when added here.
 * Each event corresponds to a number which is how many times that event is added to all events
 * In other words, the number that is attached to each event name is how many of those events can exist at max
 */
enum EventNames {
    RainStorm = 5,
}

Event[] allEvents;  ///A list of all the events to be used in the world

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

    int getInverseChanceToHappen();  ///Returns 1 / the chance of this event happening
    void turnAction();               ///The action taken when the event is occuring.
    Coordinate[] coordsAffected();   ///Returns any coords corresponding to tiles affected by the event.

}
