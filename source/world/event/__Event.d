module world.event.Event;

import std.conv;

import world.World;


/**
 * An enum with event names and the number that exist in the world at any time.
 * These will automatically be imported to AllEvents when added here.
 */
enum EventNames {
    RainStorm = 5,
}

/**
 * Initializes all of the events, adding them to allEvents.
 */
static this(){
    foreach(name; __traits(allMembers, EventNames)){
        mixin("import world.event." ~ name ~ ";");
        foreach(i; 0..name.to!EventNames.to!int){
            mixin("allEvents ~= new " ~ name ~ "();");
        }
    }
}

Event[] allEvents;      ///A list of all the events to be used in the world

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
