module world.event.Event;

/**
 * Handles all (possibly RNG) events during the game.
 */
abstract class Event{

    public bool isInProgress;   ///Whether the event is happening right now

    /**
     * The action taken when the event starts.
     */
    public abstract void startAction(){
        this.isInProgress = true;
    }

    /**
     * The action taken when the event ends.
     */
    public abstract void endAction(){
        this.isInProgress = false;
    }

    public abstract void turnAction();          ///The action taken when the event is occuring.
    public abstract int[][] coordsAffected();   ///Returns any coords corresponding to tiles affected by the event.
    public abstract bool canHappen();           ///Returns whether the even can happen.

}
